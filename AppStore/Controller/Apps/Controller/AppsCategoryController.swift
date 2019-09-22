//
//  AppsHorizontalController.swift
//  AppStore
//
//  Created by t19960804 on 8/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsCategoryController: HorizontalSnappingController {
    let interItemSpacing: CGFloat = 6
    let padding: CGFloat = 12
    
    var feedResults: [FeedResult]?
    var itemSelectedHandler: ((FeedResult) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        collectionView!.register(AppsCategoryCell.self, forCellWithReuseIdentifier: AppsCategoryCell.id)
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return feedResults?.count ?? 0
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsCategoryCell.id, for: indexPath) as! AppsCategoryCell
        cell.feedResult = feedResults?[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let results = feedResults else { return }
        let result = results[indexPath.item]
        itemSelectedHandler?(result)
    }
}

extension AppsCategoryController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let numberOfRowInColumn: CGFloat = 3
        //高度記得扣掉cell間的距離以及section間的inset
        return CGSize(width: view.frame.width - 50, height: (view.frame.height - (interItemSpacing * numberOfRowInColumn - 1) - (2 * padding) ) / numberOfRowInColumn)
    }
    //當滑動方向為水平時,interItemSpacing為垂直cell間的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return interItemSpacing
    }
    //item跟section四周的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
    }
    
}
