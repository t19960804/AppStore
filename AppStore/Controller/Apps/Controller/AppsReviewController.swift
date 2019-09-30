//
//  AppsReviewController.swift
//  AppStore
//
//  Created by t19960804 on 9/29/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsReviewController: HorizontalSnappingController {
    
    var reviews: UserReviews? {
        didSet {
            collectionView.reloadData()
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(UserReviewCell.self, forCellWithReuseIdentifier: UserReviewCell.cellID)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return reviews?.feed.entry.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserReviewCell.cellID, for: indexPath) as! UserReviewCell
        if let review = reviews?.feed.entry[indexPath.item] {
            cell.authorLabel.text = review.author.name.label
            cell.titleLabel.text = review.title.label
            cell.contentLabel.text = review.content.label
        }
        return cell
    }
    
}
extension AppsReviewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 48, height: view.frame.height)
    }
}
