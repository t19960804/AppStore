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
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        addSubview(todayCell)
        todayCell.translatesAutoresizingMaskIntoConstraints = false
        todayCell.fillSuperView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
