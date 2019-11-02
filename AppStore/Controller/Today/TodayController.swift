//
//  TodayController.swift
//  AppStore
//
//  Created by t19960804 on 10/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class TodayController: BaseListController {
    var startingFrame: CGRect?
    var fullScreenController: AppFullScreenController?
    var safeAreaTopPadding: CGFloat = 0.0
    let todayItems = [
        TodayItem(category: "LIFE HACK", title: "Utilizing your Time", appImage: UIImage(named: "garden") ?? UIImage(), description: "All the tools and apps you need to intelligently organize your life the right way", backgroundColor: .white),
        TodayItem(category: "HOLIDAYS", title: "Travel on a Budget", appImage: UIImage(named: "holiday") ?? UIImage(), description: "Find out all you need to know on how to travel without packing eveything! ", backgroundColor: #colorLiteral(red: 1, green: 0.9599583745, blue: 0.707649529, alpha: 1))]
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.cellID)
        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)

    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        if let window = UIApplication.shared.keyWindow {
            safeAreaTopPadding = window.safeAreaInsets.top
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return todayItems.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell.cellID, for: indexPath) as! TodayCell
        cell.todayItem = todayItems[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let fullScreenController = AppFullScreenController(style: .grouped)
        let fullScreenView = fullScreenController.view!
        self.fullScreenController = fullScreenController
        view.addSubview(fullScreenView)

        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
        //cell的frame只是以父View為基準,但這邊要的是跟整個螢幕相對的frame,所以給nil
        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
        self.startingFrame = startingFrame
        fullScreenView.frame = startingFrame
        fullScreenController.todayItem = todayItems[indexPath.item]
        expandTheView(with: fullScreenView)
        
        fullScreenController.closeHandler = {
            self.handleRemoveRedView(with: fullScreenView)
        }
    }
    func expandTheView(with view: UIView){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            view.frame = self.view.frame
            //iOS13使用CGAffineTransform時動畫會有bug
            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height
        })
    }

    fileprivate func handleRemoveRedView(with view: UIView){
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
            self.fullScreenController?.tableView.contentOffset.y =  -self.safeAreaTopPadding
            guard let endingFrame = self.startingFrame else { return }
            view.frame = endingFrame
            if let tabBarFrame = self.tabBarController?.tabBar.frame {
                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height - tabBarFrame.height
            }
        }) { _ in
            view.removeFromSuperview()
        }
    }

}
extension TodayController: UICollectionViewDelegateFlowLayout {
    //想要cell有左右的inset,不一定要設定sectionInset,因為設定了左右的sectionInset,sizeForItemAt()也要跟著減掉sectionInset
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 64, height: 450)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 32
    }
}
