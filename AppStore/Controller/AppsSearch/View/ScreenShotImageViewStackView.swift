//
//  ScreenShotImageViewStackView.swift
//  AppStore
//
//  Created by t19960804 on 8/3/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class ScreenShotImageStackView: UIStackView {
    
    lazy var screenShotImageView1 = self.createScreenShotImageView()
    lazy var screenShotImageView2 = self.createScreenShotImageView()
    lazy var screenShotImageView3 = self.createScreenShotImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addArrangedSubViews(screenShotImageView1,screenShotImageView2,screenShotImageView3)
        self.axis = .horizontal
        self.distribution = .fillEqually
        self.spacing = 12
    }
    fileprivate func createScreenShotImageView() -> UIImageView{
        let imageView: UIImageView = {
            let iv = UIImageView()
            iv.contentMode = .scaleAspectFill
            iv.clipsToBounds = true
            iv.layer.cornerRadius = 8
            iv.layer.borderWidth = 0.5
            iv.layer.borderColor = UIColor(white: 0.5, alpha: 0.5).cgColor
            return iv
        }()
        return imageView
    }
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
