//
//  AppsTopHeaderCell.swift
//  AppStore
//
//  Created by t19960804 on 8/24/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsPageHeaderCell: UICollectionViewCell {
    static let cellID = "Cell"
    
    let companyLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Facebook"
        lb.textColor = .blue
        lb.font = UIFont.boldSystemFont(ofSize: 12)
        return lb
    }()
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Keeping up with friends is faster than ever"
        lb.font = UIFont.systemFont(ofSize: 24)
        lb.numberOfLines = 2
        return lb
    }()
    lazy var appImageView: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .orange
        iv.layer.cornerRadius = 8
        iv.clipsToBounds = true
        iv.widthAnchor.constraint(equalToConstant: frame.width).isActive = true
        return iv
    }()
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [companyLabel,titleLabel,appImageView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 12
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(verticalStackView)
        verticalStackView.fillSuperView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
