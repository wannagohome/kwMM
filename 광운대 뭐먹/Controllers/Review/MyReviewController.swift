//
//  MyReviewController.swift
//  SettingUI
//
//  Created by Peter Jang on 05/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class MyReviewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "내 리뷰"
        
        self.navigationController?.navigationBar.titleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white,
             NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 17)]
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barTintColor = themeColor
        navigationController?.navigationBar.barStyle = .black
        view.backgroundColor = .white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
        if UserDefaults().bool(forKey: "isLoggedIn") {
            setupCollectionView()
            notificationImage.removeFromSuperview()
        } else {
            setupViews()
            collectionView.removeFromSuperview()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if UserDefaults().bool(forKey: "isLoggedIn") {
            fetchLists()
        }
    }
    
    func animateImageView(reviewImageView: UIImageView) {
        
        let photoViewController = PhotoDetailViewController()
        photoViewController.reviewImageView.image = reviewImageView.image
        self.present(photoViewController, animated: true)
        
    }
    
    func showDeleteDialog(reviewId: Int) {
        let title = "삭제하시겠습니까?"
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        let cancle = UIAlertAction(title: "취소", style: .cancel)
        let ok = UIAlertAction(title: "삭제", style: .destructive) { (_) in
            let dicToSend: [String : Any] = ["func":"review delete", "reviewId":reviewId]
//            let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//            ApiService.shared.getData(dataToSend: dataToSend){ (result: SimpleResponse) in
//                if result.data! == "delete" {
//                    self.fetchLists()
//                }
//            }
            
            ApiService.shared.loadingStart()
            AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                (responds) in
                switch responds.result {
                    
                case .success(let value):
                    let json:JSON = JSON(value)
                    if json["data"].string == "delete" {
                        self.fetchLists()
                    }
                    ApiService.shared.loadingStop()
                    
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    ApiService.shared.loadingStop()
                    self.showAlert(message: "네트워크 오류")
                    
                }
            }
        }
        
        alert.addAction(cancle)
        alert.addAction(ok)
        
        self.present(alert, animated: false)
    }
    
    func setupCollectionView() {

        view.addSubview(collectionView)
        collectionView.backgroundColor = .white
        collectionView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor)
        collectionView.register(MyReviewCell.self, forCellWithReuseIdentifier: "review")
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.layer.shouldRasterize = true
        collectionView.layer.rasterizationScale = UIScreen.main.scale
    }
    
    func setupViews() {
        view.addSubview(notificationImage)
        
        notificationImage.translatesAutoresizingMaskIntoConstraints = false
        notificationImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notificationImage.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        notificationImage.heightAnchor.constraint(equalToConstant: 101).isActive = true
        notificationImage.widthAnchor.constraint(equalToConstant: 180).isActive = true
    }
    
    func deleteReview(reviewId: Int) {
        showDeleteDialog(reviewId: reviewId)
    }
    
//    var reviews: Reviews?
    var json: JSON?
    
    func fetchLists() {
        let ueserId: String? = UserDefaults().string(forKey: "id")
        let dicToSend: [String: Any] = ["func":"myReview","id":ueserId ?? ""]
//        let dataToSend: Data = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        ApiService.shared.getData(dataToSend: dataToSend){ (reviews: Reviews) in
//            self.reviews = reviews
//            if reviews.reviews?.count != 0 {
//                self.collectionView.reloadData()
//            } else {
//                self.collectionView.removeFromSuperview()
//                self.notificationImage.image = UIImage(named: "리뷰 없음")
//                self.setupViews()
//            }
//        }
        
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                self.json = JSON(value)
                if self.json?["reviews"].count != 0 {
                    self.collectionView.reloadData()
                } else {
                    self.collectionView.removeFromSuperview()
                    self.notificationImage.image = UIImage(named: "리뷰 없음")
                    self.setupViews()
                }
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return reviews?.reviews?.count ?? 0
        return json?["reviews"].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell: MyReviewCell? = collectionView.dequeueReusableCell(withReuseIdentifier: "review", for: indexPath) as? MyReviewCell
//        cell?.review = reviews?.reviews?[indexPath.item]
        cell?.reviewJson = json?["reviews"][indexPath.item]
        cell?.myReviewController = self
        cell?.backgroundColor = UIColor.white
        
//        cell?.dinnerNameLabel.text = (reviews?.reviews?[indexPath.item].restaurantName)! + " - "
//        cell?.menuNameLabel.text = reviews?.reviews?[indexPath.item].menuName
        cell?.dinnerNameLabel.text = (json?["reviews"][indexPath.item]["restaurantName"].string)! + " - "
        cell?.menuNameLabel.text = json?["reviews"][indexPath.item]["menuName"].string
        cell?.setNeedsUpdateConstraints()
        cell?.updateConstraintsIfNeeded()
        cell?.layer.borderWidth = 0.3
        cell?.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heightPlus: Int
        
        let approximateWidth = view.frame.width - 30 - 5 - 5 - 10
        let size = CGSize(width: approximateWidth, height: 1000)
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        //        let estimatedFrame = NSString(string: (reviews?.reviews?[indexPath.row].contents)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        let estimatedFrame = NSString(string: (json?["reviews"][indexPath.row]["contents"].string)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        //        let temp = (reviews?.reviews?[indexPath.row].reviewPic)!
        let temp = (json?["reviews"][indexPath.row]["reviewPic"].string)!
        let index = temp.lastIndex(of: "/")
        let def = temp[index! ..< temp.endIndex]
        
        if def == "/default" {
            heightPlus = 0
            
        } else {
            heightPlus = 150
        }
        if (json?["reviews"][indexPath.row]["contents"].string == "") {
            heightPlus -= 20
        }
        
        return CGSize(width: view.bounds.width, height: estimatedFrame.height + 120 + CGFloat(heightPlus))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    
    let notificationImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "로그인")
        return imageView
    }()
    
    let notificationLable: UILabel = {
        let lable = UILabel()
        lable.text = "로그인이 필요합니다"
        lable.font = .boldSystemFont(ofSize: 25)
        return lable
    }()
    
    let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitleColor(.black, for: .normal)
        button.accessibilityIdentifier = "로그인으로"
        button.backgroundColor = .clear
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.black.cgColor
        button.addTarget(self, action: #selector(presentLoginController), for: .touchUpInside)
        return button
    }()
    
    @objc func presentLoginController() {
        let vc = LoginController()
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true, completion: nil)
    }
    
}
