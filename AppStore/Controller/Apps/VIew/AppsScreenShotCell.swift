//
//  AppsScreenShotCell.swift
//  AppStore
//
//  Created by t19960804 on 9/28/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsScreenShotCell: UICollectionViewCell {
    static let cellID = "AppsScreenShotCell"
    
    let screenShotImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(screenShotImageView)
        screenShotImageView.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
