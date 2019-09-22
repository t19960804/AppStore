//
//  AppDetailController.swift
//  AppStore
//
//  Created by t19960804 on 9/15/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {
    var appID: String? {
        didSet {
            //fetch data of detail
            NetworkService.shared.fetchAppDetail(id: appID!) { (result, error) in
                self.app = result?.results.first
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        }
    }
    var app: Result?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: AppDetailCell.cellID)
        navigationController?.navigationBar.prefersLargeTitles = false
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCell.cellID, for: indexPath) as! AppDetailCell
        cell.app = self.app
        return cell
    }
    
    
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let dummyCell = AppDetailCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
        //cell需要知道元件的內容才能計算
        dummyCell.app = self.app
        //刷新layout
        dummyCell.layoutIfNeeded()
        //根據releaseNotes的內容調整高度
        //根據View的constraints,回傳一個最佳的size
        //targetSize > The size that you prefer for the view
        let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
        
        return CGSize(width: view.frame.width, height: estimatedSize.height)
    }
}
