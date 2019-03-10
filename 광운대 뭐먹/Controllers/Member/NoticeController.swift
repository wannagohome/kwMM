//
//  NoticeController.swift
//  SettingUI
//
//  Created by Peter Jang on 16/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class NoticeController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
//    var titles: NoticeTitles?
    var titleJson: JSON?
    
    override func viewDidLoad() {
        let backBTN = UIBarButtonItem(image: UIImage(named: "Back"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        navigationItem.leftBarButtonItem = backBTN
        navigationItem.title = "공지사항"
        navigationController?.navigationBar.tintColor = .white
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.register(NoticeCell.self, forCellWithReuseIdentifier: cellId)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = themeColor
        navigationController?.navigationBar.barStyle = .black
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    override func viewDidAppear(_ animated: Bool) {
        fetchLists()
    }
    
    func fetchLists() {
        let dicToSend = ["func":"notice"]
//        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
//
//        ApiService.shared.getData(dataToSend: dataToSend){ (titles: NoticeTitles) in
//
//            self.titles = titles
//            self.collectionView.reloadData()
//
//        }
        
        ApiService.shared.loadingStart()
        AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
            (responds) in
            switch responds.result {
                
            case .success(let value):
                self.titleJson = JSON(value)
                self.collectionView.reloadData()
                ApiService.shared.loadingStop()
                
                
            case .failure(let error):
                print(error.localizedDescription)
                ApiService.shared.loadingStop()
                self.showAlert(message: "네트워크 오류")
                
            }
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return titles?.titles?.count ?? 0
        return titleJson?["titles"].count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! NoticeCell
        cell.backgroundColor = UIColor.white
        
//        cell.noticeTitles = titles?.titles?[indexPath.row]
        cell.titleLable.text = titleJson?["titles"][indexPath.row]["title"].string
        cell.layer.borderWidth = 0.3
        cell.layer.borderColor = UIColor.gray.cgColor
        cell.backgroundColor = .white
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let noticeDetailController = NoticeDetailController()
//        noticeDetailController.id = titles?.titles?[indexPath.row].id
        noticeDetailController.id = titleJson?["titles"][indexPath.row]["id"].string
        self.navigationController?.pushViewController(noticeDetailController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return .init(width: collectionView.bounds.width, height: 60)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
class NoticeCell: BaseCell {
    
    var noticeTitles: NoticeTitle? {
        didSet {
            titleLable.text = noticeTitles?.title
        }
    }
    
    override func setupViews() {
        addSubview(titleLable)
        addSubview(arrowIconImageView)
        
        titleLable.anchor(top: nil,
                          leading: contentView.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                          size: .init(width: 200, height: 30))
        titleLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        arrowIconImageView.anchor(top: nil,
                                  leading: nil,
                                  bottom: nil,
                                  trailing: contentView.trailingAnchor,
                                  padding: .init(top: 0, left: 0, bottom: 0, right: 15))
        arrowIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    let titleLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 15)
        lable.textColor = lightblack
        return lable
    }()
    
    let dateLable: UILabel = {
        let lable = UILabel()
        return lable
    }()
    
    let arrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "right")
        return imageView
    }()
    
}
