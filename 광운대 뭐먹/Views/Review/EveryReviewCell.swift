//
//  EveryReviewController.swift
//  SettingUI
//
//  Created by Peter Jang on 24/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class EveryReviewCell: BaseCell, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.9, alpha: 1)
        cv.accessibilityIdentifier = "EveryReviewCell collectionView"
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var dinnerName: String?
//    var reviewsSet: Reviews? {
//        didSet {
//            reviews = reviewsSet
//            collectionView.reloadData()
//        }
//    }
    weak var dinnerController: DinnerController?
    var jsonSet: JSON? {
        didSet {
            json = jsonSet
            collectionView.reloadData()
        }
    }
    
//    var reviews: Reviews?
    var json: JSON?
    let id = UserDefaults().string(forKey: "id") ?? " "
    weak var delegate: DinnerController?
    
    
    override func setupViews() {
        contentView.accessibilityIdentifier = "EveryReviewCell contentView"
        collectionView.register(MenuReviewCell.self, forCellWithReuseIdentifier: "review")
        addSubview(collectionView)
        addSubview(orderByRecentButton)
        addSubview(orderByRecommendButton)
        
        orderByRecentButton.addTarget(self, action: #selector(orderButtonSelected(_:)), for: .touchUpInside)
        orderByRecommendButton.addTarget(self, action: #selector(orderButtonSelected(_:)), for: .touchUpInside)
        
        orderByRecentButton.anchor(top: contentView.topAnchor,
                                   leading: contentView.leadingAnchor,
                                   bottom: nil,
                                   trailing: nil,
                                   padding: .init(top: 10, left: 15, bottom: 0, right: 0))
        orderByRecommendButton.anchor(top: orderByRecentButton.topAnchor,
                                      leading: orderByRecentButton.trailingAnchor,
                                      bottom: nil,
                                      trailing: nil,
                                      padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
        collectionView.anchor(top: orderByRecentButton.bottomAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor,
                              padding: .init(top: 10, left: 0, bottom: 0, right: 0))
    }
    
    var order: String = "time"
    
    func fetchLists() {
        let dicToSend: [String: Any] = ["func":"전체 리뷰","restaurantName":dinnerName!, "id":id, "order":order]
//        let dataToSend: Data = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        //FIXME: change view if needed
//        ApiService.shared.getData(dataToSend: dataToSend){ (reviews: Reviews) in
//            self.reviews = reviews
//            self.collectionView.reloadData()
//        }
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                self.json = JSON(value)
                self.collectionView.reloadData()
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.dinnerController?.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return reviews?.reviews?.count ?? 0
        return json?["reviews"].count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "review", for: indexPath) as! MenuReviewCell
        cell.dinnerController = self.delegate
//        cell.review = reviews?.reviews?[indexPath.row]
        cell.reviewJson = json?["reviews"][indexPath.row]
        cell.backgroundColor = UIColor.white
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor(white: 0.9, alpha: 1).cgColor
        
//        cell.menuNameLabel.text = reviews?.reviews?[indexPath.row].menuName
        cell.menuNameLabel.text = json?["reviews"][indexPath.row]["menuName"].string
        cell.setNeedsUpdateConstraints()
        cell.updateConstraintsIfNeeded()
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var heightPlus: Int
        
        let approximateWidth = contentView.frame.width - 30 - 5 - 5 - 10
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
        
        return CGSize(width: contentView.bounds.width, height: estimatedFrame.height + 120 + CGFloat(heightPlus))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 3
    }
    
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
}
