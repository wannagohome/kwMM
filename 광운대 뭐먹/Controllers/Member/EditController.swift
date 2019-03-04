//
//  EditController.swift
//  SettingUI
//
//  Created by Peter Jang on 17/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import PhotosUI

class EditController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
    let imagePicker = UIImagePickerController()
    var base64String: String = "null"
    var nicknameConfirmed: Bool = false
    var passwordConfirmed: Bool = false
    
    override func viewDidLoad() {
        
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        hideKeyboardWhenTappedAround()
        let backBTN = UIBarButtonItem(image: UIImage(named: "Back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.navigationBar.tintColor = .white
        view.backgroundColor = UIColor.white
        getImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPhotoLibray)))
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = "회원 정보 수정"
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = themeColor
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    func setupViews() {
        view.addSubview(getImageView)
        
        view.addSubview(nicknameTextField)
        view.addSubview(nicknameConfirmLable)
        view.addSubview(passwordTextField)
        view.addSubview(passwordConfirmLable)
        view.addSubview(changePasswordButton)
        view.addSubview(changeNicknameButton)
        view.addSubview(changeProfileButton)
        
        
        getImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: nil,
                              bottom: nil,
                              trailing: nil,
                              padding: .init(top: view.bounds.height/7, left: 0, bottom: 0, right: 0),
                              size: .init(width: 150, height: 150))
        
        getImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let lable = UILabel()
        lable.text = "편   집"
        lable.textColor = UIColor.white
        lable.textAlignment = .center
        lable.backgroundColor = UIColor(white: 0, alpha: 0.5)
        getImageView.addSubview(lable)
        lable.anchor(top: nil,
                     leading: getImageView.leadingAnchor,
                     bottom: getImageView.bottomAnchor,
                     trailing: getImageView.trailingAnchor,
                     size: .init(width: 0, height: 20))

        nicknameTextField.anchor(top: getImageView.bottomAnchor,
                                 leading: nil,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: view.bounds.height/10, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 170, height: 30))
        nicknameTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -25).isActive = true
        nicknameConfirmLable.anchor(top: nicknameTextField.bottomAnchor,
                                    leading: nicknameTextField.leadingAnchor,
                                    bottom: nil,
                                    trailing: nil)
        changeNicknameButton.anchor(top: nicknameTextField.topAnchor,
                                    leading: nicknameTextField.trailingAnchor,
                                    bottom: nil,
                                    trailing: nil,
                                    padding: .init(top: 0, left: 15, bottom: 0, right: 0))
        passwordTextField.anchor(top: nicknameTextField.bottomAnchor,
                                 leading: nicknameTextField.leadingAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 30, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 170, height: 30))
        passwordConfirmLable.anchor(top: passwordTextField.bottomAnchor,
                                    leading: passwordTextField.leadingAnchor,
                                    bottom: nil,
                                    trailing: nil)
        if UserDefaults().bool(forKey: "google") {
            changePasswordButton.isEnabled = false
            passwordTextField.placeholder = "구글계정은 이용 불가"
            changePasswordButton.setTitleColor(UIColor.gray, for: .normal)
        }
        changePasswordButton.anchor(top: passwordTextField.topAnchor,
                                    leading: passwordTextField.trailingAnchor,
                                    bottom: nil,
                                    trailing: nil,
                                    padding: .init(top: 0, left: 15, bottom: 0, right: 0))
        changeProfileButton.anchor(top: passwordTextField.bottomAnchor,
                                   leading: nil,
                                   bottom: nil,
                                   trailing: nil,
                                   padding: .init(top: 20, left: 0, bottom: 0, right: 0))
        changeProfileButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func nicknameCheck(str: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9ㄱ-ㅎㅏ-ㅣ가-힣].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nicknameTextField {
            let nickname = textField.text!
            if nickname == "" {
                self.nicknameConfirmLable.text = "닉네임을 입력해 주세요"
                self.nicknameConfirmLable.textColor = UIColor.red
                self.nicknameConfirmLable.isHidden = false
                self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                self.nicknameConfirmed = false
            } else if nickname.count > 8 {
                self.nicknameConfirmLable.text = "길이 제한을 초과하였습니다"
                self.nicknameConfirmLable.textColor = UIColor.red
                self.nicknameConfirmLable.isHidden = false
                self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                self.nicknameConfirmed = false
            } else if nicknameCheck(str: nickname) {
                self.nicknameConfirmLable.text = "한글, 영어, 숫자만 사용 가능 합니다"
                self.nicknameConfirmLable.textColor = UIColor.red
                self.nicknameConfirmLable.isHidden = false
                self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                self.nicknameConfirmed = false
            } else {
                let dicToSend: [String: Any] = ["func":"checkusable nickname", "nickname":nickname]
                let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
                
                ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
                    if result.data! == "overlapped" {
                        self.nicknameConfirmLable.text = "이미 사용중인 닉네임 입니다"
                        self.nicknameConfirmLable.textColor = UIColor.red
                        self.nicknameConfirmLable.isHidden = false
                        self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                        self.nicknameConfirmed = false
                    } else {
                        self.nicknameConfirmed = true
                        self.nicknameConfirmLable.text = "사용가능한 닉네임 입니다"
                        self.nicknameConfirmLable.textColor = UIColor.blue
                        self.nicknameTextField.backgroundColor = UIColor.clear
                    }
                }
            }
        } else if textField == passwordTextField {
            let password = passwordTextField.text!
            if password.count < 8 {
                textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                passwordConfirmLable.text = "비밀번호는 8자 이상이 필요합니다"
                passwordConfirmLable.textColor = UIColor.red
                passwordConfirmLable.isHidden = false
                passwordConfirmed = false
            } else {
                passwordConfirmLable.text = "사용가능한 비밀번호 입니다"
                passwordConfirmLable.textColor = UIColor.blue
                textField.backgroundColor = UIColor.clear
                passwordConfirmed = true
            }
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        defer {
            picker.dismiss(animated: true)
        }
        guard var image = info[.originalImage] as? UIImage else {
            return
        }
        image = resizeImage(image: image, targetSize: .init(width: 300, height: 300))
        getImageView.image = image
//        getImageView.backgroundColor = UIColor.clear

        let imageData:NSData = image.pngData()! as NSData
        base64String = imageData.base64EncodedString(options: .lineLength64Characters)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        defer {
            picker.dismiss(animated: true)
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
    
    @objc func editInfo(_ sender: UIButton) {
        let id: String = UserDefaults().string(forKey: "id")!
        var dicToSend: [String:String] = [:]
        
        
        if sender.tag == 1 {
            if !nicknameConfirmed {
                showAlert(message: "닉네임 인증이 필요합니다")
                return
            }
            let nickname: String = nicknameTextField.text ?? ""
            dicToSend = ["func":"edit nickname", "id":id, "nickname":nickname]
        } else if sender.tag == 2 {
            if !passwordConfirmed {
                showAlert(message: "비밀번호 인증이 필요합니다")
                return
            }
            let password: String = passwordTextField.text?.getSha256String() ?? ""
            dicToSend = ["func":"edit pw", "id":id, "pw":password]
        } else if sender.tag == 3 {
            dicToSend = ["func":"edit profile", "id":id, "image":base64String]
        }
        
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (response: SimpleResponse) in
            switch response.data {
            case "success" :
                self.showAlert(message: "변경 되었습니다")
                if sender.tag == 1 {
                    UserDefaults.standard.set(self.nicknameTextField.text ?? "", forKey: "nickname")
                }
                break
            case "same" :
                self.showAlert(message: "이전 비밀번호와 동일합니다")
                break
            case "overlap" :
                self.showAlert(message: "이미 사용중인 닉네임 입니다")
                break
            case "fail" :
                self.showAlert(message: "네트워크 오류")
                break
            default :
                break
            }
        }
    }
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel)
            
            alertMessage.addAction(cancelAction)
            self.present(alertMessage, animated: true, completion: nil)
        }
    }
    
    let nicknameConfirmLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        return label
    }()
    
    let passwordConfirmLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        return label
    }()
    
    let getImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(cgImage: (UIImage(named: "avatarx1")?.cgImage)!, scale: 100, orientation: .up)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.backgroundColor = UIColor(white: 0.97, alpha: 1)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 170, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "변경할 닉네임"
        textField.clearsOnBeginEditing = true
        textField.textColor = UIColor.black
        textField.givePadding()
        textField.accessibilityIdentifier = "nicknmae edit textfield"
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 170, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "변경할 비밀번호"
        textField.clearsOnBeginEditing = true
        textField.textColor = UIColor.black
        textField.givePadding()
        textField.accessibilityIdentifier = "password edit textfield"
        return textField
    }()
    
    let changeNicknameButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setTitle("변경", for: .normal)
        button.setTitleColor(themeColor, for: .normal)
        button.addTarget(self, action: #selector(editInfo(_:)), for: .touchUpInside)
        return button
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton()
        button.tag = 2
        button.setTitle("변경", for: .normal)
        button.setTitleColor(themeColor, for: .normal)
        button.addTarget(self, action: #selector(editInfo(_:)), for: .touchUpInside)
        return button
    }()
    
    let changeProfileButton: UIButton = {
        let button = UIButton()
        button.tag = 3
        button.setTitle("변경", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(themeColor, for: .normal)
        button.addTarget(self, action: #selector(editInfo(_:)), for: .touchUpInside)
        return button
    }()
}
