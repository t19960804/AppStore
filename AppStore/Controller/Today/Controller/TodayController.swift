//
//  TodayController.swift
//  AppStore
//
//  Created by t19960804 on 10/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class TodayController: BaseListController {
    static let cellHeight: CGFloat = 500
    
    var startingFrame: CGRect?
    var fullScreenController: AppFullScreenController?
    var todayItems = [TodayItem]()
    let activityIndicator: UIActivityIndicatorView = {
        let ai = UIActivityIndicatorView(style: .whiteLarge)
        ai.translatesAutoresizingMaskIntoConstraints = false
        ai.color = .darkGray
        ai.startAnimating()
        ai.hidesWhenStopped = true
        return ai
    }()
    let blurView: UIVisualEffectView = {
        let v = UIVisualEffectView(effect: UIBlurEffect(style: .regular))
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alpha = 0
        return v
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: CellType.Single.rawValue)
        collectionView.register(MultipleAppCell.self, forCellWithReuseIdentifier: CellType.Multiple.rawValue)
        setUpConstraints()
        fetchTodayData()
    }
    fileprivate func setUpConstraints(){
        view.addSubview(activityIndicator)
        view.addSubview(blurView)
        
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        blurView.fillSuperView()
    }
    fileprivate func fetchTodayData(){
        let dispatchGroup = DispatchGroup()
        var editorsChoiceGamesFeed: AppsFeed?
        var topGrossingAppsFeed: AppsFeed?

        dispatchGroup.enter()
        NetworkService.shared.fetchEditorsChoiceGames { (appsFeed, error) in
            if let error = error {
                print("Fetch EditorsChoiceGames fail:\(error)")
            }
            editorsChoiceGamesFeed = appsFeed
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchTopGrossingApps { (appsFeed, error) in
            if let error = error {
                print("Fetch TopGrossingApps fail:\(error)")
            }
            topGrossingAppsFeed = appsFeed
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.activityIndicator.stopAnimating()
            self.todayItems = [
                TodayItem(category: "THE DAILY LIST", title: editorsChoiceGamesFeed?.feed.title ?? "Unknow"
                    , appImage: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white, type: .Multiple, multipleAppsResults: editorsChoiceGamesFeed?.feed.results ?? []),
                TodayItem(category: "THE DAILY LIST", title: topGrossingAppsFeed?.feed.title
                    ?? "Unknow", appImage: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white, type: .Multiple, multipleAppsResults: topGrossingAppsFeed?.feed.results ?? []),
                TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", appImage: UIImage(named: "holiday") ?? UIImage(), description: "Find out all you need to know on how to travel without packing eveything! ", backgroundColor: #colorLiteral(red: 0.9862492681, green: 0.9633030295, blue: 0.727068305, alpha: 1), type: .Single, multipleAppsResults: []),
                TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", appImage: UIImage(named: "garden") ?? UIImage(), description: "Find out all you need to know on how to travel without packing eveything! ", backgroundColor: #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1), type: .Single, multipleAppsResults: [])
            ]
            self.collectionView.reloadData()
            print("Fetch all today data completely")
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayItems.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellType = todayItems[indexPath.item].type
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellType.rawValue, for: indexPath) as! BaseTodayCell
        cell.todayItem = todayItems[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        switch todayItems[indexPath.item].type {
        case .Multiple:
            showAppsListController(indexPath: indexPath)
        default:
            showAppFullScreenController(indexPath: indexPath)
        }
    }
    fileprivate func showAppsListController(indexPath: IndexPath){
        let listContoller = MultipleAppsController(mode: .fullScreen)
        listContoller.apps = todayItems[indexPath.item].multipleAppsResults
        listContoller.todayItem = todayItems[indexPath.item]
        present(listContoller, animated: true)
    }
    fileprivate func showAppFullScreenController(indexPath: IndexPath){
        //Step 1 : Set up FullScreenController
        let fullScreenController = AppFullScreenController(style: .grouped)
        let fullScreenView = fullScreenController.view!
        self.fullScreenController = fullScreenController
        fullScreenController.closeHandler = { cell in
            self.shrinkTheView(with: fullScreenView, and: cell)
        }
        fullScreenController.expandHandler = { cell in
            cell.todayCell.topAnchorOfVerticalStackView?.constant = 48
            cell.layoutIfNeeded()
        }
        view.addSubview(fullScreenView)
        //Step 2 : Set up origin frame of FullScreenController
        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //cell的frame只是以父View為基準,但這邊要的是跟整個螢幕相對的frame,所以給nil
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        fullScreenView.frame = startingFrame
        fullScreenController.todayItem = todayItems[indexPath.item]
        //Step 3 : Expand Animation
        expandTheView(with: fullScreenView)
    }
    fileprivate func expandTheView(with view: UIView){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.blurView.alpha = 1
            view.frame = self.view.frame
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height
        })
    }

    fileprivate func shrinkTheView(with view: UIView, and cell: AppImageFullScreenCell){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.blurView.alpha = 0
            self.fullScreenController?.tableView.contentOffset.y = 0
            self.fullScreenController?.view.transform = .identity
            guard let endingFrame = self.startingFrame else { return }
            view.frame = endingFrame
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height - tabBarFrame.height
            }
            //調整constraint後記得刷新layout
            cell.todayCell.topAnchorOfVerticalStackView?.constant = 20
            cell.closeButton.alpha = 0
            cell.layoutIfNeeded()
            self.collectionView.isUserInteractionEnabled = false

        }) { _ in
            //Animation Complete
            view.removeFromSuperview()
            self.collectionView.isUserInteractionEnabled = true
        }
    }

}
extension TodayController: UICollectionViewDelegateFlowLayout {
    //想要cell有左右的inset,不一定要設定sectionInset,因為設定了左右的sectionInset,sizeForItemAt()也要跟著減掉sectionInset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 64, height: TodayController.cellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
