//
//  AppsCell.swift
//  AppStore
//
//  Created by t19960804 on 8/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsPageCell: UICollectionViewCell {
    static let id = "Cell"
    let titleLabel = UILabel(font: .boldSystemFont(ofSize: 30), textColor: .black)
    
    let appsCategoryController = AppsCategoryController()

    override init(frame: CGRect) {
        super.init(frame: frame)
        titleLabel.text = "Header"
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        addSubview(titleLabel)
        addSubview(appsCategoryController.view)
        
        titleLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        
        appsCategoryController.view.topAnchor.constraint(equalTo: titleLabel.bottomAnchor).isActive = true
        appsCategoryController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        appsCategoryController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        appsCategoryController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
