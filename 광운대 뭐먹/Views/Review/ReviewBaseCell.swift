//
//  ReviewBaseCell.swift
//  SettingUI
//
//  Created by Peter Jang on 25/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import SDWebImage

class ReviewBaseCell: BaseCell {
    
    var reviewId: Int?
    
    var heightAnchorConstraint150: NSLayoutConstraint?
    var heightAnchorConstraint0: NSLayoutConstraint?
    var recommend: Int?
    var id = UserDefaults().string(forKey: "id") ?? " "
    
    var review: Review? {
        didSet {
            nicknameLable.text = review?.nickname
            
            let dateFormatter: DateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd HH:mm:ss"
            dateFormatter.locale = Locale(identifier: "ko_kr")
            dateFormatter.timeZone = TimeZone(abbreviation: "KST")
            let writedDate: Date? = dateFormatter.date(from: (review?.time)!) ?? Date()
            let now: Date = Date()
            let component: DateComponents? = Calendar.current.dateComponents([.weekOfYear, .day, .hour, .minute], from: writedDate!, to: now)
            var timeString: String = ""
            
            if component != nil {
                if (component?.weekOfYear)! < 5 {
                    timeString = String((component?.weekOfYear)!) + "주 전"
                    
                    if (component?.day)! < 30 && (component?.weekOfYear)! == 0 {
                        timeString = String((component?.day)!) + "일 전"
                        
                        if (component?.hour)! < 24 && (component?.day)! == 0 {
                            timeString = String((component?.hour)!) + "시간 전"
                            
                            if (component?.minute)! < 60 && (component?.hour)! == 0 {
                                if component?.minute == 0 {
                                    timeString = "조금 전"
                                } else {
                                    timeString = String((component?.minute)!) + "분 전"
                                }
                            }
                        }
                    }
                } else {
                    dateFormatter.dateFormat = "yyyy/MM/dd"
                    timeString = dateFormatter.string(from: writedDate!)
                }
            }
            
            timeLable.text = timeString
            contentTextView.text = review?.contents
            reviewId = review?.reviewId
            contentView.accessibilityIdentifier = "ReviewCell contentView" + String(reviewId!)
            rateView.rating = (review?.rate)!
            recommend = review?.recommend
            recommendNumberLable.text = String(recommend!)
            recommendButton.tag = reviewId!
            
            if review?.isRecommended! == 1 {
                recommendButton.setImage(UIImage(named: "thumbcolor"), for: .normal)
                
            } else {
                recommendButton.setImage(UIImage(named: "thumb"), for: .normal)
            }
            
            let temp = (review?.reviewPic)!
            let index = temp.lastIndex(of: "/")
            let def = temp[index! ..< temp.endIndex]

            if def == "/default" {
                self.reviewImageView.removeConstraint(self.heightAnchorConstraint150!)
                self.heightAnchorConstraint0?.isActive = true
            } else {
                self.reviewImageView.removeConstraint(self.heightAnchorConstraint0!)
                self.heightAnchorConstraint150?.isActive = true
//                reviewImageView.fetchImage(URLs: self.review?.reviewPic)
                reviewImageView.sd_setImage(with: URL(string: (self.review?.reviewPic)!))
            }
            
            
//            profileImageView.fetchImage(URLs: self.review?.profilePic)
            profileImageView.sd_setImage(with: URL(string: (self.review?.profilePic)!), placeholderImage: UIImage(named: "avatar"))
            
            
        }
    }
    
    weak var dinnerController: DinnerController?
    weak var reviewController: ReviewController?
    weak var myReviewController: MyReviewController?
    
    @objc func animate() {
        if dinnerController != nil {
            dinnerController?.animateImageView(reviewImageView: reviewImageView)
        } else if reviewController != nil {
            reviewController?.animateImageView(reviewImageView: reviewImageView)
        } else if myReviewController != nil {
            myReviewController?.animateImageView(reviewImageView: reviewImageView)
        }
        
    }
    
    
    override func setupViews() {
        
        addSubview(nicknameLable)
        addSubview(timeLable)
        addSubview(contentTextView)
        addSubview(profileImageView)
        addSubview(reviewImageView)
        addSubview(rateView)
        
        reviewImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ReviewBaseCell.animate as (ReviewBaseCell) -> () -> () )))
        profileImageView.anchor(top: contentView.topAnchor,
                                leading: contentView.leadingAnchor,
                                bottom: nil,
                                trailing: nil,
                                padding: .init(top: 15, left: 15, bottom: 0, right: 0),
                                size: .init(width: 30, height: 30))
        profileImageView.layer.cornerRadius = profileImageView.bounds.width / 2
        nicknameLable.anchor(top: contentView.topAnchor,
                             leading: profileImageView.trailingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 15, left: 10, bottom: 0, right: 0),
                             size: .init(width: 0, height: 15))
        
        rateView.anchor(top: nicknameLable.bottomAnchor,
                        leading: profileImageView.trailingAnchor,
                        bottom: nil,
                        trailing: nil,
                        padding: .init(top: 5, left: 10, bottom: 0, right: 0))
        
        timeLable.anchor(top: nicknameLable.bottomAnchor,
                         leading: rateView.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: .init(top: 5, left: 5, bottom: 0, right: 0),
                         size: .init(width: 120, height: 15))
        
        
        reviewImageView.anchor(top: timeLable.bottomAnchor,
                               leading: profileImageView.trailingAnchor,
                               bottom: nil,
                               trailing: contentView.trailingAnchor,
                               padding: .init(top: 10, left: 5, bottom: 0, right: 40),
                               size: .init(width: 0, height: 0))
        heightAnchorConstraint150 = reviewImageView.heightAnchor.constraint(equalToConstant: 150)
        heightAnchorConstraint0 = reviewImageView.heightAnchor.constraint(equalToConstant: 0)
        heightAnchorConstraint150!.isActive = true
        contentTextView.anchor(top: reviewImageView.bottomAnchor,
                               leading: profileImageView.trailingAnchor,
                               bottom: contentView.bottomAnchor,
                               trailing: contentView.trailingAnchor,
                               padding: .init(top: 5, left: 5, bottom: 10, right: 10))
    }
    
    let recommendNumberLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.systemFont(ofSize: 10)
        return lable
    }()
    
    let recommendButton: UIButton = {
        let button = UIButton()
        button.accessibilityIdentifier = "recommend button"
//        button.setImage(UIImage(named: "thumb"), for: .normal)
        return button
    }()
    
    let nicknameLable: UILabel = {
        let label = UILabel()
        label.text = "닉네임"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: 15)
        label.accessibilityIdentifier = "review nickname"
        return label
    }()
    
    let timeLable: UILabel = {
        let lable = UILabel()
        lable.text = "작성시간"
        lable.textAlignment = .left
        lable.textColor = .gray
        lable.font = .systemFont(ofSize: 12)
        lable.accessibilityIdentifier = "review time"
        return lable
    }()
    
    
    let contentTextView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        textView.font = .systemFont(ofSize: 14)
        textView.text = "리뷰 내용"
        textView.isScrollEnabled = false
        textView.accessibilityIdentifier = "review content"
        return textView
    }()
    
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 20
        imageView.image = UIImage(named: "avatar")
        return imageView
    }()
    
    
    let reviewImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 3
        imageView.accessibilityIdentifier = "review image"
        return imageView
    }()
    
    

    let rateView: CosmosView = {
        let cosmosView = CosmosView()
        cosmosView.settings.updateOnTouch = false
        cosmosView.sizeToFit()
        cosmosView.starSize = 12
        cosmosView.starMargin = 0
        cosmosView.settings.filledColor = UIColor.black
        cosmosView.settings.filledBorderColor = UIColor.black
        cosmosView.settings.emptyBorderColor = UIColor.black
        return cosmosView
    }()
    
}
