//
//  SearchResultCell.swift
//  AppStore
//
//  Created by t19960804 on 7/28/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit
import SDWebImage

class SearchResultCell: UICollectionViewCell {

    var result: Result? {
        didSet {
            let iconImageURL = URL(string: result!.artworkUrl100)
            infoStackView.appIconImageView.sd_setImage(with: iconImageURL)
            infoStackView.appNameLabel.text = result!.trackName
            infoStackView.appCategoryLabel.text = result!.primaryGenreName
            infoStackView.appRatingLabel.text = "Rating: \(result!.averageUserRating ?? 0)"
            //有些App沒有足夠的截圖
            if result!.screenshotUrls.count > 0 {
                let imageURL1 = URL(string: result!.screenshotUrls[0])
                screenShotImageStackView.screenShotImageView1.sd_setImage(with: imageURL1)
            }
            if result!.screenshotUrls.count > 1 {
                let imageURL2 = URL(string: result!.screenshotUrls[1])
                screenShotImageStackView.screenShotImageView2.sd_setImage(with: imageURL2)
            }
            if result!.screenshotUrls.count > 2 {
                let imageURL3 = URL(string: result!.screenshotUrls[2])
                screenShotImageStackView.screenShotImageView3.sd_setImage(with: imageURL3)
            }

        }
    }
    //預設情況下,任何在StackView裡面的物件使用contraints時都不用設定.translatesAutoresizingMaskIntoConstraints
    let infoStackView = InfoStackView()
    let screenShotImageStackView = ScreenShotImageStackView()
    
    lazy var overAllStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [infoStackView,screenShotImageStackView])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 20
        return sv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        self.addSubViews(overAllStackView)
        overAllStackView.fillSuperView(padding: UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16))
    }
    
    //當 controller 是從 storyboard 生成時，它將呼叫 init(coder:)
    //但就算是純code,還是得呼叫init?(coder) , 因為是 "required"
    //希望子類別中一定要實現的init()，可以添加required關鍵字進行限制，強制子類別實現這個方法。
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
