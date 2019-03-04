//
//  ReviewCell.swift
//  SettingUI
//
//  Created by Peter Jang on 02/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit



class MyReviewCell: ReviewBaseCell {

    
    override func setupViews() {
        contentView.accessibilityIdentifier = "MyReviewCell contentView"
        super.setupViews()
        addSubview(deleteButton)
        addSubview(dinnerNameLabel)
        addSubview(menuNameLabel)
        
        
        dinnerNameLabel.anchor(top: nil,
                               leading: nil,
                               bottom: nil,
                               trailing: menuNameLabel.leadingAnchor,
                               padding: .init(top: 0, left: 0, bottom: 0, right: 0))
        dinnerNameLabel.centerYAnchor.constraint(equalTo: nicknameLable.centerYAnchor).isActive = true
        menuNameLabel.anchor(top: nil,
                             leading: nil,
                             bottom: nil,
                             trailing: deleteButton.leadingAnchor,
                             padding: .init(top: 0, left: 0, bottom: 0, right: 20))
        menuNameLabel.centerYAnchor.constraint(equalTo: nicknameLable.centerYAnchor).isActive = true
        
        deleteButton.anchor(top: contentView.topAnchor,
                            leading: nil,
                            bottom: nil,
                            trailing: contentView.trailingAnchor,
                            padding: .init(top: 10, left: 0, bottom: 0, right: 10),
                            size: .init(width: 20, height: 20))
        
        
        deleteButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteReview)))
    }
    
    let dinnerNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        return label
    }()
    
    let menuNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor(white: 0.5, alpha: 1)
        return label
    }()
    
    
    let deleteButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "review delete button"
        button.setImage(UIImage(named: "trash can"), for: .normal)
        return button
    }()
    
    
    
    @objc func deleteReview() {
        myReviewController?.deleteReview(reviewId: reviewId!)
    }
    
    
}
