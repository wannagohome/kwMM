//
//  LoginController.swift
//  SettingUI
//
//  Created by Peter Jang on 30/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
import SwiftyJSON

class LoginController: UIViewController, GIDSignInDelegate, GIDSignInUIDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        GIDSignIn.sharedInstance()?.language = "ko"
        GIDSignIn.sharedInstance()?.uiDelegate = self
        GIDSignIn.sharedInstance()?.delegate = self
        
        view.backgroundColor = UIColor.white
        hideKeyboardWhenTappedAround()
        
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    func setupViews() {
        view.addSubview(goBackButton)
        view.addSubview(logoImageView)
        view.addSubview(idIconImageView)
        view.addSubview(passwordIconImageView)
        view.addSubview(idTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(findButton)
        view.addSubview(googleSignInButton)
        view.addSubview(signupButton)
    
        
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                            size: .init(width: 50, height: 50))
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: nil,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: view.bounds.height/7, left: 0, bottom: 0, right: 0),
                             size: .init(width: 100, height: 162))
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        idIconImageView.anchor(top: logoImageView.bottomAnchor,
                               leading: nil,
                               bottom: nil,
                               trailing: idTextField.leadingAnchor,
                               padding: .init(top: 30, left: 0, bottom: 0, right: 10))
        passwordIconImageView.anchor(top: idIconImageView.bottomAnchor,
                                     leading: idIconImageView.leadingAnchor,
                                     bottom: nil,
                                     trailing: nil,
                                     padding: .init(top: 20, left: 0, bottom: 0, right: 0),
                                     size: .init(width: 30, height: 30))
        idTextField.anchor(top: idIconImageView.topAnchor,
                           leading: view.leadingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding: .init(top: 10, left: view.bounds.width/3.5, bottom: 0, right: 0),
                           size: .init(width: 200, height: 25))

        passwordTextField.anchor(top: passwordIconImageView.topAnchor,
                                 leading: passwordIconImageView.trailingAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                                 size: .init(width: 200, height: 25))

        idTextField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        passwordTextField.layer.addBorder([.bottom], color: UIColor.black, width: 0.5)
        idTextField.widthAnchor.constraint(equalToConstant: view.bounds.width/1.5)
        passwordTextField.widthAnchor.constraint(equalToConstant: view.bounds.width/1.5)
        
        loginButton.anchor(top: passwordIconImageView.bottomAnchor,
                           leading: idIconImageView.leadingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding: .init(top: 40, left: -10, bottom: 0, right: 0),
                           size: .init(width: 115, height: 35))
        googleSignInButton.anchor(top: loginButton.bottomAnchor,
                                  leading: loginButton.leadingAnchor,
                                  bottom: nil,
                                  trailing: findButton.trailingAnchor,
                                  padding: .init(top: 15, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 0, height: 35))
        googleSignInButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        signupButton.anchor(top: googleSignInButton.bottomAnchor,
                            leading: loginButton.leadingAnchor,
                            bottom: nil,
                            trailing: findButton.trailingAnchor,
                            padding: .init(top: 15, left: 0, bottom: 0, right: 0),
                            size: .init(width: 0, height: 35))
//        loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -60).isActive = true
        
        findButton.anchor(top: loginButton.topAnchor,
                          leading: loginButton.trailingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                          size: .init(width: 135, height: 35))
    }
    
    @objc func presentFindViewController() {
        let findConroller = FindViewController()
        self.present(findConroller, animated: true, completion: nil)
    }
    
    @objc func goBackToMemberController() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    
    
    @objc func login() {
        let userId = idTextField.text
        let password = passwordTextField.text?.getSha256String()
        let dicToSend = ["func":"login", "id":userId, "pwd":password]
        
//        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        ApiService.shared.getData(dataToSend: dataToSend){ (loginResult: Login) in
//
//            if loginResult.data == "로그인" {
//                UserDefaults.standard.set(loginResult.nickname, forKey: "nickname")
//                UserDefaults.standard.set(loginResult.profile, forKey: "profile")
//                UserDefaults.standard.set(true, forKey: "isLoggedIn")
//                UserDefaults.standard.set(userId, forKey: "id")
//
//                self.presentingViewController?.dismiss(animated: true)
//            } else {
//                DispatchQueue.main.async {
//                    let alertMessage = UIAlertController(title: "", message: "아이디/비밀번호를 확인해주세요", preferredStyle: .alert)
//                    let cancelAction = UIAlertAction(title: "확인", style: .cancel)
//
//                    alertMessage.addAction(cancelAction)
//
//                    self.present(alertMessage, animated: true, completion: nil)
//                }
//            }
//        }
        
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend as Parameters, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                let json:JSON = JSON(value)
                if json["data"].string == "로그인" {
                UserDefaults.standard.set(json["nickname"].string, forKey: "nickname")
                UserDefaults.standard.set(json["profile"].string, forKey: "profile")
                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
                    UserDefaults.standard.set(userId, forKey: "id")
                    
                    self.presentingViewController?.dismiss(animated: true)
                } else if json["data"].string == "ban" {
                    self.showAlert(message: "부적절한 행동으로 인해 \((json["date"].string)!)까지 이용이 금지되었습니다")
                } else {
                    DispatchQueue.main.async {
                        let alertMessage = UIAlertController(title: "", message: "아이디/비밀번호를 확인해주세요", preferredStyle: .alert)
                        let cancelAction = UIAlertAction(title: "확인", style: .cancel)
                        
                        alertMessage.addAction(cancelAction)
                        
                        self.present(alertMessage, animated: true, completion: nil)
                    }
                }
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    
    @objc func googleButton() {
        GIDSignIn.sharedInstance()?.signIn()
    }
    
    @objc func presentSignupController() {
        let vc = SignupController()
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            let dicToSend = ["func":"google", "id":user.userID!, "webmail":user.profile.email!]
            //            let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
            //
            //            ApiService.shared.getData(dataToSend: dataToSend) { (result: GoogleLoginResult) in
            //                if result.data! == "signup ok" {
            //                    UserDefaults.standard.set(true, forKey: "google")
            //                    UserDefaults.standard.set(result.nickname!, forKey: "nickname")
            //                    UserDefaults.standard.set(result.profile!, forKey: "profile")
            //                    UserDefaults.standard.set(true, forKey: "isLoggedIn")
            //                    UserDefaults.standard.set(user.userID!, forKey: "id")
            //                    self.presentingViewController?.dismiss(animated: true)
            //                } else if result.data! == "fail" {
            //                    self.showAlert(message: "이미 가입되어 있는 이메일 입니다")
            //                    GIDSignIn.sharedInstance()?.signOut()
            //                }
            //            }
            
            ApiService.shared.loadingStart()
            AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend as Parameters, encoding: JSONEncoding.default).responseJSON {
                (responds) in
                switch responds.result {
                    
                case .success(let value):
                    let json:JSON = JSON(value)
                    if json["data"].string == "signup ok" {
                        UserDefaults.standard.set(true, forKey: "google")
                        UserDefaults.standard.set(json["nickname"].string, forKey: "nickname")
                        UserDefaults.standard.set(json["profile"].string, forKey: "profile")
                        UserDefaults.standard.set(true, forKey: "isLoggedIn")
                        UserDefaults.standard.set(user.userID!, forKey: "id")
                        self.presentingViewController?.dismiss(animated: true)
                    } else if json["data"].string == "fail" {
                        self.showAlert(message: "이미 가입되어 있는 이메일 입니다")
                        GIDSignIn.sharedInstance()?.signOut()
                    } else if json["data"].string == "ban" {
                        self.showAlert(message: "부적절한 행동으로 인해 \((json["date"].string)!)까지 이용이 금지되었습니다")
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
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Logo_white")
        return imageView
    }()
    
    let idIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "person")
        return imageView
    }()
    
    let passwordIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "key")
        return imageView
    }()
    
    
    let goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.accessibilityIdentifier = "goback from login"
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goBackToMemberController), for: .touchUpInside)
        return button
    }()
    
    let idTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        textField.placeholder = "아이디"
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.keyboardType = .default
        textField.givePadding()
        return textField
    }()
    
    let passwordTextField: UITextField = {
        let textField = UITextField(frame: CGRect(x: 0, y: 0, width: 200, height: 25))
        textField.placeholder = "비밀번호"
        textField.textColor = UIColor.black
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.isSecureTextEntry = true
        textField.givePadding()
        return textField
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.accessibilityIdentifier = "login button"
        button.layer.cornerRadius = 5
        button.backgroundColor = themeColor
        button.addTarget(self, action: #selector(login), for: .touchUpInside)
        return button
    }()
    
    let findButton: UIButton = {
        let button = UIButton()
        button.setTitle("아이디/비밀번호 찾기", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.accessibilityIdentifier = "login button"
        button.layer.cornerRadius = 5
        button.backgroundColor = themeColor
        button.addTarget(self, action: #selector(presentFindViewController), for: .touchUpInside)
        return button
    }()
    
    let googleSignInButton: UIButton = {
        let button = UIButton()
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitle("Google로 로그인", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.backgroundColor = UIColor(red: 221/255, green: 75/255, blue: 57/255, alpha: 0.9)
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(googleButton), for: .touchUpInside)
        return button
    }()
    
    let signupButton: UIButton = {
        let button = UIButton()
        button.setTitle("회원가입", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 15)
        button.setTitleColor(UIColor.white, for: .normal)
        button.accessibilityIdentifier = "회원가입으로"
        button.backgroundColor = UIColor(white: 0.80, alpha: 1)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(presentSignupController), for: .touchUpInside)
        return button
    }()
    
    
    
}
