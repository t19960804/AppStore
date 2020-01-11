//
//  TrackCell.swift
//  AppStore
//
//  Created by t19960804 on 1/5/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class TrackCell: UICollectionViewCell {
    static let cellID = "Cell"
    var music: Result! {
        didSet {
            trackImageView.sd_setImage(with: URL(string: music.artworkUrl100))
            trackNameLabel.text = music.trackName
            trackSubtitleLabel.text = "\(music.artistName ?? "Unknow")•\(music.collectionName ?? "Unknow")"
        }
    }
    let trackImageView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "gemAlbum"))
        iv.layer.cornerRadius = 12
        iv.clipsToBounds = true
        return iv
    }()
    let trackNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 18)
        lb.text = "倒數"
        return lb
    }()
    let trackSubtitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16)
        lb.text = "歌壇天后鄧紫棋"
        lb.numberOfLines = 2
        return lb
    }()
    lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [trackNameLabel,trackSubtitleLabel])
        sv.axis = .vertical
        sv.spacing = 8
        return sv
    }()
    lazy var hStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [trackImageView,vStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .horizontal
        sv.spacing = 16
        sv.alignment = .center
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(hStackView)
        trackImageView.widthAnchor.constraint(equalToConstant: 90).isActive = true
        trackImageView.heightAnchor.constraint(equalToConstant: 90).isActive = true
        hStackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 16).isActive = true
        hStackView.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        hStackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -16).isActive = true
        hStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
