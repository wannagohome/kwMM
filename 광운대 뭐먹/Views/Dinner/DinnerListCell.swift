//
//  DinnerListCell.swift
//  SettingUI
//
//  Created by Peter Jang on 28/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit

class BaseCell: UICollectionViewCell {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    func setupViews() {
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class DinnerListCell: BaseCell {
    
    var dinnerList: List? {
        didSet {
            dinnerNameLabel.text = dinnerList?.dinnerName
            rateLabel.text = String(format: "%.1f", (dinnerList?.rate)!)
            numberOfRateLabel.text = "리뷰 수 : " + String(format: "%d" ,(dinnerList?.numberOfRate)!)
        }
    }
    
    
    
    override func setupViews() {
        addSubview(dinnerNameLabel)
        addSubview(rateLabel)
        addSubview(ratingView)
        addSubview(arrowIconImageView)
        addSubview(numberOfRateLabel)
        
        dinnerNameLabel.anchor(top: nil,
                               leading: contentView.leadingAnchor,
                               bottom: nil,
                               trailing: nil,
                               padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                               size: .init(width: 0, height: 20))
        dinnerNameLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -5).isActive = true
        
        ratingView.anchor(top: dinnerNameLabel.bottomAnchor,
                         leading: dinnerNameLabel.leadingAnchor,
                         bottom: nil,
                         trailing: nil)
        rateLabel.anchor(top: dinnerNameLabel.bottomAnchor,
                         leading: ratingView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        numberOfRateLabel.anchor(top: rateLabel.topAnchor,
                                 leading: rateLabel.trailingAnchor,
                                 bottom: nil,
                                 trailing: nil,
                                 padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        
        arrowIconImageView.anchor(top: nil,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: contentView.trailingAnchor,
                                  padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        arrowIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
    }
    
    var ratingView: CosmosView = {
        let ratingView = CosmosView()
        ratingView.settings.minTouchRating = 1
        ratingView.settings.starMargin = 0
        ratingView.settings.totalStars = 1
        ratingView.starSize = 15.0
        ratingView.rating = 1
        ratingView.sizeToFit()
        return ratingView
    }()
    
    let dinnerNameLabel: UILabel = {
        let label = UILabel()
        label.text = "dinnerName"
        label.font = UIFont.systemFont(ofSize: 17)
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "rate"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let arrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right")
        return imageView
    }()
    
    let numberOfRateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.gray
        return label
    }()
}
