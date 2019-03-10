//
//  DinnerListController.swift
//  SettingUI
//
//  Created by Peter Jang on 27/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

class DinnerListController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DinnerForCategoryCellDelegate{
    
    let cellIDs = ["KoreanDishList", "PorkCutletList", "ChineseFoodList", "ChickenList", "PizzaList", "SnackBarList", "NoodleList", "CoffeAndDessertList"]
    var viewDidAppear: Bool = false
    var dinners: [Dinner]?
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(white: 0.95, alpha: 1)
        cv.dataSource = self
        cv.delegate = self
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "음식점들"
        navigationController?.navigationBar.isTranslucent = false
        let backBTN = UIBarButtonItem(image: UIImage(named: "Back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.navigationBar.tintColor = .white
        navigationController?.isNavigationBarHidden = false
        setupMenuBar()
        setupCollectionView()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    override func viewDidLayoutSubviews() {
        if !viewDidAppear {
            let selectedIndex = NSIndexPath(item: initialIndex, section: 0)
            collectionView.scrollToItem(at: selectedIndex as IndexPath, at: [.centeredHorizontally], animated: false)
            DispatchQueue.main.async {
                self.menuBar.collectionView.scrollToItem(
                    at: selectedIndex as IndexPath, at: [.centeredHorizontally], animated: false)
            }
            
            viewDidAppear = true
        }
    }
    
    lazy var menuBar: CategoryMenuBar = {
        let mb = CategoryMenuBar()
        mb.dinnerListController = self
        return mb
    }()
    
    private func setupCollectionView() {
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        collectionView.anchor(top: menuBar.bottomAnchor,
                              leading: view.leadingAnchor,
                              bottom: view.safeAreaLayoutGuide.bottomAnchor,
                              trailing: view.trailingAnchor)
        
        collectionView.register(KoreanDishCell.self, forCellWithReuseIdentifier: cellIDs[0])
        collectionView.register(ChineseFoodCell.self, forCellWithReuseIdentifier: cellIDs[1])
        collectionView.register(JapeneseFood.self, forCellWithReuseIdentifier: cellIDs[2])
        collectionView.register(SnackBarCell.self, forCellWithReuseIdentifier: cellIDs[3])
        collectionView.register(NoodleCell.self, forCellWithReuseIdentifier: cellIDs[4])
        collectionView.register(ChickenCell.self, forCellWithReuseIdentifier: cellIDs[5])
        collectionView.register(PizzaCell.self, forCellWithReuseIdentifier: cellIDs[6])
        collectionView.register(CoffeeAndDessertCell.self, forCellWithReuseIdentifier: cellIDs[7])
        

        collectionView.isPagingEnabled = true
    }
    
    private func setupMenuBar() {
        view.addSubview(menuBar)
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: 50).isActive = true
        menuBar.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeftAnchorConstraint?.constant = scrollView.contentOffset.x / 7
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
        return categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        weak var cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIDs[indexPath.item], for: indexPath) as? DinnerForCategoryCell
        cell?.delegate = self
        cell?.dinnerListController = self
        return cell!
        
    }
    
   func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width, height: collectionView.bounds.height)
    }
    
    func moveToDinnerController(_ dinnerName: String, _ rate: Double) {
        let vc = DinnerController()
        vc.dinnerName = dinnerName
        vc.rate = rate
        vc.modalTransitionStyle = .coverVertical
        self.navigationController?.pushViewController(vc, animated: true)
    }

}

