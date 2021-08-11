//
//  NoodleCell.swift
//  SettingUI
//
//  Created by Peter Jang on 28/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit

class DinnerForCategoryCell: BaseCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    var dinners: Dinner?
    weak var delegate: DinnerForCategoryCellDelegate?
    
    func fetchLists() {
    }
    
    override func setupViews() {
        backgroundColor = UIColor.white
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
        fetchLists()
        addSubview(collectionView)
        
        collectionView.anchor(top: contentView.topAnchor,
                              leading: contentView.leadingAnchor,
                              bottom: contentView.bottomAnchor,
                              trailing: contentView.trailingAnchor)
        
        collectionView.register(DinnerListCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dinners?.list?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DinnerListCell
        
        cell.dinnerList = dinners?.list?[indexPath.row]
        cell.backgroundColor = .white
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: frame.width, height: 70)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegateAction(indexPath.item)
       
    }
    
    func delegateAction(_ index: Int) {
        if let del = self.delegate {
            del.moveToDinnerController((dinners?.list?[index].dinnerName)!, (dinners?.list?[index].rate)!)
        }
    }
}

protocol DinnerForCategoryCellDelegate: class {
    func moveToDinnerController(_ dinnerName: String, _ rate: Double)
}


class KoreanDishCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[0]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}

class ChineseFoodCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[1]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}

class JapeneseFood: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[2]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}


class SnackBarCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[3]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}


class NoodleCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[4]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}



class ChickenCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[5]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}

class PizzaCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":"햄버거"]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}



class CoffeeAndDessertCell: DinnerForCategoryCell {
    override func fetchLists() {
        let dicToSend = ["func":"categoryList", "category":categories[7]]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (dinners: Dinner) in
            
            self.dinners = dinners
            self.collectionView.reloadData()
            
        }
    }
}
