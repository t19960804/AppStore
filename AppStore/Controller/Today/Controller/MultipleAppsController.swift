//
//  MultipleAppsController.swift
//  AppStore
//
//  Created by t19960804 on 11/16/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class MultipleAppsController: BaseListController {
    var apps = [FeedResult]()
    var itemSpacing: CGFloat = 16
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.isScrollEnabled = false

        collectionView.register(AppsCategoryCell.self, forCellWithReuseIdentifier: AppsCategoryCell.id)
        fetchData()
    }
    func fetchData(){
        NetworkService.shared.fetchEditorsChoiceGames { (appsFeed, error) in
            if let error = error {
                print("Fetch TopGrossingApps Fail:\(error)")
                return
            }
            self.apps = appsFeed?.feed.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(apps.count, 4)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsCategoryCell.id, for: indexPath) as! AppsCategoryCell
        //self.apps因為fetchData時候做判斷了,不會有nil的情況,最多就空陣列
        //如果self.apps為空陣列就不會觸發cellForItemAt,最多只觸發到numberOfItemsInSection
        //所以賦值給feedResult做Implicitly Unwrap的時候不會有事,但是傳nil就會crash
        cell.feedResult = self.apps[indexPath.item]
        return cell

    }
    
}
extension MultipleAppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = (view.frame.height - 3 * itemSpacing) / 4
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
}
