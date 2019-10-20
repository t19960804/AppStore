//
//  TodayCell.swift
//  AppStore
//
//  Created by t19960804 on 10/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    static let cellID = "Cell"
    let appImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "garden")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        addSubview(appImageView)
        appImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        appImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        appImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        appImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
