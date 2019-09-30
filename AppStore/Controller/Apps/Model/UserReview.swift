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
}
struct Author: Decodable {
    let name: Label
}
struct Label: Decodable {
    let label: String
}


