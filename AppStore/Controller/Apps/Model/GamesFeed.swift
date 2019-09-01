//
//  GamesFeed.swift
//  AppStore
//
//  Created by t19960804 on 8/25/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

//要從最外層的"object"開始定義結構
//struct的名稱不需要一樣
//但裡面的屬性一定要一樣
//遇到object就新增model
struct AppsFeed: Decodable {
    let feed: Feed
}
struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}
struct FeedResult: Decodable {
    let name, artistName, artworkUrl100: String
}
