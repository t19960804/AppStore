//
//  AppsScreenShotController.swift
//  AppStore
//
//  Created by t19960804 on 9/28/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsScreenShotController: HorizontalSnappingController {
    var app: Result? {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(AppsScreenShotCell.self, forCellWithReuseIdentifier: AppsScreenShotCell.cellID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collectionView.backgroundColor = .white

    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return app?.screenshotUrls.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsScreenShotCell.cellID, for: indexPath) as! AppsScreenShotCell
        let urlString = app?.screenshotUrls[indexPath.item] ?? ""
        cell.screenShotImageView.sd_setImage(with: URL(string: urlString))
        return cell
    }
}
extension AppsScreenShotController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 250, height: view.frame.height)
    }
}
