//
//  AppFullScreenCell.swift
//  AppStore
//
//  Created by t19960804 on 10/20/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppFullScreenCell: UITableViewCell {
    let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "TestTestTestTestTestTestTestTestTestTestTestTestTest"
        let mutableString = NSMutableAttributedString(string: "Great Games", attributes: [.foregroundColor : UIColor.black])
        mutableString.append(NSAttributedString(string: " are all about the details, from subtle visual effects to imaginative art styles. In these titles, you're sure to find something to marvel at, whether you're into fantasy worlds or neon-soaked dartboards.", attributes: [.foregroundColor : UIColor.gray]))
        mutableString.append(NSAttributedString(string: "\n\n\nHeroic adventure", attributes: [.foregroundColor : UIColor.black]))
        mutableString.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor : UIColor.gray]))
        mutableString.append(NSAttributedString(string: "\n\n\nHeroic adventure", attributes: [.foregroundColor : UIColor.black]))
        mutableString.append(NSAttributedString(string: "\nBattle in dungeons. Collect treasure. Solve puzzles. Sail to new lands. Oceanhorn lets you do it all in a beautifully detailed world.", attributes: [.foregroundColor : UIColor.gray]))
        lb.attributedText = mutableString
        lb.numberOfLines = 0
        lb.font = .systemFont(ofSize: 20)
        return lb
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(descriptionLabel)
        descriptionLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        descriptionLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        descriptionLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -20).isActive = true
        descriptionLabel.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
