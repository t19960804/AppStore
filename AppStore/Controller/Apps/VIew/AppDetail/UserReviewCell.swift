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
    var review: ReviewEntry! {
        didSet {
            authorLabel.text = review.author.name.label
            titleLabel.text = review.title.label
            contentLabel.text = review.content.label
        }
    }
    let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }()
    let authorLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16)
        lb.textAlignment = .right
        return lb
    }()
    //StackView本身無法調整長寬Anchor,只能調整裡面的元件
    let starsStackView: UIStackView = {
        var starsArray = [UIView]()
        //Range可以遍歷，因為遵循了Sequence協定
        (0...4).forEach { _ in
            let imgView = UIImageView(image: UIImage(named: "star"))
            imgView.translatesAutoresizingMaskIntoConstraints = false
            imgView.heightAnchor.constraint(equalToConstant: 24).isActive = true
            imgView.widthAnchor.constraint(equalToConstant: 24).isActive = true
            starsArray.append(imgView)
        }
        starsArray.append(UIView())
        let sv = UIStackView(arrangedSubviews: starsArray)
        sv.axis = .horizontal
        return sv
    }()
    let contentLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 18)
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.numberOfLines = 5
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
        let sv = UIStackView(arrangedSubviews: [horizontalStackView,starsStackView,contentLabel])
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
        //如果用equal,會導致label的Intrinsic Content Size被迫增加,label的內容無法緊貼在星星之下
        verticalStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -20).isActive = true
        
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


