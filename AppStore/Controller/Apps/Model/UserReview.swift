//
//  UserReview.swift
//  AppStore
//
//  Created by t19960804 on 9/30/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

//最外層的object也要包進去
//遇到Dictionary就創Model
//常數名稱一定要對照JSON上的,但常數的類別名稱則不用
struct UserReviews: Decodable {
    let feed: ReviewFeed
}
struct ReviewFeed: Decodable {
    let entry: [ReviewEntry]
}
struct ReviewEntry: Decodable {
    let author: Author
    let title: Label
    let content: Label
    
    //因為JSON上Key的包含特別字元,Swift無法識別,所以將Key做改名
    //規則1: enum名稱要叫"CodingKeys"
    //規則2: 服從String(因為raw value為須為String) / CodingKey 協議
    //規則3: 需寫入每個strucy內的屬性,若需要改名的再將JSON上的Key填入該case的raw value
    let rate: Label
    enum CodingKeys: String, CodingKey {
        case author, title, content
        case rate = "im:rating"
    }
}
struct Author: Decodable {
    let name: Label
}
struct Label: Decodable {
    let label: String
}


