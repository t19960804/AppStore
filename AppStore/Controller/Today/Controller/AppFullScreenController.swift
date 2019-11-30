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
    @objc fileprivate func closeFullScreen(button: UIButton){
        button.isHidden = true
        closeHandler?(imageCell)
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TodayController.cellHeight
    }

}
