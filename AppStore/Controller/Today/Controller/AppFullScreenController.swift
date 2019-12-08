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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        //不要添加safe area的contentInset到tableView
        tableView.contentInsetAdjustmentBehavior = .never
        //Pan Dismission
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanDismission))
        view.addGestureRecognizer(gesture)
        gesture.delegate = self
    }
    @objc fileprivate func closeFullScreen(button: UIButton){
        button.isHidden = true
        closeHandler?(imageCell)
    }
    @objc fileprivate func handlePanDismission(gesture: UIPanGestureRecognizer){
        switch gesture.state {
        case .changed://A change to a continuous gesture
            //手指移動的偏移量(初值為0),往下偏移量為正,往上為負
            let translationY = gesture.translation(in: view).y
            let scaleRatio = min(1 - (translationY / 1000), 1)
            view.transform = CGAffineTransform(scaleX: scaleRatio, y: scaleRatio)
        case .ended://The end of a continuous gesture
            closeHandler?(imageCell)
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

}
extension AppFullScreenController: UIGestureRecognizerDelegate {
    //為了同時識別Pangesture手勢 + 原本scrolling的手勢
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
