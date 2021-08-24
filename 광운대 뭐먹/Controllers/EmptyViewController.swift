//
//  EmptyViewController.swift
//  광운대 뭐먹
//
//  Created by Peter Jang on 11/03/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit

class EmptyViewController: UIViewController {
    override func viewDidLoad() {
        view.backgroundColor = UIColor.white
        navigationController?.isNavigationBarHidden = false
        let backBTN = UIBarButtonItem(image: UIImage(named: "Back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationController?.navigationBar.tintColor = .white
        view.addSubview(text)
        text.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                    leading: view.leadingAnchor,
                    bottom: view.bottomAnchor,
                    trailing: view.trailingAnchor)
    }
    
    let text: UITextView = {
        let textView = UITextView()
        return textView
    }()
}
