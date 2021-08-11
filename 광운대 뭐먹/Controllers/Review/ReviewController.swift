//
//  ReviewController.swift
//  SettingUI
//
//  Created by Peter Jang on 02/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit

class ReviewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var dinnerName: String?
    var menuName: String?
    var menuId: Int?
    let id: String = UserDefaults().string(forKey: "id") ?? ""
    var reviews: Reviews?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cv.layer.borderWidth = 0.5
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setupViews()
        setupCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        fetchLists()
    }
 
    func fetchLists() {
        if menuName != nil {
            let dicToSend: [String: Any] = ["func":"리뷰","menuId":String(menuId!), "id":id, "order":order]
            let dataToSend: Data = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
            
            ApiService.shared.getData(dataToSend: dataToSend){ (reviews: Reviews) in
                self.reviews = reviews
                self.collectionView.reloadData()
                
            }
        }
    }
    
    func setupViews() {
        view.addSubview(goBackButton)
        view.addSubview(goToWriteReviewButton)
        view.addSubview(orderByRecentButton)
        view.addSubview(orderByRecommendButton)
        
        orderByRecentButton.addTarget(self, action: #selector(orderButtonSelected(_:)), for: .touchUpInside)
        orderByRecommendButton.addTarget(self, action: #selector(orderButtonSelected(_:)), for: .touchUpInside)
        
        
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0),
                            size: .init(width: 30, height: 30))
        goToWriteReviewButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                     leading: nil,
                                     bottom: nil,
                                     trailing: nil,
                                     padding: .init(top: 40, left: 00, bottom: 0, right: 0),
                                     size: .init(width: 280, height: 40))
        goToWriteReviewButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        orderByRecentButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                   leading: view.leadingAnchor,
                                   bottom: nil,
                                   trailing: nil,
                                   padding: .init(top: 100, left: 10, bottom: 0, right: 0))
        orderByRecommendButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                      leading: orderByRecentButton.trailingAnchor,
                                      bottom: nil,
                                      trailing: nil,
                                      padding: .init(top: 100, left: 10, bottom: 0, right: 0))
    }
    
    
    func setupCollectionView() {
        view.addSubview(collectionView)
        collectionView.anchor(top: orderByRecentButton.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor,
                              padding: .init(top: 10, left: 0, bottom: 0, right: 0))
        collectionView.register(MenuReviewCell.self, forCellWithReuseIdentifier: "review")
        collectionView.register(CryingCell.self, forCellWithReuseIdentifier: "crying")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if reviews?.reviews?.count == 0 {
            return 1
        } else{
            return reviews?.reviews?.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if reviews?.reviews?.count == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "crying", for: indexPath) as! CryingCell
            collectionView.backgroundColor = UIColor.white
            return cell
        } else {
            collectionView.backgroundColor = UIColor(white: 0.9, alpha: 1)
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "review", for: indexPath) as! MenuReviewCell
            cell.review = reviews?.reviews?[indexPath.row]
            cell.reviewController = self
            cell.backgroundColor = UIColor.white
            
            
            cell.setNeedsUpdateConstraints()
            cell.updateConstraintsIfNeeded()
            cell.layer.borderWidth = 0.3
            cell.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
            return cell
        }
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heightPlus: Int
        
        if reviews?.reviews?.count == 0 {
            return CGSize(width: view.frame.width - 70, height: view.frame.height - 120)
        }
        let approximateWidth = view.frame.width - 30 - 5 - 5 - 10
        let size = CGSize(width: approximateWidth, height: 1000)
        let attribute = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
        let estimatedFrame = NSString(string: (reviews?.reviews?[indexPath.row].contents)!).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attribute, context: nil)
        
        let temp = (reviews?.reviews?[indexPath.row].reviewPic)!
        let index = temp.lastIndex(of: "/")
        let def = temp[index! ..< temp.endIndex]
        if def == "/default" {
            heightPlus = 0
        } else {
            heightPlus = 150
        }
        
        if (reviews?.reviews?[indexPath.row].contents == "") {
            heightPlus -= 20
        }

        return CGSize(width: view.frame.width, height: estimatedFrame.height + 100 + CGFloat(heightPlus))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
    var order: String = "time"
    
    @objc func orderButtonSelected(_ sender: UIButton) {
        if  sender.tag == 1 {
            order = "time"
            orderByRecommendButton.titleLabel?.textColor = UIColor.black
        } else if sender.tag == 2 {
            order = "recommend"
            orderByRecentButton.titleLabel?.textColor = UIColor.black
        }
        sender.setTitleColor(themeColor, for: .normal)
        fetchLists()
    }
    
    
    func animateImageView(reviewImageView: UIImageView) {
        let photoViewController = PhotoDetailViewController()
        photoViewController.reviewImageView.image = reviewImageView.image
        self.present(photoViewController, animated: true)
    }
    
    let goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        button.accessibilityIdentifier = "리뷰에서 뒤로가기"
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goBackToMemberController), for: .touchUpInside)
        return button
    }()
    
    let goToWriteReviewButton: UIButton = {
        let button = UIButton()
        button.setTitle("리뷰 작성", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 17)
        button.accessibilityIdentifier = "리뷰 작성으로 가기"
        button.layer.cornerRadius = 5
        button.backgroundColor = themeColor
        button.addTarget(self, action: #selector(goToWriteReviwController), for: .touchUpInside)
        return button
    }()
    
    let orderByRecentButton: UIButton = {
        let button = UIButton()
        button.setTitle("최신순", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(themeColor, for: .normal)
        button.backgroundColor = UIColor.clear
        button.tag = 1
        return button
    }()
    
    let orderByRecommendButton: UIButton = {
        let button = UIButton()
        button.setTitle("추천순", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.setTitleColor(UIColor.black, for: .normal)
        button.backgroundColor = UIColor.clear
        button.tag = 2
        return button
    }()
    
    let cryingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "리뷰 없음")
        return imageView
    }()
    
    @objc func goBackToMemberController() {
        self.presentingViewController?.dismiss(animated: true)
    }
    
    @objc func goToWriteReviwController() {
        
        if !UserDefaults().bool(forKey: "isLoggedIn") {
            let vc = LoginController()
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true, completion: nil)
        } else {
            let vc = WriteReviewController()
            vc.menuId = menuId
            vc.modalTransitionStyle = .coverVertical
            self.present(vc, animated: true)
        }
    }
    
}
