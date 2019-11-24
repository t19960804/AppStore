//
//  MultipleAppsHeader.swift
//  AppStore
//
//  Created by t19960804 on 11/24/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class MultipleAppsHeader: UICollectionReusableView {
    static let headerID = "headerID"

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
    lazy var verticalStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [categoryLabel, titleLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading//決定subViews的位置
        //Views are resized proportionally based on their intrinsic content size
        sv.distribution = .fillProportionally//決定各個subView佔據stackView多少範圍
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstriants()
    }
    fileprivate func setUpConstriants(){
        addSubview(verticalStackView)
        verticalStackView.fillSuperView()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
