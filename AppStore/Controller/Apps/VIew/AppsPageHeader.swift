//
//  AppsHeader.swift
//  AppStore
//
//  Created by t19960804 on 8/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsPageHeader: UICollectionReusableView {
    static let id = "Header"
    let appsTopMainController = AppsTopMainController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(appsTopMainController.view)
        appsTopMainController.view.fillSuperView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


