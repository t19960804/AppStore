//
//  BaseTodayCell.swift
//  AppStore
//
//  Created by t19960804 on 11/9/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class BaseTodayCell: UICollectionViewCell {
    var todayItem: TodayItem!
    //按下cell不放開時為true
    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.transform = self.isHighlighted ? CGAffineTransform(scaleX: 0.9, y: 0.9) : .identity
            })
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        //cell加上陰影會使得滾動時不那麼流暢
//        layer.cornerRadius = 16
//
//        backgroundView = UIView()
//        backgroundView?.backgroundColor = .white
//        backgroundView?.translatesAutoresizingMaskIntoConstraints = false
//        backgroundView?.layer.cornerRadius = 16
//        backgroundView?.layer.shadowOpacity = 0.1
//        backgroundView?.layer.shadowOffset = CGSize(width: 0, height: 5)
//        backgroundView?.layer.shadowRadius = 8
//        backgroundView?.layer.shouldRasterize = true
//
//
//        addSubview(self.backgroundView!)
//        backgroundView?.fillSuperView()
        
        layer.cornerRadius = 16
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 5)
        layer.shadowRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
