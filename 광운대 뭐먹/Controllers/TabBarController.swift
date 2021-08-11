//
//  TabBarController.swift
//  SettingUI
//
//  Created by Peter Jang on 27/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        let feedController = MainViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let navigationController = UINavigationController(rootViewController: feedController)
        navigationController.title = "Main"
        navigationController.tabBarItem.image = UIImage(named: "fork")
        
        
        
        let myReviewController = MyReviewController()
        let secondNavigationController = UINavigationController(rootViewController: myReviewController)
        secondNavigationController.title = "내 리뷰"
        secondNavigationController.tabBarItem.image = UIImage(named: "myreview")
        
        
        
        let memberController = MemberController()
        let thirdNavigationController = UINavigationController(rootViewController: memberController)
        thirdNavigationController.title = "My 뭐먹"
        thirdNavigationController.tabBarItem.image = UIImage(named: "avatar")
        
        viewControllers = [navigationController, secondNavigationController, thirdNavigationController]
        
        tabBar.isTranslucent = false
    }
    

   
}
