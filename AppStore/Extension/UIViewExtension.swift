//
//  UIViewExtension.swift
//  AppStore
//
//  Created by t19960804 on 7/28/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

extension UIView {
    func addSubViews(_ views: UIView...){
        views.forEach { self.addSubview($0) }
    }
    //當沒有參數傳入時可以有預設值
    func fillSuperView(padding: UIEdgeInsets = .zero){
        guard let superView = self.superview else { return }
        self.topAnchor.constraint(equalTo: superView.topAnchor, constant: padding.top).isActive = true
        self.leftAnchor.constraint(equalTo: superView.leftAnchor, constant: padding.left).isActive = true
        self.rightAnchor.constraint(equalTo: superView.rightAnchor, constant: -padding.right).isActive = true
        self.bottomAnchor.constraint(equalTo: superView.bottomAnchor, constant: -padding.bottom).isActive = true
    }
}
extension UIStackView {
    func addArrangedSubViews(_ views: UIView...){
        views.forEach { self.addArrangedSubview($0) }
    }
}
//GitTest
