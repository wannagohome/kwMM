//
//  CategoryMenuBar.swift
//  SettingUI
//
//  Created by Peter Jang on 27/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit

class CategoryMenuBar: UIView, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor.white
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    weak var dinnerListController: DinnerListController?
    let selectedIndexPath = NSIndexPath(item: initialIndex, section: 0)
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        collectionView.register(CategoryMenuBarCell.self, forCellWithReuseIdentifier: "CategoryCell")
        
        addSubview(collectionView)
        addConstraintsWithFormat(format: "H:|[v0]|", views: collectionView)
        addConstraintsWithFormat(format: "V:|[v0]|", views: collectionView)
        
        collectionView.showsHorizontalScrollIndicator = false
        
        collectionView.selectItem(at: selectedIndexPath as IndexPath, animated: true, scrollPosition: [.centeredHorizontally])
//        collectionView.scrollToItem(at: selectedIndexPath as IndexPath, at: [.centeredHorizontally], animated: true)
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
        }
        
//        if dinnerListController == nil {
//            setupHorizontalBar()
//        }
    }
    
    
    
    var horizontalBarLeftAnchorConstraint: NSLayoutConstraint?
    
    
    func setupHorizontalBar() {
        
        let horizontalBarView = UIView()
        horizontalBarView.backgroundColor = themeColor
        horizontalBarView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(horizontalBarView)
        
        horizontalBarLeftAnchorConstraint = horizontalBarView.leftAnchor.constraint(equalTo: self.leftAnchor)
        horizontalBarLeftAnchorConstraint?.isActive = true
        horizontalBarView.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        horizontalBarView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1/7).isActive = true
        horizontalBarView.heightAnchor.constraint(equalToConstant: 4).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CategoryCell", for: indexPath) as? CategoryMenuBarCell
        
        cell?.categoryLabel.text = categories[indexPath.row]
        return cell!
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        dinnerListController?.scrollToMenuIndex(menuIndex: indexPath.item)
        collectionView.scrollToItem(at: indexPath, at: [.centeredHorizontally], animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.bounds.width/5.5, height: collectionView.bounds.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        
    }

}

class CategoryMenuBarCell: BaseCell {
    
    let categoryLabel: UILabel = {
        let label = UILabel()
        label.text = "category"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        return label
    }()
    
    override var isSelected: Bool {
        didSet {
            categoryLabel.font = isSelected ? UIFont.boldSystemFont(ofSize: 14) : UIFont.systemFont(ofSize: 12)
            categoryLabel.textColor = isSelected ? themeColor : lightblack
        }
    }
    
    override func setupViews() {
        backgroundColor = UIColor.white
        
        addSubview(categoryLabel)
        
        categoryLabel.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: contentView.bottomAnchor,
                             trailing: contentView.trailingAnchor)
    }
    
}
