//
//  Extentions.swift
//  SettingUI
//
//  Created by Peter Jang on 28/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import CommonCrypto

class Global {
    static var shared = Global()
    weak var timer: Timer!
    var isErrorLableShowing: Bool = false
    static func removeErrorLable() {
        if let keyWindow = UIApplication.shared.keyWindow{
            for subview in keyWindow.subviews{
                if subview.tag == 198420917{
                    subview.removeFromSuperview()
                }
            }
        }
    }
}

let themeColor: UIColor = UIColor(red: 1, green: 117/255, blue: 0, alpha: 1)
let lightblack: UIColor = UIColor(red: 67/255, green: 67/255, blue: 67/255, alpha: 1)
var imageCache = NSCache<AnyObject, AnyObject>()
var initialIndex: Int = 0
var updateString: String = ""

extension UIView {
    
    func addConstraintsWithFormat(format: String, views: UIView...) {
        var viewsDictionary = [String:UIView]()
        for(index, view) in views.enumerated() {
            let key = "v\(index)"
            viewsDictionary[key] = view
            view.translatesAutoresizingMaskIntoConstraints = false
        }
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: format, options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: viewsDictionary))
    }
    
    func loadingIndicator(_ startAnimate: Bool = true) {
        
        let mainContainer: UIView = UIView(frame: self.frame)
        mainContainer.center = self.center
        mainContainer.backgroundColor = UIColor.white
        mainContainer.alpha = 0.2
        mainContainer.tag = 789456123
        mainContainer.isUserInteractionEnabled = false
        
        let imageView: UIImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        imageView.image = UIImage(named: "loading1")
        imageView.center = self.center
        imageView.alpha = 1
        imageView.tag = 10
        imageView.accessibilityHint = "로딩 이미지"
        
        
        if startAnimate {
            self.isUserInteractionEnabled = false
            self.addSubview(mainContainer)
            self.addSubview(imageView)
            imageView.layer.cornerRadius = 15
            imageView.clipsToBounds = true

            if Global.shared.timer == nil {

                Global.shared.timer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(loadingAnimation(_:)), userInfo: imageView, repeats: true)
            }
            
        } else {
            self.isUserInteractionEnabled = true
            if Global.shared.timer != nil {
                Global.shared.timer.invalidate()
                Global.shared.timer = nil
            }
            
            for subview in self.subviews{
                if subview.tag == 789456123 || subview.accessibilityHint == "로딩 이미지"{
                    subview.removeFromSuperview()
                }
            }
        }
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
    
    func hide() {
        self.isHidden = true
        self.alpha = 0
    }
    
}

extension UITextField {
    func givePadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 7, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = UITextField.ViewMode.always
    }
}


extension UIView {
    
    func rotate(_ toValue: CGFloat, duration: CFTimeInterval = 0.15) {
        let animation = CABasicAnimation(keyPath: "transform.rotation")
        
        animation.toValue = toValue
        animation.duration = duration
        animation.isRemovedOnCompletion = false
        animation.fillMode = CAMediaTimingFillMode.forwards
        
        self.layer.add(animation, forKey: nil)
    }
    
    func fillSuperview() {
        anchor(top: superview?.topAnchor, leading: superview?.leadingAnchor, bottom: superview?.bottomAnchor, trailing: superview?.trailingAnchor)
    }
    
    func anchorSize(to view: UIView) {
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        heightAnchor.constraint(equalTo: view.heightAnchor).isActive = true
    }
    
    func anchor(top: NSLayoutYAxisAnchor?, leading: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, trailing: NSLayoutXAxisAnchor?, padding: UIEdgeInsets = .zero, size: CGSize = .zero) {
        translatesAutoresizingMaskIntoConstraints = false
        
        if let top = top {
            topAnchor.constraint(equalTo: top, constant: padding.top).isActive = true
        }
        
        if let leading = leading {
            leadingAnchor.constraint(equalTo: leading, constant: padding.left).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -padding.bottom).isActive = true
        }
        
        if let trailing = trailing {
            trailingAnchor.constraint(equalTo: trailing, constant: -padding.right).isActive = true
        }
        
        if size.width != 0 {
            widthAnchor.constraint(equalToConstant: size.width).isActive = true
        }
        
        if size.height != 0 {
            heightAnchor.constraint(equalToConstant: size.height).isActive = true
        }
    }
    
    
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        for edge in arr_edge {
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

extension UIImageView {
    func fetchImage(URLs: String?) {
        let imageURL = URL(string: URLs!)
        
        if let image = imageCache.object(forKey: URLs as AnyObject) as? UIImage {
            self.image = image
        } else {
            
            URLSession.shared.dataTask(with: imageURL!, completionHandler: {(data, response, error) -> Void in
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = true
                }
                if error != nil {
                    print(error as Any)
                    return
                }
                
                let imageData = NSData(contentsOf: imageURL!)
                if imageData != nil {
                    let image = UIImage(data: data!)
                    if image != nil {
                        imageCache.setObject(image!, forKey: URLs as AnyObject)
                    }
                    DispatchQueue.main.async {
                        self.image = image
                    }
                } else {
                    
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                }
            }).resume()
        }
    }
}

extension String {
    
    // MARK: - SHA256
    func getSha256String() -> String {
        guard let data = self.data(using: .utf8) else {
            print("Data not available")
            return ""
        }
        return getHexString(fromData: digest(input: data as NSData))
    }
    
    private func digest(input : NSData) -> NSData {
        let digestLength = Int(CC_SHA256_DIGEST_LENGTH)
        var hashValue = [UInt8](repeating: 0, count: digestLength)
        CC_SHA256(input.bytes, UInt32(input.length), &hashValue)
        return NSData(bytes: hashValue, length: digestLength)
    }
    
    private  func getHexString(fromData data: NSData) -> String {
        var bytes = [UInt8](repeating: 0, count: data.length)
        data.getBytes(&bytes, length: data.length)
        
        var hexString = ""
        for byte in bytes {
            hexString += String(format:"%02x", UInt8(byte))
        }
        return hexString
    }
}


extension MainViewController {
    func restrict(message: String)  {
        
        let darkView = UIView(frame: UIScreen.main.bounds)

        darkView.backgroundColor = UIColor(white: 0, alpha: 0.5)
        darkView.isUserInteractionEnabled = false
        
        let notiTextView = UITextView()
        notiTextView.isUserInteractionEnabled = false
        notiTextView.backgroundColor = UIColor.white
        notiTextView.text = message
        notiTextView.font = UIFont.boldSystemFont(ofSize: 15)
        notiTextView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        notiTextView.textAlignment = .center

        if let keyWindow = UIApplication.shared.keyWindow{
            keyWindow.isUserInteractionEnabled = false
            keyWindow.addSubview(darkView)
        }
        darkView.addSubview(notiTextView)
        
        notiTextView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        notiTextView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        notiTextView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        notiTextView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        notiTextView.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
}
