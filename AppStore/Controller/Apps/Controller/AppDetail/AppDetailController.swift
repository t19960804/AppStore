//
//  AppDetailController.swift
//  AppStore
//
//  Created by t19960804 on 9/15/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppDetailController: BaseListController {

    let appID: String//"依賴"appID來做fetchData
    var app: Result?
    var reviews: UserReviews?
    fileprivate let dispatchGroup = DispatchGroup()
    
    //依賴注入
    //https://medium.com/@hung_yanbin/%E7%82%BA%E4%BB%80%E9%BA%BC%E8%A6%81%E7%94%A8-dependency-injection-for-android-developer-e7b65704a5ac
    init(appID: String){
        self.appID = appID
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.contentInset.bottom = 16
        collectionView.register(AppDetailCell.self, forCellWithReuseIdentifier: AppDetailCell.cellID)
        collectionView.register(AppsPreviewCell.self, forCellWithReuseIdentifier: AppsPreviewCell.cellID)
        collectionView.register(AppsReviewCell.self, forCellWithReuseIdentifier: AppsReviewCell.cellID)
        navigationController?.navigationBar.prefersLargeTitles = false
        fetchAppDeatilData()
    }
    fileprivate func fetchAppDeatilData(){
        dispatchGroup.enter()
        NetworkService.shared.fetchAppDetail(id: appID) { [weak self] (result, error) in
            if let error = error {
                print(error)
                return
            }
            self?.app = result?.results.first
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchAppReviews(id: appID) { [weak self] (reviews, error) in
            if let error = error {
                print(error)
                return
            }
            self?.reviews = reviews
            self?.dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return SortOfCell.allCases.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sortOfCell = SortOfCell.allCases[indexPath.item]
        
        switch sortOfCell {
        case .Detail:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppDetailCell.cellID, for: indexPath) as! AppDetailCell
            cell.app = self.app
            return cell
        case .Preview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsPreviewCell.cellID, for: indexPath) as! AppsPreviewCell
            cell.screenShotController.app = self.app
            return cell
        case .UserReview:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsReviewCell.cellID, for: indexPath) as! AppsReviewCell
            cell.reviewController.reviews = self.reviews
            return cell
        }
    }
    
    
}

extension AppDetailController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sortOfCell = SortOfCell.allCases[indexPath.item]
        var cellHeight: CGFloat = 0
        
        switch sortOfCell {
        case .Detail:
            let dummyCell = AppDetailCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 1000))
            //cell需要知道元件的內容才能計算
            dummyCell.app = self.app
            //刷新layout
            dummyCell.layoutIfNeeded()
            //根據releaseNotes的內容調整高度
            //根據View的constraints,回傳一個最佳的size
            //targetSize > The size that you prefer for the view
            let estimatedSize = dummyCell.systemLayoutSizeFitting(CGSize(width: view.frame.width, height: 1000))
            cellHeight = estimatedSize.height
        case .Preview:
            cellHeight = 500
        case .UserReview:
            cellHeight = 220
        }
        return CGSize(width: view.frame.width, height: cellHeight)

    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 30
    }
    //CaseIterable > 將enum當成array使用
    enum SortOfCell: CaseIterable {
        case Detail
        case Preview
        case UserReview
    }
}

