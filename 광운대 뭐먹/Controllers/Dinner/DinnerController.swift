//
//  DinnerController.swift
//  SettingUI
//
//  Created by Peter Jang on 31/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import GoogleMaps

class DinnerController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, MenuListCellDelegate, GMSMapViewDelegate {
    
    var dinnerName: String?
    var rate: Double?
    
    var reviews: Reviews?
    var menus: MenuList? {
        didSet {
            for i in 0 ..< (menus?.restaurants?.count)! {
                let temp2: [MenuInfo]? = menus?.restaurants?[i].restaurant?.sorted{ $0.rate! > $1.rate! }
                menus?.restaurants?[i].restaurant = temp2
            }
        }
    }
    let id = UserDefaults().string(forKey: "id") ?? " "
    var isDataDidFetched: Int = 0
    
    
    lazy var menuBar: DinnerInfoMenuBar = {
        let mb = DinnerInfoMenuBar()
        mb.dinnerController = self
        return mb
    }()
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        rateView.rating = rate!
        rateLable.text = String(format: "%.1f", (rate!))
        
        setupViews()
        setupCollectionview()
        
        let selectedIndex = NSIndexPath(item: 0, section: 0)
        menuBar.collectionView.selectItem(at: selectedIndex as IndexPath, animated: false, scrollPosition: [])
        view.layer.shouldRasterize = true
        view.layer.rasterizationScale = UIScreen.main.scale

    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
//        view.loadingIndicator()
        getCoordinate()
        fetchMenuLists()
        fetchReviewLists()
    }
    
   
    
    private func setupViews() {
        view.addSubview(dinnerNameTextView)
        view.addSubview(rateView)
        view.addSubview(rateLable)
        view.addSubview(menuBar)
        view.addSubview(goBackButton)
        
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        dinnerNameTextView.text = dinnerName
        dinnerNameTextView.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: nil,
                                  padding: .init(top: 35, left: 0, bottom: 0, right: 0),
                                  size: .init(width: 200, height: 40))
        dinnerNameTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            .isActive = true
        
        rateView.anchor(top: dinnerNameTextView.bottomAnchor,
                        leading: nil,
                        bottom: nil,
                        trailing: nil,
                        padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        rateView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -15).isActive = true
        
        rateLable.anchor(top: dinnerNameTextView.bottomAnchor,
                         leading: rateView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: .init(top: 3, left: 5, bottom: 0, right: 0),
                         size: .init(width: 30, height: 20))
        
        menuBar.anchor(top: rateView.bottomAnchor,
                       leading: nil,
                       bottom: nil,
                       trailing: nil,
                       padding: .init(top: 10, left: 0, bottom: 0, right: 0),
                       size: .init(width: view.frame.width, height: 50))
        menuBar.layer.addBorder([.top, .bottom], color: UIColor(white: 0.0, alpha: 1), width: 1)
    }
    
    var dinnerInfo: DinnerInfo?
    
    func getCoordinate() {
        let dicToSend: [String : Any] = ["func":"info", "restaurantName":dinnerName!]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (result: DinnerInfo) in
            self.dinnerInfo = result
            self.isDataDidFetched += 1
            self.dataDidFatched()
        }
    }
    
    func fetchMenuLists() {
        if dinnerName != nil {
            
            let dicToSend = ["func":"메뉴 아이폰", "restaurantName":dinnerName!]
            let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
            
            ApiService.shared.getData(dataToSend: dataToSend){ (menus: MenuList) in
                self.menus = menus
                self.isDataDidFetched += 1
                self.dataDidFatched()
            }
        }
    }
    
    func fetchReviewLists() {
        let dicToSend: [String: Any] = ["func":"전체 리뷰","restaurantName":dinnerName!, "id":id, "order":"time"]
        let dataToSend: Data = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (reviews: Reviews) in
            self.reviews = reviews
            self.isDataDidFetched += 1
            self.dataDidFatched()
        }
    }
    
    func dataDidFatched() {
        if isDataDidFetched >= 3 {
//            view.loadingIndicator(false)
            self.collectionView.reloadData()
        }
    }
    
    
    func setupCollectionview() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        view.addSubview(collectionView)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.anchor(top: menuBar.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor)
        
        collectionView.register(MenuListCell.self, forCellWithReuseIdentifier: "MenuList")
        collectionView.register(EveryReviewCell.self, forCellWithReuseIdentifier: "everyreview")
        collectionView.register(DinnerInfoCell.self, forCellWithReuseIdentifier: "info")
        collectionView.register(CryingCell.self, forCellWithReuseIdentifier: "crying")
    }

    func animateImageView(reviewImageView: UIImageView) {
        
        let photoViewController = PhotoDetailViewController()
        photoViewController.reviewImageView.image = reviewImageView.image
        self.present(photoViewController, animated: true)

    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 3
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = NSIndexPath(item: Int(index), section: 0)
        menuBar.collectionView.selectItem(at: indexPath as IndexPath, animated: true, scrollPosition:[])
        
    }
    
    func scrollToMenuIndex(menuIndex: Int) {
        let indexPath = NSIndexPath(item: menuIndex, section: 0)
        collectionView.scrollToItem(at: indexPath as IndexPath, at: [], animated: true)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        if indexPath.item == 0 {
            weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MenuList", for: indexPath) as? MenuListCell
            cell?.dinnerName = self.dinnerName
            cell?.menusSet = self.menus
            cell?.delegate = self
            return cell!
        } else if indexPath.item == 1 {
            if reviews?.reviews?.count == 0 {
                weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "crying", for: indexPath) as? CryingCell
                return cell!
            } else {
                weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "everyreview", for: indexPath) as? EveryReviewCell
                cell?.delegate = self
                cell?.reviewsSet = self.reviews
                cell?.dinnerName = dinnerName
                return cell!
            }
        } else {
            weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "info", for: indexPath) as? DinnerInfoCell
            if dinnerInfo != nil {
                cell?.dinnerController = self
                cell?.info = dinnerInfo?.info
            }
            return cell!
        }
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        let vc = DinnerInfoController()
        vc.x = dinnerInfo?.info?.x
        vc.y = dinnerInfo?.info?.y
        vc.dinnerName = dinnerName

        self.navigationController?.pushViewController(vc, animated: true)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func moveToReviewController(_ menuName: String, _ menuId: Int) {
        let vc = ReviewController()
        vc.dinnerName = dinnerName
        vc.menuName = menuName
        vc.menuId = menuId
        vc.modalTransitionStyle = .coverVertical
        self.present(vc, animated: true)
    }
    
    let dinnerNameTextView: UITextView = {
        let textView = UITextView()
        textView.isUserInteractionEnabled = false
        textView.isEditable = false
        textView.text = "음식점 이름"
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 25)
        textView.textContainer.maximumNumberOfLines = 2
        textView.accessibilityIdentifier = "음식점 이름"
        return textView
    }()
    
    let rateView: CosmosView = {
        let rateView = CosmosView()
        rateView.settings.updateOnTouch = false
        rateView.sizeToFit()
        rateView.starSize = 14
        rateView.starMargin = 0
        rateView.settings.filledColor = UIColor.black
        rateView.settings.filledBorderColor = UIColor.black
        rateView.settings.emptyBorderColor = UIColor.black
        return rateView
    }()
    
    let goBackButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Back"), for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 23)
        button.accessibilityIdentifier = "음식점에서 뒤로가기"
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(goBackToMemberController), for: .touchUpInside)
        return button
    }()
    
    let rateLable: UILabel = {
        let lable = UILabel()
        lable.textColor = UIColor.black
        lable.font = UIFont.systemFont(ofSize: 13)
        return lable
    }()
    
    @objc func goBackToMemberController() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

class CryingCell: BaseCell {
    override func setupViews() {
        addSubview(cryingImageView)
        cryingImageView.anchor(top: nil,
                               leading: contentView.leadingAnchor,
                               bottom: nil,
                               trailing: contentView.trailingAnchor)
        cryingImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    let cryingImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "리뷰 없음")
        return imageView
    }()
    
}
