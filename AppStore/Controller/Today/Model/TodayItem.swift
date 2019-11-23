//
//  TodayItem.swift
//  AppStore
//
//  Created by t19960804 on 11/2/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

struct TodayItem {
    let category: String
    let title: String
    let appImage: UIImage
    let description: String
    let backgroundColor: UIColor
    let type: CellType
    let multipleAppsResults: [FeedResult]
}
//當raw value為String，那麼每一個case的"隱式"raw value則是那個case的名稱
enum CellType: String {
    case Single, Multiple
}
