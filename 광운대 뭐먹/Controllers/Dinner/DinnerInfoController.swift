//
//  DinnerInfoController.swift
//  SettingUI
//
//  Created by Peter Jang on 04/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit

class DinnerInfoController: UIViewController, GMSMapViewDelegate, CLLocationManagerDelegate {
    var x: Double?
    var y: Double?
    var dinnerName: String?
    weak var mapViewDelegate: DinnerController?
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
    }
    
    func didTapMyLocationButton(for mapView: GMSMapView) -> Bool {
        
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse :
            mapView.camera = GMSCameraPosition.camera(withLatitude: (mapView.myLocation?.coordinate.latitude)!, longitude: (mapView.myLocation?.coordinate.longitude)!, zoom: 16)
            break
        default:
            break
        }
        
        return true
    }
    
    func mapView(_ mapView: GMSMapView, didTapAt coordinate: CLLocationCoordinate2D) {
        print(coordinate.latitude)
        print(coordinate.longitude)
    }

    
    var mapView = GMSMapView.map(withFrame: CGRect.zero, camera: GMSCameraPosition.camera(withLatitude: -33.86, longitude: 151.20, zoom: 18.0))
    
    override func loadView() {
        if x != nil {
            let camera = GMSCameraPosition.camera(withLatitude: x!, longitude: y!, zoom: 18.0)
            
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.delegate = mapViewDelegate ?? self
            if mapViewDelegate == nil {
                mapView.settings.myLocationButton = true
                mapView.isMyLocationEnabled = true
            }
            
            mapView.settings.tiltGestures = false
            
            view = mapView
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: x!, longitude: y!)
            marker.map = mapView
            marker.title = dinnerName!
        } else {
            view = UIView()
        }
    }
}
