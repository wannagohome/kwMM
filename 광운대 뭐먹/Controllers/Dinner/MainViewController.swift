//
//  ViewController.swift
//  SettingUI
//
//  Created by Peter Jang on 27/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import Foundation
import SystemConfiguration
import Alamofire
import SwiftyJSON
import GoogleSignIn


let cellId = "cellId"
let categories = ["한식","중식","일식","분식","면","치킨","햄버거/피자","디저트"]
var checkOnce: Bool = false

class MainViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let categoryImages: [UIImage?] = [UIImage(named: "한식"), UIImage(named: "중식"), UIImage(named: "일식"), UIImage(named: "분식"), UIImage(named: "면"), UIImage(named: "치킨"), UIImage(named: "햄버거"), UIImage(named: "디저트")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let image: UIImage = UIImage(named: "Logo.png")!
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        imageView.contentMode = .scaleAspectFit
        imageView.image = image
        self.navigationItem.titleView = imageView
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = themeColor
        navigationController?.navigationBar.barStyle = .black
        collectionView?.backgroundColor = UIColor(red: 252/255, green: 1, blue: 251/255, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: collectionView.bounds.height/18, left: collectionView.bounds.width/10, bottom: 40, right: collectionView.bounds.width/10)
        collectionView?.register(MainCell.self, forCellWithReuseIdentifier: cellId)
    }

    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        if Global.shared.isErrorLableShowing {
            Global.removeErrorLable()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        if !checkOnce {
            checkUsable()
        }
        checkOnce = true
        if UserDefaults().bool(forKey: "isLoggedIn") {
            banCheck()
        }
        
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        let textView = object as! UITextView
        var topCorrect = (textView.bounds.size.height - textView.contentSize.height * textView.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        textView.contentInset.top = topCorrect
    }
    
    func banCheck() {
        let dicToSend = ["func":"connect", "id":UserDefaults().string(forKey: "id")]
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend as Parameters, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                let json:JSON = JSON(value)
                if json["data"].string == "ban" {
                    self.showAlert(message: "부적절한 행동으로 인해 이용이 금지되었습니다")
                    if UserDefaults().bool(forKey: "google") {
                        GIDSignIn.sharedInstance()?.signOut()
                    }
                    UserDefaults.standard.set(false, forKey: "google")
                    UserDefaults.standard.set(false, forKey: "isLoggedIn")
                    UserDefaults.standard.set("", forKey: "nickname")
                    UserDefaults.standard.set("", forKey: "profile")
                    UserDefaults.standard.set("", forKey: "id")
                }
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    
    
    func checkUsable() {
        view.loadingIndicator()
        
        if Reachability().isConnectedToNetwork() {
            let versionCheck = isThereNewVerion()
            if versionCheck.isNewVersionExist {
                updateString = "업데이트가 필요 합니다"
                
                var lastDot = versionCheck.myVersion.lastIndex(of: ".") ?? versionCheck.myVersion.endIndex
                let firstTwoNumberOfmyVersion = versionCheck.myVersion[..<lastDot]
                
                lastDot = versionCheck.appStoreVersion.lastIndex(of: ".") ?? versionCheck.appStoreVersion.endIndex
                let firstTwoNumverOfAppStoreVersion = versionCheck.appStoreVersion[..<lastDot]
                
                if firstTwoNumberOfmyVersion != firstTwoNumverOfAppStoreVersion {
                    view.loadingIndicator(false)
                    self.restrict(message: """
                            사용 불가 버전을 사용하고 있습니다
                            최신버전으로 업데이트 해주세요
                            """)
                    return
                }
            } else {
                updateString = "최신 버전 입니다"
            }
        } else {
            view.loadingIndicator(false)
            self.restrict(message: """
                            인터넷이 연결되어 있지 않습니다
                            인터넷 연결을 확인해 주세요
                            """)
            return
        }
        checkWebsite(completion: {(bool: Bool) in
            if !bool {
                DispatchQueue.main.async {
                    self.view.loadingIndicator(false)
                    self.restrict(message: """
                            서버 점검 중
                            """)
                }
                return
            }
        })
        view.loadingIndicator(false)
    }
    
    func isThereNewVerion() -> (isNewVersionExist: Bool, myVersion: String, appStoreVersion: String) {
        guard
            let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String,
            let url = URL(string: "http://itunes.apple.com/lookup?bundleId=org.kwfood.kwmm.kr"),
            let data = try? Data(contentsOf: url),
            let json = try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any],
            let results = json?["results"] as? [[String: Any]],
            results.count > 0,
            let appStoreVersion = results[0]["version"] as? String
            else { return (isNewVersionExist: true, myVersion:  (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!, appStoreVersion: (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String)!) }
        if (version == appStoreVersion) { return (isNewVersionExist: false, myVersion: version, appStoreVersion: appStoreVersion) }
        else{ return (isNewVersionExist: true, myVersion: version, appStoreVersion: appStoreVersion) }
    }
   
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as? MainCell
        cell?.layer.cornerRadius = 7
        cell?.categoryLabel.text = categories[indexPath.row]
        cell?.categoryImageView.image = categoryImages[indexPath.row]
        
        cell?.layer.masksToBounds = false
        cell?.layer.shadowOffset = CGSize(width: 3, height: 3)
        cell?.layer.shadowRadius = 4
        cell?.layer.shadowOpacity = 0.2
        
        return cell!
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let dinnerListController = DinnerListController()
        initialIndex = indexPath.item
        self.navigationController?.pushViewController(dinnerListController, animated: false)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width/3, height: 150)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionView.bounds.height/15
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func checkWebsite(completion: @escaping (Bool) -> Void ) {
        guard let url = URL(string: "http://kwmm.kr:8080/kwMM/Main2") else { return }
        
        var request = URLRequest(url: url)
        request.timeoutInterval = 4.0
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                
                print("\(error.localizedDescription)")
                completion(false)
                return
            }
            if let httpResponse = response as? HTTPURLResponse {
                print("statusCode: \(httpResponse.statusCode)")
                // do your logic here
                // if statusCode == 200 ...
                completion(true)
                
            }
        }
        task.resume()
    }
    
}

class MainCell: BaseCell {
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "category"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = lightblack
        label.accessibilityIdentifier = "category name"
        return label
    }()
    
    let categoryImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.accessibilityIdentifier = "category icon"
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(categoryLabel)
        addSubview(categoryImageView)
        

        categoryImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        categoryImageView.anchor(top: contentView.topAnchor,
                                 leading: nil,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: contentView.bounds.height/5, left: 0, bottom: 0, right: 0),
                                 size: .init(width: 70, height: contentView.bounds.height/2.3))
        categoryLabel.anchor(top: nil,
                             leading: nil,
                             bottom: contentView.bottomAnchor,
                             trailing: nil,
                             padding: .init(top: 0, left: 0, bottom: 20, right: 0),
                             size: .init(width: 100, height: 20))
        categoryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
    }
    
    
}



public class Reachability {
    public func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                SCNetworkReachabilityCreateWithAddress(nil, $0)
            }
        }) else {
            return false
        }
        
        var flags: SCNetworkReachabilityFlags = []
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
            return false
        }
        if flags.isEmpty {
            return false
        }
        
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        
        return (isReachable && !needsConnection)
    }
}
