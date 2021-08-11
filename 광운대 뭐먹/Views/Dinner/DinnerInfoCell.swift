//
//  DinnerInfoCell.swift
//  SettingUI
//
//  Created by Peter Jang on 01/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import GoogleMaps

class DinnerInfoCell: BaseCell{
    
    weak var dinnerController: DinnerController?
    var mapView: GMSMapView?
    var view = UIView()
    
    var info: Info? {
        didSet {
            let view = DinnerInfoController()
            view.mapViewDelegate = self.dinnerController
            view.x = info?.x
            view.y = info?.y
            view.dinnerName = info?.dinnerName
            mapView = view.view as? GMSMapView
            mapView?.settings.scrollGestures = false
            addSubview(mapView!)
            mapView!.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: nil,
                             trailing: contentView.trailingAnchor,
                             padding: .init(top: 30, left: 0, bottom: 0, right: 0),
                             size: .init(width: 0, height: 200))

            mapView?.delegate = dinnerController!
        }
    }

    
    
    
    override func setupViews() {
    }

    
}

