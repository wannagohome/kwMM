//
//  Extentions.swift
//  SettingUI
//
//  Created by Peter Jang on 28/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit
import CommonCrypto
import SwiftyJSON

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
    let iconRef:String = """
한식 made by Freepik(https://www.freepik.com/) from www.flaticon.com
중식 made by Pause08 from www.flaticon.com
일식 made by Freepik(https://www.freepik.com/) from www.flaticon.com
분식 made by Freepik(https://www.freepik.com/) from www.flaticon.com
면 made by Freepik(https://www.freepik.com/) from www.flaticon.com
햄버거/피자 made by Freepik(https://www.freepik.com/) from www.flaticon.com
치킨 made by Freepik(https://www.freepik.com/) from www.flaticon.com
디저트 made by Freepik(https://www.freepik.com/) from www.flaticon.com
한식 made by Pixel perfect (https://icon54.com/) from www.flaticon.com
개인정보수정 made by Freepik(https://www.freepik.com/) from www.flaticon.com
건의사항 made by monkik from www.flaticon.com
버전 made by monkik from www.flaticon.com
"""
    
    let peersonalInfo:String = """
        ('광운대뭐먹')은(는) 개인정보보호법에 따라 이용자의 개인정보 보호 및 권익을 보호하고 개인정보와 관련한 이용자의 고충을 원활하게 처리할 수 있도록 다음과 같은 처리방침을 두고 있습니다.

('광운대뭐먹') 은(는) 회사는 개인정보처리방침을 개정하는 경우 웹사이트 공지사항(또는 개별공지)을 통하여 공지할 것입니다.

○ 본 방침은부터 2019년 2월 21일부터 시행됩니다.


1. 개인정보의 처리 목적 ('광운대뭐먹')은(는) 개인정보를 다음의 목적을 위해 처리합니다. 처리한 개인정보는 다음의 목적이외의 용도로는 사용되지 않으며 이용 목적이 변경될 시에는 사전동의를 구할 예정입니다.

가. 홈페이지 회원가입 및 관리

회원 가입의사 확인, 회원제 서비스 제공에 따른 본인 식별·인증, 회원자격 유지·관리, 서비스 부정이용 방지 등을 목적으로 개인정보를 처리합니다.




2. 개인정보 파일 현황

1. 개인정보 파일명 : kwMM
- 개인정보 항목 : 이메일, 비밀번호, 로그인ID, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보
- 수집방법 : 모바일 어플리케이션
- 보유근거 : 정보주체의 동의
- 보유기간 : 탈퇴 시 까지
- 관련법령 : 소비자의 불만 또는 분쟁처리에 관한 기록 : 3년, 표시/광고에 관한 기록 : 6개월




3. 개인정보의 처리 및 보유 기간

① ('광운대뭐먹')은(는) 법령에 따른 개인정보 보유·이용기간 또는 정보주체로부터 개인정보를 수집시에 동의 받은 개인정보 보유,이용기간 내에서 개인정보를 처리,보유합니다.

② 각각의 개인정보 처리 및 보유 기간은 다음과 같습니다.

4. 정보주체와 법정대리인의 권리·의무 및 그 행사방법 이용자는 개인정보주체로써 다음과 같은 권리를 행사할 수 있습니다.

① 정보주체는 광운대뭐먹에 대해 언제든지 개인정보 열람,정정,삭제,처리정지 요구 등의 권리를 행사할 수 있습니다.
② 제1항에 따른 권리 행사는 광운대뭐먹에 대해 개인정보 보호법 시행령 제41조제1항에 따라 서면, 전자우편, 모사전송(FAX) 등을 통하여 하실 수 있으며 광운대뭐먹은(는) 이에 대해 지체 없이 조치하겠습니다.
③ 제1항에 따른 권리 행사는 정보주체의 법정대리인이나 위임을 받은 자 등 대리인을 통하여 하실 수 있습니다. 이 경우 개인정보 보호법 시행규칙 별지 제11호 서식에 따른 위임장을 제출하셔야 합니다.
④ 개인정보 열람 및 처리정지 요구는 개인정보보호법 제35조 제5항, 제37조 제2항에 의하여 정보주체의 권리가 제한 될 수 있습니다.
⑤ 개인정보의 정정 및 삭제 요구는 다른 법령에서 그 개인정보가 수집 대상으로 명시되어 있는 경우에는 그 삭제를 요구할 수 없습니다.
⑥ 광운대뭐먹은(는) 정보주체 권리에 따른 열람의 요구, 정정·삭제의 요구, 처리정지의 요구 시 열람 등 요구를 한 자가 본인이거나 정당한 대리인인지를 확인합니다.



5. 처리하는 개인정보의 항목 작성

① ('광운대뭐먹')은(는) 다음의 개인정보 항목을 처리하고 있습니다.

1<홈페이지 회원가입 및 관리>
- 필수항목 : 이메일, 비밀번호, 로그인ID, 서비스 이용 기록, 접속 로그, 쿠키, 접속 IP 정보




6. 개인정보의 파기('광운대뭐먹')은(는) 원칙적으로 개인정보 처리목적이 달성된 경우에는 지체없이 해당 개인정보를 파기합니다. 파기의 절차, 기한 및 방법은 다음과 같습니다.

-파기절차
이용자가 입력한 정보는 목적 달성 후 별도의 DB에 옮겨져(종이의 경우 별도의 서류) 내부 방침 및 기타 관련 법령에 따라 일정기간 저장된 후 혹은 즉시 파기됩니다. 이 때, DB로 옮겨진 개인정보는 법률에 의한 경우가 아니고서는 다른 목적으로 이용되지 않습니다.

-파기기한
이용자의 개인정보는 개인정보의 보유기간이 경과된 경우에는 보유기간의 종료일로부터 5일 이내에, 개인정보의 처리 목적 달성, 해당 서비스의 폐지, 사업의 종료 등 그 개인정보가 불필요하게 되었을 때에는 개인정보의 처리가 불필요한 것으로 인정되는 날로부터 5일 이내에 그 개인정보를 파기합니다.

-파기방법
전자적 파일 형태의 정보는 기록을 재생할 수 없는 기술적 방법을 사용합니다.



7. 개인정보 자동 수집 장치의 설치•운영 및 거부에 관한 사항

① 광운대뭐먹 은 개별적인 맞춤서비스를 제공하기 위해 이용정보를 저장하고 수시로 불러오는 ‘쿠키(cookie)’를 사용합니다. ② 쿠키는 웹사이트를 운영하는데 이용되는 서버(http)가 이용자의 컴퓨터 브라우저에게 보내는 소량의 정보이며 이용자들의 PC 컴퓨터내의 하드디스크에 저장되기도 합니다. 가. 쿠키의 사용 목적 : 이용자가 방문한 각 서비스와 웹 사이트들에 대한 방문 및 이용형태, 인기 검색어, 보안접속 여부, 등을 파악하여 이용자에게 최적화된 정보 제공을 위해 사용됩니다. 나. 쿠키의 설치•운영 및 거부 : 웹브라우저 상단의 도구>인터넷 옵션>개인정보 메뉴의 옵션 설정을 통해 쿠키 저장을 거부 할 수 있습니다. 다. 쿠키 저장을 거부할 경우 맞춤형 서비스 이용에 어려움이 발생할 수 있습니다.


8. 개인정보 보호책임자 작성


① 광운대뭐먹 은(는) 개인정보 처리에 관한 업무를 총괄해서 책임지고, 개인정보 처리와 관련한 정보주체의 불만처리 및 피해구제 등을 위하여 아래와 같이 개인정보 보호책임자를 지정하고 있습니다.

▶ 개인정보 보호책임자
성명 :유태형
직책 :개발
연락처 :010-2018-5509, 2354taeng@gmail.com,

② 정보주체께서는 광운대뭐먹 의 서비스(또는 사업)을 이용하시면서 발생한 모든 개인정보 보호 관련 문의, 불만처리, 피해구제 등에 관한 사항을 개인정보 보호책임자 및 담당부서로 문의하실 수 있습니다. 광운대뭐먹 은(는) 정보주체의 문의에 대해 지체 없이 답변 및 처리해드릴 것입니다.



9. 개인정보 처리방침 변경

①이 개인정보처리방침은 시행일로부터 적용되며, 법령 및 방침에 따른 변경내용의 추가, 삭제 및 정정이 있는 경우에는 변경사항의 시행 7일 전부터 공지사항을 통하여 고지할 것입니다.



10. 개인정보의 안전성 확보 조치 ('광운대뭐먹')은(는) 개인정보보호법 제29조에 따라 다음과 같이 안전성 확보에 필요한 기술적/관리적 및 물리적 조치를 하고 있습니다.

1. 개인정보의 암호화
이용자의 비밀번호는 암호화 되어 저장 및 관리되고 있어, 본인만이 알 수 있으며 중요한 데이터는 파일 및 전송 데이터를 암호화 하거나 파일 잠금 기능을 사용하는 등의 별도 보안기능을 사용하고 있습니다.

2. 개인정보에 대한 접근 제한
개인정보를 처리하는 데이터베이스시스템에 대한 접근권한의 부여,변경,말소를 통하여 개인정보에 대한 접근통제를 위하여 필요한 조치를 하고 있으며 침입차단시스템을 이용하여 외부로부터의 무단 접근을 통제하고 있습니다.
"""
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
    
    func showAlert(message: String) {
        DispatchQueue.main.async {
            let alertMessage = UIAlertController(title: "", message: message, preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "확인", style: .cancel) { (temp: UIAlertAction) in
                if message == "가입 완료" {
                    self.presentingViewController?.dismiss(animated: true)
                }
            }
            
            alertMessage.addAction(cancelAction)
            self.present(alertMessage, animated: true, completion: nil)
        }
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

extension JSON {
    public init(_ jsonArray:[JSON]) {
        self.init(jsonArray.map { $0.object })
    }
}
