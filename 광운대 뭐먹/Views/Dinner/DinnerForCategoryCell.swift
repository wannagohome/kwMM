//
//  NoodleCell.swift
//  SettingUI
//
//  Created by Peter Jang on 28/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

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
    var json: JSON?
    weak var delegate: DinnerForCategoryCellDelegate?
    weak var dinnerListController: DinnerListController?
    var dicToSend:Parameters = ["func":"categoryList", "category":categories[0]]
    
    func fetchLists() {
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
                self.dinnerListController?.showAlert(message: "네트워크 오류")
                
            }
        }
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
        if json != nil {
            return json?["list"].count ?? 0
        } else {
            return dinners?.list?.count ?? 0
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! DinnerListCell
        
        if json != nil {
            cell.dinnerListJson = json?["list"][indexPath.row]
        } else {
            cell.dinnerList = dinners?.list?[indexPath.row]
        }
        
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
            del.moveToDinnerController((json?["list"][index]["dinnerName"].string)!, (json?["list"][index]["rate"].double)!)
        }
    }
}

protocol DinnerForCategoryCellDelegate: class {
    func moveToDinnerController(_ dinnerName: String, _ rate: Double)
}


class KoreanDishCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[0]]
        
        super.fetchLists()
    }
}

class ChineseFoodCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[1]]
        
        super.fetchLists()
    }
}

class JapeneseFood: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[2]]
        
        super.fetchLists()
    }
}


class SnackBarCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[3]]
        
        super.fetchLists()
    }
}


class NoodleCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[4]]
        
        super.fetchLists()
    }
}



class ChickenCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[5]]
        
        super.fetchLists()
    }
}

class PizzaCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":"햄버거"]
        
        super.fetchLists()
    }
}



class CoffeeAndDessertCell: DinnerForCategoryCell {
    override func fetchLists() {
        dicToSend = ["func":"categoryList", "category":categories[7]]
        
        super.fetchLists()
    }
}
