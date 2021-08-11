//
//  HttpCommunication.swift
//  dev3
//
//  Created by Peter Jang on 19/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import Foundation
import UIKit

class ApiService: NSObject {
    let url = URL(string: "http://kwmm.kr:8080/kwMM/Main2")
    static let shared = ApiService()
    
    
    func getData <T: Decodable> (dataToSend: Data, completion: @escaping (T) -> ()) {
        let request = chnageDataToRequest(dataToSend: dataToSend)
        fetchDataForRequest(request: request, completion: completion)
    }
    
    
    func chnageDataToRequest(dataToSend: Data) -> URLRequest {
        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = dataToSend
        
        request.addValue("applicaion/json", forHTTPHeaderField: "Content-Type")
        request.setValue(String(dataToSend.count), forHTTPHeaderField: "Content-Length")
        
        return request
    }
    
    func fetchDataForRequest <T: Decodable> (request: URLRequest, completion: @escaping (T) -> ()) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let mainContainer: UIView = UIView(frame: UIScreen.main.bounds)
        mainContainer.backgroundColor = UIColor(white: 1, alpha: 0)
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.image = UIImage(named: "loading1")
        imageView.center = mainContainer.center
        imageView.accessibilityHint = "로딩 이미지"
        imageView.layer.cornerRadius = 15
        imageView.tag = 10
        imageView.clipsToBounds = true
        
        if let keyWindow = UIApplication.shared.keyWindow{
//            keyWindow.isUserInteractionEnabled = false
            keyWindow.addSubview(mainContainer)
            keyWindow.addSubview(imageView)
        }
        
        if Global.shared.timer == nil {
            Global.shared.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(loadingAnimation(_:)), userInfo: imageView, repeats: true)
        }
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            if error != nil {
                self.stop()
                
                DispatchQueue.main.async {
                    let errorLable:UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: 230, height: 60))
                    errorLable.text = "네트워크 오류"
                    errorLable.textColor = lightblack
                    errorLable.font = UIFont.boldSystemFont(ofSize: 17)
                    errorLable.backgroundColor = UIColor.white
                    errorLable.textAlignment = .center
                    errorLable.tag = 198420917
                    if let keyWindow = UIApplication.shared.keyWindow{
                        errorLable.center = keyWindow.center
                        keyWindow.addSubview(errorLable)
                        Global.shared.isErrorLableShowing = true
                    }
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
                return
            }
            
            do {
                guard let data = data else { return }
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let dataGet = try decoder.decode(T.self, from: data)
                
                DispatchQueue.main.async {
                    completion(dataGet)
                }
                
            } catch let jsonError {
                print(jsonError)
                
            }
            
            DispatchQueue.main.async {
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            }
            
            self.stop()
            }.resume()
    }
    
    @objc func loadingAnimation(_ sender: Timer) {
        let imageView = sender.userInfo as! UIImageView
        if imageView.tag >= 10 {
            imageView.tag += 10
            let imageName: String = "loading" + String(imageView.tag/10)
            imageView.image = UIImage(named: imageName)
            
            if imageView.tag == 70 {
                imageView.tag = 7
            }
        } else {
            imageView.tag -= 1
            let imageName: String = "loading" + String(imageView.tag)
            imageView.image = UIImage(named: imageName)
        }
        if imageView.tag == 1 {
            imageView.tag = 10
            
        }
    }
    
    func stop() {
        if Global.shared.timer != nil {
            Global.shared.timer.invalidate()
            Global.shared.timer = nil
        }
        DispatchQueue.main.async {
            if let keyWindow = UIApplication.shared.keyWindow{
                for subview in keyWindow.subviews{
                    if subview.tag == 789456123 || subview.accessibilityHint == "로딩 이미지"{
                        subview.removeFromSuperview()
                    }
                }
            }
        }
        
    }
}
