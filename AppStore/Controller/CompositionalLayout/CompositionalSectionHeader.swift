//
//  CompositionalSectionHeader.swift
//  AppStore
//
//  Created by t19960804 on 1/24/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class CompositionalSectionHeader: UICollectionReusableView {
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Editors' Choice Games"
        lb.font = .boldSystemFont(ofSize: 30)
        return lb
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.fillSuperView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
