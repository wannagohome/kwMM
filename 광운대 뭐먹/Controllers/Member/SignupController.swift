//
//  SignupController.swift
//  SettingUI
//
//  Created by Peter Jang on 31/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SignupController: UIViewController, UITextFieldDelegate {
    
    struct UsableId: Decodable {
        var data: String?
    }
    
    struct Certify: Decodable {
        var data: String?
        var key: String?
    }
    
    
    var insertedEmail: String?
    var emailConfirmed: Bool = false
    var nicknameConfirmed: Bool = false
    var passwordConfirmed: Bool = false
    var idConfirmed: Bool = false
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        hideKeyboardWhenTappedAround()
        
        idTextField.delegate = self
        nicknameTextField.delegate = self
        passwordTextField.delegate = self
        emailTextField.delegate = self
        emailConfirmTextField.delegate = self
        
        emailIconImageView.hide()
        emailTextField.hide()
        emailConfirmButton.hide()
        
        emailConfirmTextField.hide()
        emailConfirmIconImageView.hide()
        keyConfirmButton.hide()
        
        
        idCheckIconImageView.isHidden = true
        idConfirmLable.isHidden = true
        
        nicknameConfirmLable.isHidden = true
        nicknameCheckIconImageView.isHidden = true
        
        passwordCheckIconImageView.isHidden = true
        passwordConfirmLable.isHidden = true
        
        idIconImageView.hide()
        idTextField.hide()
        nicknameIconImageView.hide()
        nicknameTextField.hide()
        passwordIconImageView.hide()
        passwordTextField.hide()
        
        signupButton.hide()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    func setupViews()  {
        addSubviews(views: [logoImageView, goBackButton,
                            idIconImageView, nicknameIconImageView, passwordIconImageView, emailIconImageView, emailConfirmIconImageView,
                            idTextField, nicknameTextField, passwordTextField, emailTextField, emailConfirmTextField,
                            emailConfirmButton, keyConfirmButton, signupButton, nicknameConfirmLable, nicknameCheckIconImageView,
                            passwordConfirmLable, passwordCheckIconImageView, idConfirmLable, idCheckIconImageView,
                            policyTextView, agreeLabel, checkbox, nextButoon])
       
        
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
        
        
        
        
        policyTextView.anchor(top: logoImageView.bottomAnchor,
                               leading: view.leadingAnchor,
                               bottom: nil,
                               trailing: view.trailingAnchor,
                               padding: .init(top: view.bounds.height/20, left: view.bounds.width/8, bottom: 0, right: view.bounds.width/8),
                               size: .init(width: 0, height: 250))
        agreeLabel.anchor(top: policyTextView.bottomAnchor,
                          leading: policyTextView.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        checkbox.anchor(top: policyTextView.bottomAnchor,
                        leading: agreeLabel.trailingAnchor,
                        bottom: nil,
                        trailing: nil,
                        padding: .init(top: 15, left: 15, bottom: 0, right: 0),
                        size: .init(width: 25, height: 25))
        nextButoon.anchor(top: checkbox.bottomAnchor,
                          leading: checkbox.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 15, left: 0, bottom: 0, right: 0))
        
        
        
        
        
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
        
        
        
        
        
        
        idIconImageView.anchor(top: idTextField.topAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: idTextField.leadingAnchor,
                               padding: .init(top: -10, left: 0, bottom: 0, right: 10),
                               size: .init(width: 30, height: 30))
        idTextField.anchor(top: logoImageView.bottomAnchor,
                           leading: view.leadingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding: .init(top: view.bounds.width/12, left: view.bounds.width/3.5, bottom: 0, right: 0),
                           size: .init(width: 200, height: 25))
        idConfirmLable.anchor(top: idTextField.bottomAnchor,
                              leading: idTextField.leadingAnchor,
                              bottom: nil,
                              trailing: nil)
        idCheckIconImageView.anchor(top: idTextField.topAnchor,
                                    leading: idTextField.trailingAnchor,
                                    bottom: nil,
                                    trailing: nil,
                                    size: .init(width: 20, height: 20))
        
        nicknameIconImageView.anchor(top: idIconImageView.bottomAnchor,
                                     leading: idIconImageView.leadingAnchor,
                                     bottom: nil,
                                     trailing: nil,
                                     padding: .init(top: view.bounds.width/12, left: 0, bottom: 0, right: 0),
                                     size: .init(width: 30, height: 30))
        nicknameTextField.anchor(top: nicknameIconImageView.topAnchor,
                                 leading: nicknameIconImageView.trailingAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                                 size: .init(width: 200, height: 25))
        nicknameCheckIconImageView.anchor(top: nicknameTextField.topAnchor,
                                          leading: nicknameTextField.trailingAnchor,
                                          bottom: nil,
                                          trailing: nil,
                                          size: .init(width: 20, height: 20))
        nicknameConfirmLable.anchor(top: nicknameTextField.bottomAnchor,
                                    leading: nicknameTextField.leadingAnchor,
                                    bottom: nil,
                                    trailing: nil)
        passwordIconImageView.anchor(top: nicknameIconImageView.bottomAnchor,
                                     leading: nicknameIconImageView.leadingAnchor,
                                     bottom: nil,
                                     trailing: nil,
                                     padding: .init(top: view.bounds.width/12, left: 0, bottom: 0, right: 0),
                                     size: .init(width: 30, height: 30))
        passwordTextField.anchor(top: passwordIconImageView.topAnchor,
                                 leading: passwordIconImageView.trailingAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                                 size: .init(width: 200, height: 25))
        passwordCheckIconImageView.anchor(top: passwordTextField.topAnchor,
                                          leading: passwordTextField.trailingAnchor,
                                          bottom: nil,
                                          trailing: nil,
                                          size: .init(width: 20, height: 20))
        passwordConfirmLable.anchor(top: passwordTextField.bottomAnchor,
                                    leading: passwordTextField.leadingAnchor,
                                    bottom: nil,
                                    trailing: nil)
        
        signupButton.anchor(top: nil,
                            leading: nil,
                            bottom: view.safeAreaLayoutGuide.bottomAnchor,
                            trailing: nil,
                            padding: .init(top: 0, left: 0, bottom: 50, right: 0),
                            size: .init(width: 230, height: 40))
        signupButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    func addSubviews(views: [UIView]) {
        for temp in views {
            view.addSubview(temp)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == nicknameTextField {
            let nickname = textField.text!
            if nickname == "" {
                self.nicknameConfirmLable.text = "닉네임을 입력해 주세요"
                self.nicknameConfirmLable.textColor = UIColor.red
                self.nicknameConfirmLable.isHidden = false
                self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                self.nicknameCheckIconImageView.isHidden = true
                self.nicknameConfirmed = false
            } else if nickname.count > 8 {
                self.nicknameConfirmLable.text = "길이 제한을 초과하였습니다"
                self.nicknameConfirmLable.textColor = UIColor.red
                self.nicknameConfirmLable.isHidden = false
                self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                self.nicknameCheckIconImageView.isHidden = true
                self.nicknameConfirmed = false
            } else if nicknameCheck(str: nickname) {
                self.nicknameConfirmLable.text = "한글, 영어, 숫자만 사용 가능 합니다"
                self.nicknameConfirmLable.textColor = UIColor.red
                self.nicknameConfirmLable.isHidden = false
                self.nicknameCheckIconImageView.isHidden = true
                self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                self.nicknameConfirmed = false
            } else {
                let dicToSend: [String: Any] = ["func":"checkusable nickname", "nickname":nickname]
//                let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//                
//                ApiService.shared.getData(dataToSend: dataToSend){ (result: UsableId) in
//                    if result.data! == "overlapped" {
//                        self.nicknameConfirmLable.text = "이미 사용중인 닉네임 입니다"
//                        self.nicknameConfirmLable.textColor = UIColor.red
//                        self.nicknameConfirmLable.isHidden = false
//                        self.nicknameCheckIconImageView.isHidden = true
//                        self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
//                        self.nicknameConfirmed = false
//                    } else {
//                        self.nicknameConfirmed = true
//                        self.nicknameConfirmLable.text = "사용가능한 닉네임 입니다"
//                        self.nicknameConfirmLable.textColor = UIColor.blue
//                        self.nicknameCheckIconImageView.isHidden = false
//                        self.nicknameTextField.backgroundColor = UIColor.clear
//                    }
//                }
                
                ApiService.shared.loadingStart()
                AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                    (responds) in
                    switch responds.result {
                        
                    case .success(let value):
                        let json:JSON = JSON(value)
                        if json["data"].string == "overlapped" {
                            self.nicknameConfirmLable.text = "이미 사용중인 닉네임 입니다"
                            self.nicknameConfirmLable.textColor = UIColor.red
                            self.nicknameConfirmLable.isHidden = false
                            self.nicknameCheckIconImageView.isHidden = true
                            self.nicknameTextField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                            self.nicknameConfirmed = false
                        } else {
                            self.nicknameConfirmed = true
                            self.nicknameConfirmLable.text = "사용가능한 닉네임 입니다"
                            self.nicknameConfirmLable.textColor = UIColor.blue
                            self.nicknameCheckIconImageView.isHidden = false
                            self.nicknameTextField.backgroundColor = UIColor.clear
                        }
                        ApiService.shared.loadingStop()
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        ApiService.shared.loadingStop()
                        self.showAlert(message: "네트워크 오류")
                        
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
                passwordCheckIconImageView.isHidden = true
                passwordConfirmed = false
            } else {
                passwordConfirmLable.text = "사용가능한 비밀번호 입니다"
                passwordConfirmLable.textColor = UIColor.blue
                passwordCheckIconImageView.isHidden = false
                textField.backgroundColor = UIColor.clear
                passwordConfirmed = true
            }
        } else if textField == idTextField {
            let id = idTextField.text!
            
            if  id != "" && firstCheck(str: String(id[id.startIndex])) {
                idConfirmLable.text = "첫 글자는 영문을 사용해야 합니다"
                self.idConfirmLable.textColor = UIColor.red
                idConfirmLable.isHidden = false
                textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                idConfirmed = false
                idCheckIconImageView.isHidden = true
            } else if id.count < 4 || id.count > 10 {
                idConfirmLable.text = "3자 이하 11자 이상의 글자 수는 제한 됩니다"
                self.idConfirmLable.textColor = UIColor.red
                idConfirmLable.isHidden = false
                textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                idConfirmed = false
                idCheckIconImageView.isHidden = true
            } else if idCheck(str: id) {
                idConfirmLable.text = "영어와 숫자의 조합만 가능합니다"
                self.idConfirmLable.textColor = UIColor.red
                idConfirmLable.isHidden = false
                textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                idConfirmed = false
                idCheckIconImageView.isHidden = true
            } else {
                let dicToSend: [String: Any] = ["func":"checkusable id", "id":id]
//                let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//                ApiService.shared.getData(dataToSend: dataToSend){ (result: UsableId) in
//                    if result.data! == "overlapped" {
//                        self.idConfirmLable.text = "이미 사용중인 아이디 입니다"
//                        self.idConfirmLable.textColor = UIColor.red
//                        self.idConfirmLable.isHidden = false
//                        textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
//                        self.idConfirmed = false
//                        self.idCheckIconImageView.isHidden = true
//                    } else {
//                        textField.backgroundColor = UIColor.clear
//                        self.idConfirmLable.text = "사용가능한 아이디 입니다"
//                        self.idConfirmLable.textColor = UIColor.blue
//                        self.idConfirmed = true
//                        self.idCheckIconImageView.isHidden = false
//                    }
//                }
                
                ApiService.shared.loadingStart()
                AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                    (responds) in
                    switch responds.result {
                        
                    case .success(let value):
                        let json:JSON = JSON(value)
                        if json["data"].string == "overlapped" {
                            self.idConfirmLable.text = "이미 사용중인 아이디 입니다"
                            self.idConfirmLable.textColor = UIColor.red
                            self.idConfirmLable.isHidden = false
                            textField.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 0.1)
                            self.idConfirmed = false
                            self.idCheckIconImageView.isHidden = true
                        } else {
                            textField.backgroundColor = UIColor.clear
                            self.idConfirmLable.text = "사용가능한 아이디 입니다"
                            self.idConfirmLable.textColor = UIColor.blue
                            self.idConfirmed = true
                            self.idCheckIconImageView.isHidden = false
                        }
                        ApiService.shared.loadingStop()
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        ApiService.shared.loadingStop()
                        self.showAlert(message: "네트워크 오류")
                        
                    }
                }
            }
        }
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
    
    func firstCheck(str: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
    
    func idCheck(str: String) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: ".*[^A-Za-z0-9].*", options: .caseInsensitive)
            if let _ = regex.firstMatch(in: str, options: NSRegularExpression.MatchingOptions.reportCompletion, range: NSMakeRange(0, str.count)) {
                return true
            }
        } catch {
            debugPrint(error.localizedDescription)
            return false
        }
        return false
    }
    
    var key: String?
    
    
    @objc func requestNumber() {
//        view.loadingIndicator()
        let webmail: String = emailTextField.text ?? ""
        let dicToSend: [String: Any] = ["func":"certify", "webmail":webmail]
//        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        let indexOfDomainOfMail = webmail.firstIndex(of: "@")
        
        if indexOfDomainOfMail == nil {
            let string: String = """
                올바른 메일 형식이 아닙니다
                입력한 주소를 확인해 주세요
                """
            self.showAlert(message: string)
        } else {
            
//            ApiService.shared.getData(dataToSend: dataToSend){ (result: Certify) in
//                if result.data! == "usable webmail" {
//                    self.insertedEmail = webmail
//                    self.emailConfirmIconImageView.isHidden = false
//                    self.emailConfirmTextField.isHidden = false
//                    self.keyConfirmButton.isHidden = false
//                    UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
//                        self.emailConfirmButton.alpha = 0
//                        self.emailConfirmIconImageView.alpha = 1
//                        self.emailConfirmTextField.alpha = 1
//                        self.keyConfirmButton.alpha = 1
//                    }, completion: { (bool: Bool) in
//                        self.emailConfirmButton.isHidden = true
//                    })
//
//                    self.showAlert(message: "인증번호 발송 완료")
//                } else if result.data! == "unusable webmail" {
//                    self.showAlert(message: "이미 사용중인 메일 입니다")
//                } else if result.data! == "unexist webmail"{
//                    self.showAlert(message: "존재하지 않는 메일 입니다")
//                }
////                self.view.loadingIndicator(false)
//            }
            
            ApiService.shared.loadingStart()
            AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                (responds) in
                switch responds.result {
                    
                case .success(let value):
                    let json:JSON = JSON(value)
                    if json["data"].string == "usable webmail" {
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
                    } else if json["data"].string == "unusable webmail" {
                        self.showAlert(message: "이미 사용중인 메일 입니다")
                    } else if json["data"].string == "unexist webmail"{
                        self.showAlert(message: "존재하지 않는 메일 입니다")
                    }
                    ApiService.shared.loadingStop()
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    ApiService.shared.loadingStop()
                    self.showAlert(message: "네트워크 오류")
                    
                }
            }
            
        }
    }
    
    func simpleAnimation() {

        idIconImageView.isHidden = false
        idTextField.isHidden = false
        nicknameIconImageView.isHidden = false
        nicknameTextField.isHidden = false
        passwordIconImageView.isHidden = false
        passwordTextField.isHidden = false
        signupButton.isHidden = false
        
        UIView.animate(withDuration: 0.7, animations: {
            self.emailIconImageView.alpha = 0
            self.emailTextField.alpha = 0
            self.emailConfirmIconImageView.alpha = 0
            self.emailConfirmTextField.alpha = 0
            self.keyConfirmButton.alpha = 0
            
            self.idTextField.alpha = 1
            self.idIconImageView.alpha = 1
            self.nicknameIconImageView.alpha = 1
            self.nicknameTextField.alpha = 1
            self.passwordIconImageView.alpha = 1
            self.passwordTextField.alpha = 1
            self.signupButton.alpha = 1
        }, completion: { (bool: Bool) in
            self.emailIconImageView.isHidden = true
            self.emailTextField.isHidden = true
            self.emailConfirmIconImageView.isHidden = true
            self.emailConfirmTextField.isHidden = true
            self.keyConfirmButton.isHidden = true
        })

    }
    
    @objc func keyConfirm() {
        keyConfirmButton.resignFirstResponder()
        
        let dicToSend: [String: Any] = ["func":"checkkey", "webmail": insertedEmail ?? "", "key": emailConfirmTextField.text ?? ""]
//        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
//            print(result.data!)
//            if result.data! == "ok" {
//                self.showAlert(message: "인증 되었습니다")
//                self.simpleAnimation()
//                self.emailConfirmed = true
//            } else if result.data! == "fail" {
//                self.showAlert(message: "인증번호가 다릅니다")
//                self.emailConfirmed  = false
//            }
//        }
        
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                let json:JSON = JSON(value)
                if json["data"].string == "ok" {
                    self.showAlert(message: "인증 되었습니다")
                    self.simpleAnimation()
                    self.emailConfirmed = true
                } else if json["data"].string == "fail" {
                    self.showAlert(message: "인증번호가 다릅니다")
                    self.emailConfirmed  = false
                }
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    

    
    @objc func signup() {
        
        let userNickname = nicknameTextField.text
        if userNickname == "" || userNickname == " 닉네임" {
            self.showAlert(message: "닉네임를 입력해 주세요")
            return
        }
        let userPassword = passwordTextField.text
        if userPassword == "" || userPassword == " 비밀번호" {
            self.showAlert(message: "비밀번호를 입력해 주세요")
            return
        }
        
        if passwordConfirmed && nicknameConfirmed && idConfirmed {
            let dicToSend = ["func":"signup", "id":idTextField.text!, "pwd":self.passwordTextField.text!.getSha256String(), "nickname":userNickname!, "webmail":self.insertedEmail!]
//            let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//            ApiService.shared.getData(dataToSend: dataToSend) { (result: UsableId) in
//                if result.data! == "signup ok" {
//                    self.showAlert(message: "가입 완료")
//                }
//            }
            ApiService.shared.loadingStart()
            AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                (responds) in
                switch responds.result {
                    
                case .success(let value):
                    let json:JSON = JSON(value)
                    if json["data"].string == "signup ok" {
                        self.showAlert(message: "가입 완료")
                    }
                    ApiService.shared.loadingStop()
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    ApiService.shared.loadingStop()
                    self.showAlert(message: "네트워크 오류")
                    
                }
            }
        }
    }
    
    @objc func checked() {
        if checkbox.isChecked {
            nextButoon.setTitleColor(themeColor, for: .normal)
            nextButoon.isUserInteractionEnabled = true
        } else {
            nextButoon.setTitleColor(UIColor(white: 0.9, alpha: 1), for: .normal)
            nextButoon.isUserInteractionEnabled = false
        }
    }
    
    @objc func agreeAndNext() {
        if checkbox.isChecked {
            UIView.animate(withDuration: 0.7, delay: 0, options: [], animations: {
                self.emailIconImageView.alpha = 1
                self.emailTextField.alpha = 1
                self.emailConfirmButton.alpha = 1
                self.policyTextView.alpha = 0
                self.agreeLabel.alpha = 0
                self.checkbox.alpha = 0
                self.nextButoon.alpha = 0
            }, completion: { (bool: Bool) in
                self.emailIconImageView.isHidden = false
                self.emailTextField.isHidden = false
                self.emailConfirmButton.isHidden = false
                self.policyTextView.isHidden = true
                self.agreeLabel.isHidden = true
                self.checkbox.isHidden = true
                self.nextButoon.isHidden = true
            })
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
    
    let idIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person")
        return imageView
    }()
    
    let passwordIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "key")
        return imageView
    }()
    
    let nicknameIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "person")
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
    
    let idTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "아이디"
        textField.textColor = UIColor.black
        textField.givePadding()
        textField.accessibilityIdentifier = "id textfield"
        return textField
    }()
    
    let idConfirmLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        return label
    }()
    
    let idCheckIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checked")
        return imageView
    }()
    
    let nicknameTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "닉네임"
        textField.textColor = UIColor.black
        textField.givePadding()
        return textField
    }()
    
    let nicknameConfirmLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        return label
    }()
    
    let nicknameCheckIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checked")
        return imageView
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        textField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        textField.placeholder = "비밀번호"
        textField.textColor = UIColor.black
        textField.isSecureTextEntry = true
        textField.givePadding()
        return textField
    }()
    
    let passwordCheckIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "checked")
        return imageView
    }()
    
    let passwordConfirmLable: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 10)
        label.textColor = UIColor.red
        return label
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
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("가입", for: .normal)
        button.backgroundColor = themeColor
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.titleLabel?.textAlignment = .center
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(signup), for: .touchUpInside)
        return button
    }()
    
    let checkbox: Checkbox = {
        let checkbox = Checkbox(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        checkbox.uncheckedBorderColor = lightblack
        checkbox.borderStyle = .square
        checkbox.checkmarkSize = 0.8
        checkbox.checkedBorderColor = lightblack
        checkbox.borderWidth = 1
        checkbox.checkmarkColor = themeColor
        checkbox.checkmarkStyle = .tick
        checkbox.addTarget(self, action: #selector(checked), for: .valueChanged)
        return checkbox
    }()
    
    let agreeLabel : UILabel = {
        let label = UILabel()
        label.text = "이용약관에 동의 하시겠습니까?"
        label.textColor = lightblack
        return label
    }()
    
    let nextButoon: UIButton = {
        let button = UIButton()
        button.setTitle("다음", for: .normal)
        button.setTitleColor(UIColor(white: 0.9, alpha: 1), for: .normal)
        button.addTarget(self, action: #selector(agreeAndNext), for: .touchUpInside)
        button.isUserInteractionEnabled = false
        return button
    }()
    
    let policyTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.layer.borderColor = themeColor.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5
        textView.textColor = lightblack
        textView.isUserInteractionEnabled = true
        textView.text = Global.shared.peersonalInfo
        
        
        return textView
    }()
    
    
}
