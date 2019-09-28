//
//  AppsPreviewCell.swift
//  AppStore
//
//  Created by t19960804 on 9/28/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsPreviewCell: UICollectionViewCell {
    static let cellID = "AppsPreviewCell"
    let previewLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Preview"
        lb.font = .boldSystemFont(ofSize: 20)
        return lb
    }()
    let screenShotController = AppsScreenShotController()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(previewLabel)
        addSubview(screenShotController.view)
        previewLabel.topAnchor.constraint(equalTo: topAnchor, constant: 0).isActive = true
        previewLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        screenShotController.view.topAnchor.constraint(equalTo: previewLabel.bottomAnchor, constant: 16).isActive = true
        screenShotController.view.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        screenShotController.view.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        screenShotController.view.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
 
//        screenShotController.view.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
