//
//  MultipleAppCell.swift
//  AppStore
//
//  Created by t19960804 on 11/9/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class MultipleAppCell: BaseTodayCell {
    override var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            backgroundColor = todayItem.backgroundColor
        }
    }
    let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 32)
        lb.numberOfLines = 2
        return lb
    }()
    let multipleAppsController = MultipleAppsController()
    lazy var verticalStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [categoryLabel,
                                               titleLabel,
                                               multipleAppsController.view])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .blue
        layer.cornerRadius = 16
        clipsToBounds = true
        addSubview(verticalStackView)
        verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 24).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 24).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -24).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -24).isActive = true

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
