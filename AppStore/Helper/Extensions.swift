//
//  Extensions.swift
//  AppStore
//
//  Created by t19960804 on 8/18/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

extension UILabel {
    //可以當作它是次要的initializer ，可有可無都可以
    //convenience init必須呼叫同class的 designated init(只能橫向呼叫)
    convenience init(font: UIFont, textColor: UIColor = .black){
        self.init(frame: .zero)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = font
        self.textColor = textColor
    }
}
