//
//  WriteReviewController.swift
//  SettingUI
//
//  Created by Peter Jang on 04/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import PhotosUI
import Alamofire
import SwiftyJSON

class WriteReviewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextViewDelegate {
    var menuId: Int?
    
   
    var base64String: String = "null"
    var rate: Double = 0
    var isEdited: Bool = false
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        contentTextView.delegate = self
        
        ratingView.didFinishTouchingCosmos = { rate in self.rate = rate }
        view.backgroundColor = .white
        view.addSubview(goBackButton)
        view.addSubview(getImageView)
        view.addSubview(ratingView)
//        view.addSubview(contentTextView)
        view.addSubview(sendButton)
        view.addSubview(blankView)
        
        
        
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                            size: .init(width: 30, height: 30))
        getImageView.image = resizeImage(image: getImageView.image!, targetSize: .init(width: 80, height: 80))
        getImageView.contentMode = .center
        let lable = UILabel()
        lable.text = "사진  선택"
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.backgroundColor = UIColor(white: 0, alpha: 0.5)
        getImageView.addSubview(lable)
        lable.anchor(top: nil,
                     leading: getImageView.leadingAnchor,
                     bottom: getImageView.bottomAnchor,
                     trailing: getImageView.trailingAnchor,
                     size: .init(width: 0, height: 20))
        getImageView.anchor(top: ratingView.bottomAnchor,
                              leading: nil,
                              bottom: nil,
                              trailing: nil,
                              padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                              size: .init(width: 200, height: 120))
        getImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoLibray)))
        getImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        ratingView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 50, left: 0, bottom: 0, right: 0))
        ratingView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        blankView.anchor(top: getImageView.bottomAnchor,
                         leading: view.leadingAnchor,
                         bottom: nil,
                         trailing: view.trailingAnchor,
                         padding: .init(top: 30, left: 30, bottom: 0, right: 30),
                         size: .init(width: 0, height: 300))
        blankView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        blankView.addSubview(contentTextView)
        contentTextView.anchor(top: blankView.topAnchor,
                                leading: blankView.leadingAnchor,
                                bottom: blankView.bottomAnchor,
                                trailing: blankView.trailingAnchor,
                                padding: .init(top: 10, left: 10, bottom: 10, right: 10))
        
        sendButton.anchor(top: nil,
                          leading: nil,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: nil,
                          padding: .init(top: 20, left: 0, bottom: 40, right: 0),
                          size: .init(width: 280, height: 40))
        sendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if !isEdited {
            textView.text = String()
            textView.textColor = UIColor.black
            isEdited = true
        }
    }
    
    
    
    
    @objc func openPhotoLibray() {
        guard UIImagePickerController.isSourceTypeAvailable(.photoLibrary) else {
            return
        }

        let photoAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        
        switch photoAuthorizationStatus {
        case .authorized:
            present(imagePicker, animated: true)
            break
            
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({
                (newStatus) in
                
                if newStatus ==  PHAuthorizationStatus.authorized {
                    self.present(imagePicker, animated: true)
                } else {
                    self.showAlert(message: "사진 보관함 접근 권한이 필요합니다.")
                }
            })
            break
            
        default:
            showAlert(message: "사진 보관함 접근 권한이 필요합니다.")
            break
        }
        
    }
    
    @objc func sendReview() {
        
        let userId: String = UserDefaults().string(forKey: "id")!
        var content: String = contentTextView.text!
        if !isEdited { content = ""}
        let dicToSend: [String : Any] = ["func":"리뷰작성", "id":userId, "menuId":menuId!, "rate":rate, "contents":content, "image":base64String]
        
//        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
//            if result.data! == "작성성공"{
//                self.presentingViewController?.dismiss(animated: true)
//            } else if result.data! == "작성실패" {
//                self.showAlert(message: "리뷰 작성에 실패하였습니다")
//            } else if result.data! == "이미작성" {
//                self.showAlert(message: "리뷰는 메뉴당 한 개 씩만 작성 가능합니다")
//            }
//
//        }
        
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                let json:JSON = JSON(value)
                if json["data"].string == "작성성공"{
                    self.presentingViewController?.dismiss(animated: true)
                } else if json["data"].string == "작성실패" {
                    self.showAlert(message: "리뷰 작성에 실패하였습니다")
                } else if json["data"].string == "이미작성" {
                    self.showAlert(message: "리뷰는 메뉴당 한 개 씩만 작성 가능합니다")
                }
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
        
    }
    
    func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    let ratingView: CosmosView = {
        let ratingView  = CosmosView()
        ratingView.settings.fillMode = .half
        ratingView.settings.minTouchRating = 0
        ratingView.rating = 0
        ratingView.settings.filledColor = themeColor
        ratingView.starSize = 35
        ratingView.sizeToFit()
        ratingView.starMargin = 0
        
        return ratingView
    }()
    
    let getImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "camera")
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        button.accessibilityIdentifier = "리뷰작성에서 뒤로가기"
        button.addTarget(self, action: #selector(goBackToReviewController), for: .touchUpInside)
        return button
    }()
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.text = "리뷰 내용을 입력해 주세요"
        textView.textColor = UIColor.gray
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.textAlignment = .left
        return textView
    }()
    
    let blankView: UIView = {
        let bv = UIView()
        bv.layer.borderColor = UIColor.black.cgColor
        bv.layer.borderWidth = 0.7
        bv.layer.cornerRadius = 5
        bv.backgroundColor = UIColor.white
        return bv
    }()
    
    let sendButton : UIButton = {
        let button = UIButton()
        button.setTitle("리뷰 올리기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 17)
        button.accessibilityIdentifier = "리뷰 작성 버튼"
        button.backgroundColor = themeColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(sendReview), for: .touchUpInside)
        return button
    }()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        guard var image = info[.originalImage] as? UIImage else {
            return
        }
        image = resizeImage(image: image, targetSize: .init(width: 1024, height: 512))
        getImageView.image = image
//        getImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        getImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        getImageView.contentMode = .scaleAspectFit
        let imageData:NSData = image.pngData()! as NSData
        base64String = imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
        }
    }
    

    @objc func goBackToReviewController() {
        self.presentingViewController?.dismiss(animated: true)
    }
}

