//
//  InfoStackView.swift
//  AppStore
//
//  Created by t19960804 on 8/3/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class InfoStackView: UIStackView {
    //StackView會根據元件當中最高/寬的元件(imageView)來決定自身高/寬度
    //此例中因為appImageView高度被訂為64,StackView的高度就固定64,除非其他元件高度更高
    let appIconImageView: UIImageView = {
        let iv = UIImageView()
        iv.widthAnchor.constraint(equalToConstant: 64).isActive = true
        iv.heightAnchor.constraint(equalToConstant: 64).isActive = true
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    let appNameLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    let appCategoryLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    let appRatingLabel: UILabel = {
        let lb = UILabel()
        return lb
    }()
    let getTheAppButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("GET", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.widthAnchor.constraint(equalToConstant: 80).isActive = true
        btn.backgroundColor = UIColor(white: 0.95, alpha: 1)
        btn.layer.cornerRadius = 10
        return btn
    }()
    lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [appNameLabel, appCategoryLabel, appRatingLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addArrangedSubViews(appIconImageView, vStackView, getTheAppButton)
        self.translatesAutoresizingMaskIntoConstraints = false
        self.axis = .horizontal
        self.spacing = 12
        //所有元件會縮小成intrinsicContentSize,並根據axis來置中
        self.alignment = .center
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
