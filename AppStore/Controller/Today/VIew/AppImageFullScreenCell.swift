//
//  FullScreenCell.swift
//  AppStore
//
//  Created by t19960804 on 10/27/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit


class AppImageFullScreenCell: UITableViewCell {
    let todayCell = TodayCell()
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "close_button"), for: .normal)
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        addSubview(todayCell)
        addSubview(closeButton)
        
        todayCell.translatesAutoresizingMaskIntoConstraints = false
        todayCell.fillSuperView()

        closeButton.topAnchor.constraint(equalTo: topAnchor, constant: 48).isActive = true
        closeButton.rightAnchor.constraint(equalTo: rightAnchor, constant: 12).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
