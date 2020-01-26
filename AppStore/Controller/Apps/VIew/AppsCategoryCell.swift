//
//  AppsRowCell.swift
//  AppStore
//
//  Created by t19960804 on 8/18/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import SDWebImage

class AppsCategoryCell: UICollectionViewCell {
    static let id = "Cell"
    var feedResult: FeedResult! {
        didSet {
            appImageView.sd_setImage(with: URL(string: feedResult.artworkUrl100))
            nameLabel.text = feedResult.name
            companyNameLabel.text = feedResult.artistName
        }
    }
    
    let appImageView: UIImageView = {
        let iv = UIImageView()
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        return iv
    }()
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        lb.text = "App Name"
        return lb
    }()
    let companyNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 13)
        lb.textColor = .lightGray
        lb.text = "Facebook"
        return lb
    }()
    let getButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.backgroundColor = .brown
        btn.setTitle("GET", for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.layer.cornerRadius = 10
        return btn
    }()
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [nameLabel,companyNameLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    lazy var wholeStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [appImageView,verticalStackView,getButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 16
        //預設為.fill,此時arrangedSubviews會被resize,並填滿空間(垂直於軸)
        //.fill以外的alignment,原件不會被resize(例如label的size會回到intrinsicContentSize)
        sv.alignment = .center
        return sv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(wholeStackView)
        wholeStackView.fillSuperView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
