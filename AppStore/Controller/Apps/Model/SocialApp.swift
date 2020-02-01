//
//  SocialApp.swift
//  AppStore
//
//  Created by t19960804 on 9/7/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

//一開始就是陣列
struct SocialApp: Decodable, Hashable {
    let id, name, imageUrl, tagline: String
}
