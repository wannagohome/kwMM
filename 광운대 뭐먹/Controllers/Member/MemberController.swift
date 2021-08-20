//
//  MemberController.swift
//  SettingUI
//
//  Created by Peter Jang on 30/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import GoogleSignIn
import Alamofire
import SwiftyJSON

class MemberController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        navigationController?.navigationBar.isTranslucent = false
        view.backgroundColor = UIColor.white
        
        setupCollectionView()
        setupViews()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
        navigationController?.isNavigationBarHidden = true
        navigationController?.navigationBar.barTintColor = themeColor
        navigationController?.navigationBar.barStyle = .black
        if UserDefaults().bool(forKey: "isLoggedIn") {
//            logoImageView.isHidden = true
            loginButton.isHidden = true
            nicknameLabel.isHidden = false
            logoutButton.isHidden = false
            profileImageView.isHidden = false
            fetchImage()
        } else{
            nicknameLabel.isHidden = true
            logoutButton.isHidden = true
            profileImageView.isHidden = true
            loginButton.isHidden = false
            logoImageView.isHidden = false
        }
    }
    
    private func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }

        collectionView.register(memberCell.self, forCellWithReuseIdentifier: cellId)
        
    }

    func setupViews(){
        view.addSubview(logoImageView)
        view.addSubview(loginButton)
        view.addSubview(nicknameLabel)
        view.addSubview(logoutButton)
        view.addSubview(profileImageView)
        
        view.addSubview(collectionView)
        collectionView.anchor(top: logoImageView.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: view.frame.height / 17, left: 0, bottom: 0, right: 0))
        
        logoImageView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                             leading: view.leadingAnchor,
                             bottom: nil,
                             trailing: view.trailingAnchor,
                             padding: .init(top: 0, left: 60, bottom: 0, right: 60),
                             size: .init(width: 0, height: 310))
        loginButton.anchor(top: nil,
                            leading: view.leadingAnchor,
                            bottom: collectionView.topAnchor,
                            trailing: view.trailingAnchor,
                            size: .init(width: 0, height: 45))
        
        profileImageView.anchor(top: nil,
                                leading: view.leadingAnchor,
                                bottom: collectionView.topAnchor,
                                trailing: nil,
                                padding: .init(top: 0, left: 30, bottom: 20, right: 0),
                                size: .init(width: 70, height: 70))
        nicknameLabel.anchor(top: nil,
                             leading: profileImageView.trailingAnchor,
                             bottom: nil,
                             trailing: logoutButton.leadingAnchor,
                             padding: .init(top: 0, left: 20, bottom: 0, right: 10),
                             size: .init(width: 0, height: 20))
        nicknameLabel.centerYAnchor.constraint(equalTo: profileImageView.centerYAnchor).isActive = true
        
        logoutButton.anchor(top: nil,
                            leading: nil,
                            bottom: nil,
                            trailing: view.trailingAnchor,
                            padding: .init(top: 0, left: 0, bottom: 0, right: 20),
                            size: .init(width: 50, height: 20))
        logoutButton.centerYAnchor.constraint(equalTo: nicknameLabel.centerYAnchor).isActive = true
        
    }
    
    private func fetchImage() {
//        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let userId = UserDefaults().string(forKey: "id")
        let dicToSend = ["func":"get profile", "id":userId]
//        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//        ApiService.shared.getData(dataToSend: dataToSend){ (profileURL: Profile) in
//            self.profileImageView.sd_setImage(with: URL(string: (profileURL.image)!), placeholderImage: UIImage(named: "avatar"))
//            self.nicknameLabel.text = profileURL.nickname
//            UIApplication.shared.isNetworkActivityIndicatorVisible = false
//        }
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend as Parameters, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                let json:JSON = JSON(value)
                self.profileImageView.sd_setImage(with: URL(string: json["image"].string!), placeholderImage: UIImage(named: "avatar"))
                self.nicknameLabel.text = json["nickname"].string
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? memberCell
        cell?.backgroundColor = UIColor.white
        cell?.layer.borderWidth = 0.3
        cell?.layer.borderColor = UIColor.gray.cgColor
        
        if indexPath.item == 0 {
            cell?.iconImageView.image = UIImage(named: "notice")
            cell?.textLable.text = "공지사항"
        } else if indexPath.item == 1 {
            cell?.iconImageView.image = UIImage(named: "myinfo")
            cell?.textLable.text = "개인정보 수정"
        } else if indexPath.item == 2 {
            cell?.iconImageView.image = UIImage(named: "proposal")
            cell?.textLable.text = "건의사항"
        } else if indexPath.item == 3 {
            cell?.textLable.text = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            cell?.arrowImageView.removeFromSuperview()
            cell?.updateLable.text = updateString
        }
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == 0 {
            let noticeController = NoticeController(collectionViewLayout: UICollectionViewFlowLayout())
            self.navigationController?.pushViewController(noticeController, animated: true)
        }
        else if indexPath.item == 1{
            if UserDefaults().bool(forKey: "isLoggedIn") {
                if UserDefaults().bool(forKey: "google") {
                    let editController = EditController()
                    self.navigationController?.pushViewController(editController, animated: true)
                } else {
                    checkPassword()
                }
            } else {
                showAlert(message: "로그인이 필요합니다")
            }
        }
        else if indexPath.item == 2{
            let email = "kwmminfo@gmail.com"
            if let url = URL(string: "mailto:\(email)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        } else if indexPath.item == 3 {
            if updateString == "업데이트가 필요 합니다" {
                UIApplication.shared.open(URL(string: "itms-apps://itunes.apple.com/app/id1454978912")!, options: [:], completionHandler: nil)
            }
            
        }
    }
    
    func checkPassword() {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "현재 비밀번호", message: nil, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "취소", style: .cancel)
            let certifyAction = UIAlertAction(title: "확인", style: .default) { (_) in
                let passwordTextField = alertMessage.textFields![0]
                let userId = UserDefaults().string(forKey: "id")
                let password = passwordTextField.text?.getSha256String()
                let dicToSend = ["func":"login", "id":userId, "pwd":password]
//                let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//                ApiService.shared.getData(dataToSend: dataToSend){ (result: Login) in
//                    if result.data == "로그인" {
//                        let editController = EditController()
//                        self.navigationController?.pushViewController(editController, animated: true)
//                    } else {
//                        self.showAlert(message: "비밀번호가 틀렸습니다")
//                    }
//                }
                ApiService.shared.loadingStart()
                AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend as Parameters, encoding: JSONEncoding.default).responseJSON {
                    (responds) in
                    switch responds.result {
                        
                    case .success(let value):
                        let json:JSON = JSON(value)
                        if json["data"].string == "로그인" {
                            let editController = EditController()
                            self.navigationController?.pushViewController(editController, animated: true)
                        } else {
                            self.showAlert(message: "비밀번호가 틀렸습니다")
                        }
                        ApiService.shared.loadingStop()
                        
                        
                    case .failure(let error):
                        print(error.localizedDescription)
                        ApiService.shared.loadingStop()
                        self.showAlert(message: "네트워크 오류")
                        
                    }
                }
            }
            certifyAction.isEnabled = false
            
            alertMessage.addTextField(configurationHandler: {(textField) in
                textField.placeholder = "비밀번호"
                textField.isSecureTextEntry = true
                NotificationCenter.default.addObserver(forName: UITextField.textDidChangeNotification, object: textField, queue: OperationQueue.main, using: {(notification) in
                    certifyAction.isEnabled = textField.text != ""
                })
            })
            
            alertMessage.addAction(cancelAction)
            alertMessage.addAction(certifyAction)
            
            self.present(alertMessage, animated: true)
        }
    }

    @objc func presentLoginController() {
        let vc = LoginController()
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func presentSignupController() {
        let vc = SignupController()
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func logout() {
        if UserDefaults().bool(forKey: "google") {
            GIDSignIn.sharedInstance()?.signOut()
        }
        UserDefaults.standard.set(false, forKey: "google")
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        UserDefaults.standard.set("", forKey: "nickname")
        UserDefaults.standard.set("", forKey: "profile")
        UserDefaults.standard.set("", forKey: "id")
        viewWillAppear(false)
    }
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "뭐먹 가로")
        imageView.contentMode = .scaleAspectFit
//        imageView.clipsToBounds = true
        return imageView
    }()
    
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 21)
        button.setTitleColor(.white, for: .normal)
        button.accessibilityIdentifier = "로그인으로"
        button.backgroundColor = themeColor
        button.addTarget(self, action: #selector(presentLoginController), for: .touchUpInside)
        return button
    }()
    
    let nicknameLabel: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = lightblack
        label.accessibilityIdentifier = "닉네임"
        return label
    }()
    
    let logoutButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그아웃", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 11)
        button.accessibilityIdentifier = "로그아웃"
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(logout), for: .touchUpInside)
        return button
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = UIColor.clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 15
        imageView.image = UIImage(named: "avatarx1")
        return imageView
    }()
    
}


class memberCell: BaseCell {
    
    override func setupViews() {
        addSubview(iconImageView)
        addSubview(textLable)
        addSubview(arrowImageView)
        addSubview(updateLable)
        
        iconImageView.anchor(top: nil,
                             leading: contentView.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                             size: .init(width: 30, height: 30))
        iconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        textLable.anchor(top: nil,
                         leading: iconImageView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: .init(top: 0, left: 30, bottom: 0, right: 0),
                         size: .init(width: 0, height: 30))
        textLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        updateLable.anchor(top: nil,
                           leading: textLable.trailingAnchor,
                           bottom: nil,
                           trailing: nil,
                           padding: .init(top: 0, left: 20, bottom: 0, right: 0))
        updateLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        arrowImageView.anchor(top: nil,
                              leading: nil,
                              bottom: nil,
                              trailing: contentView.trailingAnchor,
                              padding: .init(top: 0, left: 0, bottom: 0, right: 20),
                              size: .init(width: 20, height: 20))
        arrowImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    let iconImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    
    let textLable: UILabel = {
        let lable = UILabel()
        lable.textColor = lightblack
        return lable
    }()
    
    let updateLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 14)
        lable.textColor = UIColor(white: 0.7, alpha: 1)
        return lable
    }()
    
    let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right")
        imageView.accessibilityIdentifier = "arrow"
        return imageView
    }()
}
