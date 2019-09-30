//
//  UserReviewCell.swift
//  AppStore
//
//  Created by t19960804 on 9/29/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class UserReviewCell: UICollectionViewCell {
    static let cellID = "UserReviewCell"
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 18)
        lb.backgroundColor = .green
        return lb
    }()
    let authorLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16)
        lb.backgroundColor = .red
        //文字置右
        lb.textAlignment = .right
        return lb
    }()
    let starsLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Stars"
        lb.font = .systemFont(ofSize: 14)
        lb.backgroundColor = .blue
        return lb
    }()
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16)
        lb.numberOfLines = 0
        lb.backgroundColor = .orange
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    lazy var horizontalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [titleLabel,authorLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 8
        return sv
    }()
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [horizontalStackView,starsLabel,contentLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 12
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(white: 0.95, alpha: 1)
        layer.cornerRadius = 12
        clipsToBounds = true
        setUpConstraints()
    }
    
    fileprivate func setUpConstraints(){
        addSubview(verticalStackView)
        verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        verticalStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        verticalStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        starsLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        //Compression resistance priority用在label的content size(IntrinsicContentSize) > available size
        //兩個label相連時,一個label的內容很長,另一個很短,那兩個label當中勢必要有一個被truncating
        //CompressionResistancePriority決定了哪個要被truncating,值越大代表越不會被truncating
        titleLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        authorLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


