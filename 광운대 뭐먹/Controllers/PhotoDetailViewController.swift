//
//  PhotoDetailViewController.swift
//  SettingUI
//
//  Created by Peter Jang on 12/02/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit

class PhotoDetailViewController: UIViewController, UIScrollViewDelegate {
    var reviewImageView: UIImageView = UIImageView()
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.backgroundColor = UIColor.black
        sv.minimumZoomScale = 1
        sv.maximumZoomScale = 6
        sv.delegate = self
        return sv
    }()
    
    let goBackButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.titleLabel?.textColor = UIColor.white
        button.backgroundColor = UIColor.clear
        return button
    }()
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return reviewImageView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        goBackButton.addTarget(self, action: #selector(goBack), for: .touchUpInside)
        
        view.addSubview(scrollView)
        view.addSubview(goBackButton)
        scrollView.addSubview(reviewImageView)
        
        scrollView.anchor(top: goBackButton.bottomAnchor,
                          leading: view.leadingAnchor,
                          bottom: view.safeAreaLayoutGuide.bottomAnchor,
                          trailing: view.trailingAnchor)
        goBackButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                            leading: view.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 10, left: 10, bottom: 0, right: 0))
        
        reviewImageView.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor).isActive = true
        reviewImageView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        reviewImageView.translatesAutoresizingMaskIntoConstraints = false
        reviewImageView.widthAnchor.constraint(equalToConstant: view.bounds.width).isActive = true
        reviewImageView.contentMode = .scaleAspectFit
        
    }
    
    @objc func goBack() {
        self.presentingViewController?.dismiss(animated: true)
    }
}
