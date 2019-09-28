//
//  AppDetailCell.swift
//  AppStore
//
//  Created by t19960804 on 9/21/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppDetailCell: UICollectionViewCell {
    static let cellID = "Cell"
    var app: Result? {
        didSet {
            appImageView.sd_setImage(with: URL(string: app?.artworkUrl100 ?? ""))
            appNameLabel.text = app?.trackName
            getAppButton.setTitle(app?.formattedPrice, for: .normal)
            releaseNotesLabel.text = app?.releaseNotes
        }
    }
    let appImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 18
        iv.clipsToBounds = true
        return iv
    }()
    let appNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Fortnite"
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.numberOfLines = 2
        return lb
    }()
    let deviceMatchLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Works with: iPhone SE,6S,7,8,X,XS,XR,iPad Mini4"
        lb.numberOfLines = 2
        return lb
    }()
    let getAppButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("$4.99", for: .normal)
        btn.backgroundColor = UIColor.setRGB(r: 25, g: 102, b: 255)
        btn.layer.cornerRadius = 16
        btn.clipsToBounds = true
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        return btn
    }()
    let whatsNewLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "What's New"
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        return lb
    }()
    let releaseNotesLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Release Notes"
        lb.font = UIFont.systemFont(ofSize: 18)
        lb.numberOfLines = 0
        return lb
    }()
    
    lazy var verticalStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [appNameLabel,deviceMatchLabel,getAppButton])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.alignment = .leading
        sv.spacing = 12
        return sv
    }()
    lazy var horizontalStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [appImageView,verticalStack])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 20
        return sv
    }()
    lazy var topStack: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [horizontalStack,whatsNewLabel,releaseNotesLabel])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 16
        return sv
    }()
    let seperateLine: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor(white: 0.9, alpha: 1)
        return v
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        addSubview(topStack)
        addSubview(seperateLine)
        
        topStack.topAnchor.constraint(equalTo: topAnchor, constant: 20).isActive = true
        topStack.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        topStack.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        topStack.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        appImageView.widthAnchor.constraint(equalToConstant: 140).isActive = true
        appImageView.heightAnchor.constraint(equalToConstant: 140).isActive = true
        
        getAppButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        getAppButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        seperateLine.leftAnchor.constraint(equalTo: topStack.leftAnchor).isActive = true
        seperateLine.rightAnchor.constraint(equalTo: topStack.rightAnchor).isActive = true
        seperateLine.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        seperateLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
