//
//  SignupController.swift
//  SettingUI
//
//  Created by Peter Jang on 31/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit

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
                let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
                
                ApiService.shared.getData(dataToSend: dataToSend){ (result: UsableId) in
                    if result.data! == "overlapped" {
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
                let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
                
                ApiService.shared.getData(dataToSend: dataToSend){ (result: UsableId) in
                    if result.data! == "overlapped" {
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
                if result.data! == "usable webmail" {
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
                } else if result.data! == "unusable webmail" {
                    self.showAlert(message: "이미 사용중인 메일 입니다")
                } else if result.data! == "unexist webmail"{
                    self.showAlert(message: "존재하지 않는 메일 입니다")
                }
//                self.view.loadingIndicator(false)
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
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
            print(result.data!)
            if result.data! == "ok" {
                self.showAlert(message: "인증 되었습니다")
                self.simpleAnimation()
                self.emailConfirmed = true
            } else if result.data! == "fail" {
                self.showAlert(message: "인증번호가 다릅니다")
                self.emailConfirmed  = false
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
            let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
            
            ApiService.shared.getData(dataToSend: dataToSend) { (result: UsableId) in
                if result.data! == "signup ok" {
                    self.showAlert(message: "가입 완료")
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
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) { (temp: UIAlertAction) in
                if message == "가입 완료" {
                    self.presentingViewController?.dismiss(animated: true)
                }
            }
            
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
        textView.isUserInteractionEnabled = false
        textView.text = """
        ('광운대뭐먹')은(는) 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.

('광운대뭐먹') 은(는) 회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.

○ 본 방침은부터 2019년 2월 21일부터 시행됩니다.


1. 개인정보의 처리 목적 ('광운대뭐먹')은(는) 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다.

가. 홈페이지 회원가입 및 관리

회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지 등을 목적으로 개인정보를 처리합니다.




2. 개인정보 파일 현황

1. 개인정보 파일명 : kwMM
- 개인정보 항목 : 이메일, 비밀번호, 로그인ID, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보
- 수집방법 : 모바일 어플리케이션
- 보유근거 : 정보주체의 동의
- 보유기간 : 탈퇴 시 까지
- 관련법령 : 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년, 표시/광고에 관한 기록 : 6개월




3. 개인정보의 처리 및 보유 기간

① ('광운대뭐먹')은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집시에 동의 받은 개인정보 보유,이용기간 내에서 개인정보를 처리,보유합니다.

② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.

4. 정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.

① 정보주체는 광운대뭐먹에 대해 언제든지 개인정보 열람,정정,삭제,처리정지 요구 등의 권리를 행사할 수 있습니다.
② 제1항에 따른 권리 행사는 광운대뭐먹에 대해 개인정보 보호법 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 광운대뭐먹은(는) 이에 대해 지체 없이 조치하겠습니다.
③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.
④ 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제5항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.
⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.
⑥ 광운대뭐먹은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.



5. 처리하는 개인정보의 항목 작성

① ('광운대뭐먹')은(는) 다음의 개인정보 항목을 처리하고 있습니다.

1<홈페이지 회원가입 및 관리>
- 필수항목 : 이메일, 비밀번호, 로그인ID, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보




6. 개인정보의 파기('광운대뭐먹')은(는) 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

-파기절차
이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

-파기기한
이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.

-파기방법
전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.



7. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항

① 광운대뭐먹 은 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다. ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. 가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. 나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. 다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.


8. 개인정보 보호책임자 작성


① 광운대뭐먹 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자
성명 :유태형
직책 :개발
연락처 :010-2018-5509, 2354taeng@gmail.com,

② 정보주체께서는 광운대뭐먹 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 광운대뭐먹 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.



9. 개인정보 처리방침 변경

①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.



10. 개인정보의 안전성 확보 조치 ('광운대뭐먹')은(는) 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.

1. 개인정보의 암호화
이용자의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.

2. 개인정보에 대한 접근 제한
개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.
"""
        
        
        return textView
    }()
    
    
}
