//
//  NoticeDetailController.swift
//  SettingUI
//
//  Created by Peter Jang on 13/02/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit

class NoticeDetailController: UIViewController {
    var id: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        navigationItem.title = "공지사항"
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if Global.shared.isErrorLableShowing { Global.removeErrorLable() }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchLists()
    }
    
    func setupViews() {
        view.addSubview(titleLable)
        view.addSubview(contentLable)
        
        titleLable.anchor(top: view.safeAreaLayoutGuide.topAnchor,
                          leading: view.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 20, left: 20, bottom: 0, right: 0))
        contentLable.anchor(top: titleLable.bottomAnchor,
                            leading: titleLable.leadingAnchor,
                            bottom: nil,
                            trailing: nil,
                            padding: .init(top: 50, left: 0, bottom: 0, right: 0))
    }
    
    func fetchLists() {
        let dicToSend = ["func":"notice content", "id":id!]
        let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
        
        ApiService.shared.getData(dataToSend: dataToSend){ (content: NoticeContent) in
            
            self.titleLable.text = content.title
            self.contentLable.text = content.content
            
        }
    }
    
    let titleLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 21)
        lable.textColor = UIColor.black
        return lable
    }()
    
    let contentLable: UILabel = {
        let lable = UILabel()
        lable.textColor = lightblack
        return lable
    }()
    
}
