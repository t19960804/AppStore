//
//  SearchResult.swift
//  AppStore
//
//  Created by t19960804 on 8/4/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

struct SearchResult: Decodable {
    let resultCount: Int
    let results: [Result]
}

struct Result: Decodable {
    let trackName: String
    let primaryGenreName: String
    //有可能無值,故為Optional
    var averageUserRating: Float?
    var screenshotUrls: [String]?
    //icon
    let artworkUrl100: String
    let formattedPrice: String?
    var description: String?
    var releaseNotes: String?
    let trackId: Int
    var artistName: String?
    var collectionName: String?
}


