//
//  AppsReviewCell.swift
//  AppStore
//
//  Created by t19960804 on 9/29/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsReviewCell: UICollectionViewCell {
    static let cellID = "AppsReviewCell"
    let reviewController = AppsReviewController()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(reviewController.view)
        reviewController.view.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
