//
//  AppsFeed.swift
//  AppStore
//
//  Created by t19960804 on 9/1/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

//最外層的object也要包進去
//遇到Dictionary就創Model
struct AppsFeed: Decodable {
    let feed: Feed
}
struct Feed: Decodable {
    let title: String
    let results: [FeedResult]
}
struct FeedResult: Decodable {
    let artworkUrl100: String
    let artistName: String
    let name: String
}
