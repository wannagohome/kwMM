//
//  Dinner.swift
//  SettingUI
//
//  Created by Peter Jang on 29/12/2018.
//  Copyright © 2018 Peter Jang. All rights reserved.
//

import UIKit


struct Dinner: Decodable {
    var data: String?
    var list: [List]?
    var categoryName: String?
}

struct List: Decodable {
    var rate: Double?
    var dinnerName: String?
    var numberOfRate : Int?
}

struct Login: Decodable {
    var data: String?
    var nickname: String?
    var profile: String?
}

struct MenuList: Decodable {
    var data: String?
    var restaurants: [MenuWithCategory]?
    
}

struct MenuWithCategory: Decodable {
    var category: String?
    var restaurant: [MenuInfo]?
}

struct MenuInfo: Decodable {
    var rate : Double?
    var price: Int?
    var menu: String?
    var menuId: Int?
}

struct Reviews: Decodable {
    var reviews: [Review]?
}

struct Review: Decodable {
    var nickname: String?
    var time: String?
    var rate: Double?
    var contents: String?
    var reviewPic: String?
    var profilePic: String?
    var reviewId: Int?
    var recommend: Int?
    var isRecommended: Int?
    var id: String?
    var menuId: Int?
    var menuName: String?
    var restaurantName: String?
}

struct Profile: Decodable {
    var image: String?
    var nickname: String?
}

struct SimpleResponse: Decodable {
    var data: String?
}

struct GoogleLoginResult: Decodable {
    var data: String?
    var nickname: String?
    var profile: String?
}

struct DinnerInfo: Decodable {
    var data: String?
    var info: Info?
}

struct Info: Decodable {
    var x: Double?
    var y: Double?
    var dinnerName: String?
}

struct NoticeTitles: Decodable {
    var titles: [NoticeTitle]?
}

struct NoticeTitle: Decodable {
    var title: String?
    var id: String?
}

struct NoticeContent: Decodable {
    var data: String?
    var title: String?
    var content: String?
}

struct Version: Decodable {
    var data: String?
    var version: Int?
}

struct FindID: Decodable {
    var data: String?
    var id: String?
}

struct TempPassword: Decodable {
    var data: String?
    var tempPassword: String?
}
