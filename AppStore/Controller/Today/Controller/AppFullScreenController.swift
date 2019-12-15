//
//  AppFullScreenController.swift
//  AppStore
//
//  Created by t19960804 on 10/20/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppFullScreenController: UITableViewController {
    var expandHandler: ((AppImageFullScreenCell) -> Void)?
    var closeHandler: ((AppImageFullScreenCell) -> Void)?
    var todayItem: TodayItem?
    var imageCell: AppImageFullScreenCell!
    var beginOffset: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        //不要添加safe area的contentInset到tableView
        tableView.contentInsetAdjustmentBehavior = .never
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanDismission))
        view.addGestureRecognizer(gesture)
        gesture.delegate = self
    }
    @objc fileprivate func closeFullScreen(button: UIButton){
        button.isHidden = true
        closeHandler?(imageCell)
    }
    @objc fileprivate func handlePanDismission(gesture: UIPanGestureRecognizer){
        if gesture.state == .began {
            //若從最底部往上滑,translationY會超級大,造成做transform的倍數會急速變小,造成彈跳
            //所以這邊要再扣掉一開始的contentOffset.y
            beginOffset = tableView.contentOffset.y
        }
        if tableView.contentOffset.y > 0 {
            return
        }
        //手指移動的偏移量(初值為0),往下為正,往上為負
        let translationY = gesture.translation(in: view).y
        switch gesture.state {
        case .changed:
            let trueOffset = translationY - beginOffset
            var scaleRatio = 1 - (trueOffset / 1000)
            scaleRatio = min(scaleRatio, 1)//避免放大太多
            scaleRatio = max(scaleRatio, 0.7)//避免縮小太多
            view.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        case .ended:
            if translationY > 0 {
                closeHandler?(imageCell)
            }
        default:
            print("The state of pan gesture not be handled now")
        }
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AppDescriptionCell()
        return cell
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        imageCell = AppImageFullScreenCell()
        imageCell.todayCell.todayItem = self.todayItem
        imageCell.closeButton.addTarget(self, action: #selector(closeFullScreen(button:)), for: .touchUpInside)
        imageCell.todayCell.layer.cornerRadius = 0
        imageCell.clipsToBounds = true
        expandHandler?(imageCell)
        return imageCell
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TodayController.cellHeight
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }

}
extension AppFullScreenController: UIGestureRecognizerDelegate {
    //為了同時識別Pangesture手勢 + 原本scrolling的手勢
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
