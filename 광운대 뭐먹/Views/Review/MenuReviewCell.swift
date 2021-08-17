//
//  MenuReviewCell.swift
//  SettingUI
//
//  Created by Peter Jang on 25/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MenuReviewCell: ReviewBaseCell {
    

    override func setupViews() {
        
        
        contentView.accessibilityIdentifier = "MenuReviewCell contentView"
        super.setupViews()
        recommendButton.addTarget(self, action: #selector(recommendAction(_:)), for: .touchUpInside)
        reportButton.addTarget(self, action: #selector(showReportAlert), for: .touchUpInside)
        addSubview(recommendButton)
        addSubview(reportButton)
        addSubview(recommendNumberLable)
        addSubview(menuNameLabel)
        
        menuNameLabel.anchor(top: nil,
                             leading: nil,
                             bottom: nil,
                             trailing: recommendButton.leadingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        menuNameLabel.centerYAnchor.constraint(equalTo: recommendButton.centerYAnchor).isActive = true
        
        reportButton.anchor(top: nil,
                            leading: nil,
                            bottom: nil,
                            trailing: contentView.trailingAnchor,
                            padding: .init(top: 0, left: 0, bottom: 0, right: 10))
        reportButton.centerYAnchor.constraint(equalTo: recommendButton.centerYAnchor).isActive = true
        recommendButton.anchor(top: contentView.topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: reportButton.leadingAnchor,
                            padding: .init(top: 13, left: 0, bottom: 0, right: 0),
                            size: .init(width: 30, height: 30))
        
        recommendNumberLable.anchor(top: recommendButton.bottomAnchor,
                                    leading: nil,
                                    bottom: nil,
                                    trailing: nil,
                                    padding: .init(top: -3, left: 0, bottom: 0, right: 0))
        recommendNumberLable.centerXAnchor.constraint(equalTo: recommendButton.centerXAnchor).isActive = true
        
    }
    
    let menuNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        return label
    }()
    
    
    
    
    let reportButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "report button"
        button.setTitle("신고", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.clear
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 12)] as [NSAttributedString.Key : Any]
        let attributedText = NSAttributedString(string: button.currentTitle!, attributes: attributes)
        button.titleLabel?.attributedText = attributedText
        
        return button
    }()
    
    @objc func showReportAlert() {
        if UserDefaults().bool(forKey: "isLoggedIn") {
            DispatchQueue.main.async {
                let alertMessage = UIAlertController(title: "리뷰 신고", message: nil, preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "취소", style: .cancel)
                let reportAction = UIAlertAction(title: "신고", style: .destructive) { (_) in
                    let reportContentTextField = alertMessage.textFields![0]
                    
                    self.report(reportContentTextField.text ?? "")
                }
                reportAction.isEnabled = false
                
                alertMessage.addTextField(configurationHandler: {(textField) in
                    textField.placeholder = "신고 사유를 구체적으로 적어 주세요"
                    textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.top
                    textField.heightAnchor.constraint(equalToConstant: 180).isActive = true
                    NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {(notification) in
                        reportAction.isEnabled = textField.text != ""
                    })
                })
                
                alertMessage.addAction(cancelAction)
                alertMessage.addAction(reportAction)
                if self.dinnerController != nil {
                    self.dinnerController?.present(alertMessage, animated: true, completion: nil)
                } else if self.reviewController != nil {
                    self.reviewController?.present(alertMessage, animated: true, completion: nil)
                }
            }
        } else {
            if self.dinnerController != nil {
                self.dinnerController!.showAlert(message: "로그인 후에 가능합니다")
            } else {
                self.reviewController!.showAlert(message: "로그인 후에 가능합니다")
            }
        }
        
    }
    
    @objc func report(_ content: String) {
        let writerId = reviewJson?["id"].string
        let reviewId = reviewJson?["reviewId"].int
        
        let dicToSend: [String : Any] = ["func":"report","reviewId":reviewId!, "id":writerId!, "contents":content]
//        let dataToSend: Data = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        ApiService.shared.getData(dataToSend: dataToSend){ (response: SimpleResponse) in
//            if response.data == "신고 접수" {
//
//            } else if response.data == "이미 신고" {
//
//            }
//        }
        
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                let json:JSON = JSON(value)
                if json["data"].string == "신고 접수" {
                    if self.dinnerController != nil {
                        self.dinnerController!.showAlert(message: "신고가 접수되었습니다")
                    } else {
                        self.reviewController!.showAlert(message: "신고가 접수되었습니다")
                    }
                } else if json["data"].string == "이미 신고" {
                    if self.dinnerController != nil {
                        self.dinnerController!.showAlert(message: "이미 신고하신 리뷰 입니다")
                    } else {
                        self.reviewController!.showAlert(message: "이미 신고하신 리뷰 입니다")
                    }
                }
                
                
            case .failure(let error):
                print(error.localizedDescription)
                if self.dinnerController != nil {
                    self.dinnerController!.showAlert(message: "네트워크 오류")
                } else {
                    self.reviewController!.showAlert(message: "네트워크 오류")
                }
                
            }
        }
    }
    
    
    @objc func recommendAction(_ sender: UIButton) {
        let reviewId = sender.tag
        if id != ""{
            let dicToSend: [String: Any] = ["func":"recommend","reviewId":reviewId, "id":id]
//            let dataToSend: Data = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//            //FIXME: change view if needed
//            ApiService.shared.getData(dataToSend: dataToSend){ (response: SimpleResponse) in
//
//                if response.data! == "recommended" {
//                    self.recommendButton.setImage(UIImage(named: "thumbcolor"), for: .normal)
//                    self.recommendNumberLable.text = String(self.recommend! + 1)
//                    self.recommend! += 1
//                } else {
//                    self.recommendButton.setImage(UIImage(named: "thumb"), for: .normal)
//                    self.recommendNumberLable.text = String(self.recommend! - 1)
//                    self.recommend! -= 1
//                }
//            }
            
            AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                (responds) in
                switch responds.result {
                    
                case .success(let value):
                    let json:JSON = JSON(value)
                    if json["data"].string == "recommended" {
                        self.recommendButton.setImage(UIImage(named: "thumbcolor"), for: .normal)
                        self.recommendNumberLable.text = String(self.recommend! + 1)
                        self.recommend! += 1
                    } else {
                        self.recommendButton.setImage(UIImage(named: "thumb"), for: .normal)
                        self.recommendNumberLable.text = String(self.recommend! - 1)
                        self.recommend! -= 1
                    }
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    if self.dinnerController != nil {
                        self.dinnerController!.showAlert(message: "네트워크 오류")
                    } else {
                        self.reviewController!.showAlert(message: "네트워크 오류")
                    }
                    
                }
            }
        } else {
            if self.dinnerController != nil {
                self.dinnerController!.showAlert(message: "로그인 후에 가능합니다")
            } else {
                self.reviewController!.showAlert(message: "로그인 후에 가능합니다")
            }
        }
    }
}
