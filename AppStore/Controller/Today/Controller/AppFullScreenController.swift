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
    fileprivate var beginOffset: CGFloat = 0
    fileprivate let floatingViewHeight: CGFloat = 100
    fileprivate let extraPadding: CGFloat = 400//避免Controller dismiss時看見FloatingView
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
    let blurFloatingView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 16
        v.clipsToBounds = true
        return v
    }()
    let appThumbnailImageVIew: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "garden"))
        iv.contentMode = .scaleAspectFit
        iv.layer.cornerRadius = 16
        iv.clipsToBounds = true
        return iv
    }()
    let appThumbnailTitleLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Life Hack"
        lb.font = .boldSystemFont(ofSize: 18)
        return lb
    }()
    let appThumbnailSubTitleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16)
        lb.text = "Utilizing your Time"
        return lb
    }()
    let getButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("GET", for: .normal)
        btn.backgroundColor = .darkGray
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 16
        return btn
    }()
    lazy var vStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [
           appThumbnailTitleLabel,
           appThumbnailSubTitleLabel
          ])
        sv.axis = .vertical
        sv.spacing = 6
        return sv
       }()
    lazy var hStackView: UIStackView = {
       let sv = UIStackView(arrangedSubviews: [
        appThumbnailImageVIew,
        vStackView,
        getButton
       ])
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 16
        sv.alignment = .center
        return sv
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
        setUpBlurEffectView()
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
    fileprivate func setUpBlurEffectView(){
        view.addSubview(blurFloatingView)
        blurFloatingView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        blurFloatingView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        blurFloatingView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: floatingViewHeight + extraPadding).isActive = true
        blurFloatingView.heightAnchor.constraint(equalToConstant: floatingViewHeight).isActive = true
        let blurEffect = UIBlurEffect(style: .regular)
        let effectView = UIVisualEffectView(effect: blurEffect)
        effectView.translatesAutoresizingMaskIntoConstraints = false
        blurFloatingView.addSubview(effectView)
        blurFloatingView.addSubview(hStackView)
        effectView.fillSuperView()
        //sub views
        appThumbnailImageVIew.heightAnchor.constraint(equalToConstant: 80).isActive = true
        appThumbnailImageVIew.widthAnchor.constraint(equalToConstant: 80).isActive = true
        getButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        getButton.heightAnchor.constraint(equalToConstant: 32).isActive = true
        hStackView.topAnchor.constraint(equalTo: blurFloatingView.topAnchor, constant: 12).isActive = true
        hStackView.leftAnchor.constraint(equalTo: blurFloatingView.leftAnchor, constant: 12).isActive = true
        hStackView.rightAnchor.constraint(equalTo: blurFloatingView.rightAnchor, constant: -12).isActive = true
        hStackView.bottomAnchor.constraint(equalTo: blurFloatingView.bottomAnchor, constant: -12).isActive = true
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
        let window = UIApplication.shared.keyWindow
        guard let bottomPadding = window?.safeAreaInsets.bottom else {
            return
        }
        //Floating View Controll
        let shouldShowFloatingView = scrollView.contentOffset.y > 100
        let translationY = -(floatingViewHeight + bottomPadding + extraPadding)
        let transform = shouldShowFloatingView ? CGAffineTransform(translationX: 0, y: translationY) : .identity
        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.blurFloatingView.transform = transform
        })
        
    }
}
