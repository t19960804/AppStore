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
    var todayItem: TodayItem! {
        didSet {
            categoryLabel.text = todayItem.category
            titleLabel.text = todayItem.title
            appImageView.image = todayItem.appImage
            descriptionLabel.text = todayItem.description
            backgroundColor = todayItem.backgroundColor
        }
    }
    var topAnchorOfVerticalStackView: NSLayoutConstraint?
    
    let categoryLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.boldSystemFont(ofSize: 28)
        return lb
    }()
    let appImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    let containerView: UIView = {
        let iv = UIView()
        return iv
    }()
    let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 16)
        lb.numberOfLines = 3
        return lb
    }()
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [categoryLabel,
                                                titleLabel,
                                                containerView,
                                                descriptionLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        layer.cornerRadius = 16
        clipsToBounds = true
        backgroundColor = .white
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        containerView.addSubview(appImageView)
        addSubview(verticalStackView)
    
        appImageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor).isActive = true
        appImageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor).isActive = true
        appImageView.heightAnchor.constraint(equalToConstant: 240).isActive = true
        appImageView.widthAnchor.constraint(equalToConstant: 240).isActive = true
        
        topAnchorOfVerticalStackView = verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20)
        topAnchorOfVerticalStackView?.isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

