//
//  MenuListCell.swift
//  SettingUI
//
//  Created by Peter Jang on 24/01/2019.
//  Copyright © 2019 Peter Jang. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

protocol MenuListCellDelegate: class {
    func moveToReviewController(_ menuName: String, _ menuId: Int)
}

class MenuListCell: BaseCell, UITableViewDelegate, UITableViewDataSource, TableViewHeaderDelegate {
   
    var menusSet: MenuList? {
        didSet {
            menus = menusSet
            if menusSet != nil {
                var count: Int = menusSet!.restaurants?.count ?? 1
                if count == 0 { count=1 }
                for _ in 1...count {
                    self.isOpen.append(false)
                }
            }
            tableView.reloadData()
        }
    }
    var jsonSet: JSON? {
        didSet {
            json = jsonSet
            if jsonSet != nil {
                var count: Int = jsonSet?["restaurants"].count ?? 1
                if count == 0 { count=1 }
                for _ in 1...count {
                    self.isOpen.append(false)
                }
            }
            tableView.reloadData()
        }
    }
    var menus: MenuList?
    var dinnerName: String?
    var isOpen: [Bool] = []
    var didLoad: Bool = false
    weak var delegate: MenuListCellDelegate?
    weak var dinnerController: DinnerController?
    var json: JSON?
    
    lazy var tableView: UITableView = {
        let tb = UITableView(frame: .zero, style: .grouped)
        tb.backgroundColor = UIColor.white
        tb.dataSource = self
        tb.delegate = self
        tb.separatorColor = UIColor.clear
        return tb
    }()
    
    override func setupViews() {
        
        tableView.estimatedRowHeight = 60.0
        
        tableView.rowHeight = UITableView.automaticDimension
        
        addSubview(tableView)
        tableView.anchor(top: contentView.topAnchor,
                         leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor)
    }
    
    func fetchLists() {
        if dinnerName != nil && !didLoad {
            
            let dicToSend = ["func":"메뉴 아이폰", "restaurantName":dinnerName!]
//            let dataToSend = try! JSONSerialization.data(withJSONObject: dicToSend, options: [])
            
            //FIXME: change view if needed
//            ApiService.shared.getData(dataToSend: dataToSend){ (menus: MenuList) in
//
//                self.menus = menus
//                let count = menus.restaurants?.count ?? 0
//                for _ in 1...count {
//                    self.isOpen.append(true)
//                }
//                self.tableView.reloadData()
//
//            }
            ApiService.shared.loadingStart()
            AF.request("http://kwmm.kr:8080/kwMM/Main2", method: .post, parameters: dicToSend, encoding: JSONEncoding.default).responseJSON {
                (responds) in
                switch responds.result {
                    
                case .success(let value):
                    self.json = JSON(value)
                    let count = self.json?["restaurants"].count ?? 0
                    for _ in 1...count {
                        self.isOpen.append(false)
                    }
                    self.tableView.reloadData()
                    ApiService.shared.loadingStop()
                    self.didLoad = true
                    
                case .failure(let error):
                    print(error.localizedDescription)
                    ApiService.shared.loadingStop()
                    self.dinnerController?.showAlert(message: "네트워크 오류")
                    
                }
            }
            
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
//        return menus?.restaurants?.count ?? 0
        return json?["restaurants"].count ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isOpen[section] {
//            return menus?.restaurants?[section].restaurant?.count ?? 0
            return json?["restaurants"][section]["restaurant"].count ?? 0
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        weak var cell: MenuCell? = tableView.dequeueReusableCell(withIdentifier: "cell") as? MenuCell ??
            MenuCell(style: .default, reuseIdentifier: "cell")
        cell?.layer.borderColor = UIColor.init(white: 0.9, alpha: 1).cgColor
        
        cell?.layer.borderWidth = 0.25
//        cell.layer.addBorder([.bottom], color: UIColor.init(white: 0.9, alpha: 1), width: 0.27)
//        cell?.menuList = menus?.restaurants?[indexPath.section].restaurant![indexPath.item]
        cell?.json = json?["restaurants"][indexPath.section]["restaurant"][indexPath.item]
        cell?.backgroundColor = UIColor.white
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "header") as? MenuHeaderCell ?? MenuHeaderCell(reuseIdentifier: "header")
        
//        header.categoryLable.text = menus?.restaurants?[section].category
        header.categoryLable.text = json?["restaurants"][section]["category"].string
        header.arrowLabel.text = ">"
        header.setCollapsed(isOpen[section])
        
        header.section = section
        header.delegate = self
        
        return header
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer: UIView = UIView()
        footer.backgroundColor = UIColor(white: 0.9, alpha: 1)

        return footer
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegateAction(indexPath)
    }
    
    func toggleSection(_ header: MenuHeaderCell, section: Int) {
        
        isOpen[section] = !isOpen[section]
        header.setCollapsed(isOpen[section])
        
        tableView.reloadSections(NSIndexSet(index: section) as IndexSet, with: .automatic)
    }
    
    func delegateAction(_ indexPath: IndexPath) {
        if let del = self.delegate {
//            del.moveToReviewController((menus?.restaurants?[indexPath.section].restaurant?[indexPath.item].menu)!, (menus?.restaurants?[indexPath.section].restaurant?[indexPath.item].menuId)!)
            del.moveToReviewController((json?["restaurants"][indexPath.section]["restaurant"][indexPath.item]["menu"].string)!, (json?["restaurants"][indexPath.section]["restaurant"][indexPath.item]["menuId"].int)!)
        }
    }
}


protocol TableViewHeaderDelegate: class {
    func toggleSection(_ header: MenuHeaderCell, section: Int)
}

class MenuHeaderCell: UITableViewHeaderFooterView {
    
    weak var delegate: TableViewHeaderDelegate?
    var section: Int = 0
    
    let categoryLable: UILabel = {
        let lable = UILabel()
        lable.font = UIFont.boldSystemFont(ofSize: 17)
        return lable
    }()
    let arrowLabel = UILabel()
    
    let arrowIconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "arrow down")
        return imageView
    }()
    
    let spaceView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0.90, alpha: 1)
        return view
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        contentView.backgroundColor = UIColor.white
        contentView.addSubview(arrowIconImageView)
        contentView.addSubview(categoryLable)
        contentView.addSubview(spaceView)

        arrowIconImageView.anchor(top: nil,
                          leading: nil,
                          bottom: nil,
                          trailing: contentView.trailingAnchor,
                          padding: .init(top: 0, left: 0, bottom: 0, right: 20),
                          size: .init(width: 10, height: 10))
        arrowIconImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        categoryLable.anchor(top: nil,
                          leading: contentView.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 0, left: 10, bottom: 0, right: 0))
        categoryLable.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        spaceView.anchor(top: nil,
                         leading: contentView.leadingAnchor,
                         bottom: contentView.bottomAnchor,
                         trailing: contentView.trailingAnchor,
                         size: .init(width: 0, height: 3))
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MenuHeaderCell.tapHeader(_:))))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //
    // Trigger toggle section when tapping on the header
    //
    @objc func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? MenuHeaderCell else {
            return
        }
        
        delegate?.toggleSection(self, section: cell.section)
    }
    
    func setCollapsed(_ collapsed: Bool) {
        arrowIconImageView.rotate(collapsed ? .pi : 0.0)
    }
    
}



class MenuCell: UITableViewCell {
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
       
        
        setupViews()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var menuList: MenuInfo? {
        didSet {
            menuNameLabel.text = menuList?.menu
            priceLable.text = String(describing: (menuList?.price)!)
            rateLabel.text = String(format: "%.1f", (menuList?.rate)!)

        }
    }
    var json: JSON? {
        didSet {
            menuNameLabel.text = json?["menu"].string
            priceLable.text = String(describing: (json?["price"].int)!)
            rateLabel.text = String(format: "%.1f", (json?["rate"].double)!)
        }
    }
    
    
    
    func setupViews() {
        addSubview(menuNameLabel)
        addSubview(rateLabel)
        addSubview(priceLable)
        addSubview(star)
        
        menuNameLabel.anchor(top: contentView.topAnchor,
                             leading: contentView.leadingAnchor,
                             bottom: nil,
                             trailing: nil,
                             padding: .init(top: 10, left: 20, bottom: 0, right: 0),
                             size: .init(width: 100, height: 20))
        star.anchor(top: menuNameLabel.topAnchor,
                    leading: menuNameLabel.trailingAnchor,
                    bottom: nil,
                    trailing: nil,
                    padding: .init(top: 5, left: 0, bottom: 0, right: 0))
        priceLable.anchor(top: menuNameLabel.bottomAnchor,
                          leading: contentView.leadingAnchor,
                          bottom: nil,
                          trailing: nil,
                          padding: .init(top: 0, left: 20, bottom: 0, right: 0),
                          size: .init(width: 100, height: 20))
        rateLabel.anchor(top: menuNameLabel.topAnchor,
                         leading: star.trailingAnchor,
                         bottom: nil,
                         trailing: nil,
                         padding: .init(top: 2, left: 5, bottom: 0, right: 0),
                         size: .init(width: 70, height: 20))
    }
    
    let star: CosmosView = {
        let ratingView = CosmosView()
        ratingView.rating = 1
        ratingView.minTouchRating = 1
        ratingView.settings.totalStars = 1
        ratingView.starSize = 14
        return ratingView
    }()
    
    let  menuNameLabel: UILabel = {
        let label = UILabel()
        label.text = "menuName"
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    let rateLabel: UILabel = {
        let label = UILabel()
        label.text = "rate"
        label.font = UIFont.systemFont(ofSize: 10)
        return label
    }()
    
    let priceLable: UILabel = {
        let label = UILabel()
        label.text = "price"
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
}
