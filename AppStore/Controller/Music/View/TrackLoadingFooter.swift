//
//  TrackLoadingFooter.swift
//  AppStore
//
//  Created by t19960804 on 1/5/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class TrackLoadingFooter: UICollectionReusableView {
    static let footerID = "footer"
    let loadingIndicator: UIActivityIndicatorView = {
        let iv = UIActivityIndicatorView(style: .large)
        iv.color = .darkGray
        iv.startAnimating()
        return iv
    }()
    let loadingLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Loading More...."
        lb.font = .systemFont(ofSize: 18)
        lb.textAlignment = .center
        return lb
    }()
    lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [loadingIndicator,loadingLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(vStackView)
        loadingLabel.widthAnchor.constraint(equalToConstant: 200).isActive = true

        vStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        vStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
