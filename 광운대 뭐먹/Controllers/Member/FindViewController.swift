//
//  FindController.swift
//  SettingUI
//
//  Created by Peter Jang on 17/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import Foundation
import UIKit

class FindViewController: UIViewController {
    struct Certify: Decodable {
        var data: String?
        var key: String?
    }
    var key: String?
    var insertedEmail: String?
    
    override func viewDidLoad() {
        self.hideKeyboardWhenTappedAround()
        view.backgroundColor = UIColor.white
        
        emailConfirmTextField.isHidden = true
        emailConfirmTextField.alpha = 0
        emailConfirmIconImageView.isHidden = true
        emailConfirmIconImageView.alpha = 0
        keyConfirmButton.isHidden = true
        keyConfirmButton.alpha = 0
        
        notiLable1.isHidden = true
        notiLable1.alpha = 0
        notiLable3.isHidden = true
        notiLable3.alpha = 0
        notiLable4.isHidden = true
        notiLable4.alpha = 0
        idLable.isHidden = true
        idLable.alpha = 0
        tempPwdButton.isHidden = true
        tempPwdButton.alpha = 0

        tempPasswordTextView.isHidden = true
        tempPasswordTextView.alpha = 0
        notiLable5.isHidden = true
        notiLable5.alpha = 0
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    func setupViews() {
        
        addSubviews(views: [logoImageView, goBackButton, emailIconImageView, emailConfirmIconImageView,
                            emailTextField, emailConfirmTextField, emailConfirmButton, keyConfirmButton,
                            notiLable1, notiLable3, notiLable4, idLable, tempPwdButton,
                            tempPasswordTextView, notiLable5])
        
        tempPwdButton.addTarget(self, action: #selector(getTempPassword), for: .touchUpInside)
        
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                            size: .init(width: view.bounds.width/10, height: view.bounds.width/10))
        
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: view.bounds.height/11, left: 0, bottom: 0, right: 0),
                             size: .init(width: 90, height: 145.8))
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        emailIconImageView.anchor(top: emailTextField.topAnchor,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: emailTextField.leadingAnchor,
                                  padding: .init(top: -10, left: 0, bottom: 0, right: 10),
                                  size: .init(width: 30, height: 30))
        emailTextField.anchor(top: logoImageView.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: nil,
                              trailing: nil,
                              padding: .init(top: view.bounds.height/13, left: view.bounds.width/3.5, bottom: 0, right: 0),
                              size: .init(width: 200, height: 25))
        emailConfirmIconImageView.anchor(top: emailIconImageView.bottomAnchor,
                                         leading: emailIconImageView.leadingAnchor,
                                         bottom: nil,
                                         trailing: nil,
                                         padding: .init(top: view.bounds.width/12, left: 0, bottom: 0, right: 0),
                                         size: .init(width: 30, height: 30))
        emailConfirmTextField.anchor(top: emailConfirmIconImageView.topAnchor,
                                     leading: emailConfirmIconImageView.trailingAnchor,
                                     bottom: nil,
                                     trailing: nil,
                                     padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                                     size: .init(width: 130, height: 25))
        keyConfirmButton.anchor(top: emailConfirmIconImageView.topAnchor,
                                leading: emailConfirmTextField.trailingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: .init(top: 0, left: 30, bottom: 0, right: 0),
                                size: .init(width: 40, height: 30))
        emailConfirmButton.anchor(top: emailIconImageView.bottomAnchor,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: nil,
                                  padding: .init(top: view.bounds.width/12, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 160, height: 30))
        emailConfirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        notiLable1.anchor(top: logoImageView.bottomAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: view.bounds.height/13, left: 0, bottom: 0, right: 0))
        notiLable1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        idLable.anchor(top: notiLable1.bottomAnchor,
                       leading: nil,
                       bottom: nil,
                       trailing: nil,
                       padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        idLable.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notiLable3.anchor(top: idLable.bottomAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 30, left: 10, bottom: 0, right: 0))
        notiLable3.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempPwdButton.anchor(top: notiLable3.bottomAnchor,
                             leading: view.centerXAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 0, left: -50, bottom: 0, right: 0))
        notiLable4.anchor(top: tempPwdButton.topAnchor,
                          leading: tempPwdButton.trailingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 7, left: 5, bottom: 0, right: 0))
        
        
        notiLable5.anchor(top: notiLable4.bottomAnchor,
                          leading: nil,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 80, left: 0, bottom: 0, right: 0))
        notiLable5.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tempPasswordTextView.anchor(top: notiLable5.bottomAnchor,
                                 leading: nil,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 5, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 200, height: 40))
        tempPasswordTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func addSubviews(views: [UIView]) {
        for tempview in views {
            view.addSubview(tempview)
        }
    }
    var userid: String?
    func simpleAnimation() {
        notiLable1.isHidden = false
        notiLable3.isHidden = false
        notiLable4.isHidden = false
        idLable.isHidden = false
        tempPwdButton.isHidden = false
        
        let webmail: String = emailTextField.text ?? ""
        let dicToSend: [String: Any] = ["func":"find2", "webmail":webmail]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        ApiService.shared.getData(dataToSend: dataToSend){ (result: FindID) in
            
            self.userid = result.id!
            let id:String = result.id!
            let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)] as [NSAttributedString.Key : Any]
            let attributedString = NSMutableAttributedString(string: id + " 입니다.")
            attributedString.addAttributes(attributes, range: (id + " 입니다." as NSString).range(of: id))
            attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: themeColor, range: (id + " 입니다." as NSString).range(of: id))
            self.idLable.attributedText = attributedString
            
            UIView.animate(withDuration: 0.7, animations: {
                self.emailIconImageView.alpha = 0
                self.emailTextField.alpha = 0
                self.emailConfirmIconImageView.alpha = 0
                self.emailConfirmTextField.alpha = 0
                self.keyConfirmButton.alpha = 0
                
                self.notiLable1.alpha = 1
                self.notiLable3.alpha = 1
                self.notiLable4.alpha = 1
                self.idLable.alpha = 1
                self.tempPwdButton.alpha = 1
                
            }, completion: { (bool: Bool) in
                self.emailIconImageView.isHidden = true
                self.emailTextField.isHidden = true
                self.emailConfirmIconImageView.isHidden = true
                self.emailConfirmTextField.isHidden = true
                self.keyConfirmButton.isHidden = true
            })
            
        }
        
    }
    
    @objc func keyConfirm() {
        keyConfirmButton.resignFirstResponder()
        
        let dicToSend: [String: Any] = ["func":"checkkey", "webmail": insertedEmail ?? "", "key": emailConfirmTextField.text ?? ""]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
            if result.data == "ok" {
                self.simpleAnimation()
            } else {
                self.showAlert(message: "인증번호가 다릅니다")
            }
        }
    }
    
    @objc func requestNumber() {
        let webmail: String = emailTextField.text ?? ""
        let dicToSend: [String: Any] = ["func":"find1", "webmail":webmail]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        let indexOfDomainOfMail = webmail.firstIndex(of: "@")
        
        if indexOfDomainOfMail == nil {
            let string: String = """
                올바른 메일 형식이 아닙니다
                입력한 주소를 확인해 주세요
                """
            self.showAlert(message: string)
        } else {
            
            ApiService.shared.getData(dataToSend: dataToSend){ (result: Certify) in
                if result.data! == "exist" {
                    self.insertedEmail = webmail
                    self.emailConfirmIconImageView.isHidden = false
                    self.emailConfirmTextField.isHidden = false
                    self.keyConfirmButton.isHidden = false
                    UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
                        self.emailConfirmButton.alpha = 0
                        self.emailConfirmIconImageView.alpha = 1
                        self.emailConfirmTextField.alpha = 1
                        self.keyConfirmButton.alpha = 1
                    }, completion: { (bool: Bool) in
                        self.emailConfirmButton.isHidden = true
                    })
                    
                    self.showAlert(message: "인증번호 발송 완료")
                } else if result.data! == "unexist" {
                    self.showAlert(message: "가입되지 않은 메일 입니다")
                } else if result.data! == "google" {
                    self.showAlert(message: """
                        구글을 통해 가입한 계정은
                        해당 서비스를 이용하실 수 없습니다.
                        """)
                }
            }
            
        }
    }
    
    @objc func getTempPassword() {
        var tempPassword: String = ""
        while true {
            let randomNo: Int = Int(arc4random_uniform(75) + 48);
            if (randomNo>=48 && randomNo<=57) || (randomNo>=65 && randomNo<=90) || (randomNo>=97 && randomNo<=122) {
                tempPassword.append(Character(UnicodeScalar(randomNo)!))
            }
            if tempPassword.count >= 8 {
                break
            }
        }
        
        let id: String = userid!
        let dicToSend: [String: Any] = ["func":"edit pw", "id":id, "pw":tempPassword.getSha256String()]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
            if result.data != "fail" {
                self.tempPasswordTextView.text = tempPassword
                let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font : UIFont.systemFont(ofSize: 20)] as [NSAttributedString.Key : Any]
                let attributedString = NSMutableAttributedString(string:tempPassword)
                attributedString.addAttributes(attributes, range: (tempPassword as NSString).range(of: tempPassword))
                attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: themeColor, range: (tempPassword as NSString).range(of: tempPassword))
                self.tempPasswordTextView.attributedText = attributedString
                self.tempPasswordTextView.textAlignment = .center
                self.notiLable5.isHidden = false
                self.tempPasswordTextView.isHidden = false
                UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
                    self.tempPasswordTextView.alpha = 1
                    self.notiLable5.alpha = 1
                }, completion: { (bool: Bool) in
                    
                })
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
    
    @objc func goBackToMemberController() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    let goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 19)
        button.accessibilityIdentifier = "goback from login"
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goBackToMemberController), for: .touchUpInside)
        return button
    }()
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo_white")
        return imageView
    }()
    
    let emailIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email")
        return imageView
    }()
    
    let emailConfirmIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "email_key")
        return imageView
    }()
    
    let emailTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "이메일"
        textField.keyboardType = .emailAddress
        textField.textColor = UIColor.black
        textField.givePadding()
        return textField
    }()
    
    let emailConfirmTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 130, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "인증 번호 입력"
        textField.keyboardType = .emailAddress
        textField.textColor = UIColor.black
        textField.givePadding()
        return textField
    }()
    
    let emailConfirmButton: UIButton = {
        let button = UIButton()
        let str: String = "메일로 인증 번호 발송"
        button.setTitle(str, for: .normal)
        button.setTitleColor(themeColor, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(requestNumber), for: .touchUpInside)
        //        button.titleLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        return button
    }()
    
    let keyConfirmButton: UIButton = {
        let button = UIButton()
        button.setTitle("인증", for: .normal)
        button.setTitleColor(themeColor, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.addTarget(self, action: #selector(keyConfirm), for: .touchUpInside)
        return button
    }()
    
    let notiLable1: UILabel = {
        let lable = UILabel()
        lable.textColor = lightblack
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "회원님의 아이디는"
        return lable;
    }()
    
    let idLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.textColor = lightblack
        return lable;
    }()
    
    let tempPwdButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "password button"
        button.setTitle("이곳", for: .normal)
        button.setTitleColor(themeColor, for: .normal)
        button.backgroundColor = UIColor.clear
        let attributes = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue, NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 19)] as [NSAttributedString.Key : Any]
        let attributedText = NSAttributedString(string: button.currentTitle!, attributes: attributes)
        button.titleLabel?.attributedText = attributedText
        return button
    }()
    
    
    let notiLable3: UILabel = {
        let lable = UILabel()
        lable.textColor = lightblack
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "임시비밀번호를 발급 받으시려면"
        return lable;
    }()
    
    let notiLable4: UILabel = {
        let lable = UILabel()
        lable.textColor = lightblack
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "을 눌러주세요."
        return lable;
    }()
    
    let tempPasswordTextView: UITextView = {
        let textView = UITextView()
        textView.textColor = themeColor
        textView.isUserInteractionEnabled = true
        textView.isEditable = false
        textView.font = UIFont.systemFont(ofSize: 15)
        textView.text = "임시 비밀번호"
        return textView;
    }()
    
    let notiLable5: UILabel = {
        let lable = UILabel()
        lable.textColor = lightblack
        lable.font = UIFont.systemFont(ofSize: 15)
        lable.text = "임시 비밀번호 :"
        return lable;
    }()
}
