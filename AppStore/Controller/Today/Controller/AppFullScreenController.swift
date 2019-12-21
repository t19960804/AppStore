//
//  AppFullScreenController.swift
//  AppStore
//
//  Created by t19960804 on 10/20/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppFullScreenController: UIViewController {
    var expandHandler: ((AppImageFullScreenCell) -> Void)?
    var closeHandler: ((AppImageFullScreenCell) -> Void)?
    var todayItem: TodayItem?
    var imageCell: AppImageFullScreenCell!
    var beginOffset: CGFloat = 0
    
    let closeButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "close_button"), for: .normal)
        btn.addTarget(self, action: #selector(closeFullScreen(button:)), for: .touchUpInside)
        return btn
    }()
    let fullScreenTableView: UITableView = {
        let tv = UITableView(frame: .zero, style: .grouped)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorStyle = .none
        tv.allowsSelection = false
        //不要添加safe area的contentInset到tableView
        tv.contentInsetAdjustmentBehavior = .never
        return tv
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.clipsToBounds = true
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanDismission))
        view.addGestureRecognizer(gesture)
        gesture.delegate = self
        fullScreenTableView.delegate = self
        fullScreenTableView.dataSource = self
        setUpContstrints()
        
    }
    fileprivate func setUpContstrints(){
        view.addSubview(fullScreenTableView)
        view.addSubview(closeButton)
        fullScreenTableView.fillSuperView()
        closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 48).isActive = true
        closeButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 12).isActive = true
        closeButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 38).isActive = true
    }
    @objc fileprivate func closeFullScreen(button: UIButton){
        button.isHidden = true
        closeHandler?(imageCell)
    }
    @objc fileprivate func handlePanDismission(gesture: UIPanGestureRecognizer){
        if gesture.state == .began {
            //若從最底部往上滑,translationY會超級大,造成做transform的倍數會急速變小,造成彈跳
            //所以這邊要再扣掉一開始的contentOffset.y
            beginOffset = fullScreenTableView.contentOffset.y
        }
        if fullScreenTableView.contentOffset.y > 0 {
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
    

}
extension AppFullScreenController: UIGestureRecognizerDelegate {
    //為了同時識別Pangesture手勢 + 原本scrolling的手勢
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
extension AppFullScreenController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = AppDescriptionCell()
        return cell
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        imageCell = AppImageFullScreenCell()
        imageCell.todayCell.todayItem = self.todayItem
        imageCell.todayCell.layer.cornerRadius = 0
        imageCell.clipsToBounds = true
        expandHandler?(imageCell)
        return imageCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return TodayController.cellHeight
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y < 0 {
            scrollView.isScrollEnabled = false
            scrollView.isScrollEnabled = true
        }
    }
}
