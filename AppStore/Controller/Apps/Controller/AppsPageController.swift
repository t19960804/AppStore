//
//  AppsController.swift
//  AppStore
//
//  Created by t19960804 on 8/17/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsPageController: BaseListController {
    
    var appGroups = [AppsFeed]()
    var socialAppGroups = [SocialApp]()
    
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .black
        ai.startAnimating()
        ai.hidesWhenStopped = true
        return ai
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: AppsPageHeader.id)
        collectionView!.register(AppsPageCell.self, forCellWithReuseIdentifier: AppsPageCell.id)
        setUpConstraints()
        fetchData()
        
    }
    fileprivate func setUpConstraints(){
        view.addSubview(activityIndicator)
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
    fileprivate func fetchData(){
        //Fetch資料的三個任務完成順序不一定,所以要在三個任務都執行完才更新UI,避免閃爍
        let dispatchGroup = DispatchGroup()
        //.enter() > counter + 1
        //.leave() > counter - 1
        //counter == 0 時呼叫.notify()
        dispatchGroup.enter()
        NetworkService.shared.fetchEditorsChoiceGames { [weak self] (gamesFeed, error) in
            if let error = error {
                print("Fetch Game EditorsChoiceGames Fail:\(error)")
                return
            }
            if let feed = gamesFeed {
                self?.appGroups.append(feed)
            }
            //從DispatchGroup中移除
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        NetworkService.shared.fetchTopGrossingApps { [weak self] (gamesFeed, error) in
            if let error = error {
                print("Fetch TopGrossingApps Feeds Fail:\(error)")
                return
            }
            if let feed = gamesFeed {
                self?.appGroups.append(feed)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        NetworkService.shared.fetchTopFreeGames { [weak self] (gamesFeed, error) in
            if let error = error {
                print("Fetch TopFreeGames Feeds Fail:\(error)")
                return
            }
            if let feed = gamesFeed {
                self?.appGroups.append(feed)
            }
            dispatchGroup.leave()
        }
        dispatchGroup.enter()
        NetworkService.shared.fetchSocialApps { [weak self] (socialApps, error) in
            if let error = error{
                print("Fetch SoicalApps Fail:\(error)")
                return
            }
            //可以用optional binding或是給予空陣列
            self?.socialAppGroups = socialApps ?? []
            dispatchGroup.leave()
        }
        //任務都執行完的completion
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.collectionView.reloadData()
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return appGroups.count
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: AppsPageHeader.id, for: indexPath) as! AppsPageHeader
        header.appsTopMainController.appsFeed = socialAppGroups
        header.appsTopMainController.collectionView.reloadData()
        return header
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsPageCell.id, for: indexPath) as! AppsPageCell
        cell.titleLabel.text = appGroups[indexPath.item].feed.title
        cell.appsCategoryController.feedResults = appGroups[indexPath.item].feed.results
        cell.appsCategoryController.collectionView.reloadData()
        cell.appsCategoryController.itemSelectedHandler = { [weak self] appResult in
            //因為appsCategoryController本身沒有UINavigationController
            //所以在這實作navigation push
            let detailController = AppDetailController(appID: appResult.id)
            self?.navigationController?.pushViewController(detailController, animated: true)
        }
        return cell
    }
}
extension AppsPageController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 0, bottom: 0, right: 0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //預設情況下cell之間會有距離
        return 0
    }
}
