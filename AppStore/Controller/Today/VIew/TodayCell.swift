//
//  TodayCell.swift
//  AppStore
//
//  Created by t19960804 on 10/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class TodayCell: UICollectionViewCell {
    static let cellID = "Cell"
    
    let appImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = UIImage(named: "garden")
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        layer.cornerRadius = 16
        clipsToBounds = true
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        addSubview(appImageView)
        appImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        appImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        appImageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        appImageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//
//  TodayController.swift
//  AppStore
//
//  Created by t19960804 on 10/11/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

//import UIKit
//
//class TodayController: BaseListController {
//    var startingFrame: CGRect?
//    var fullScreenController: UIViewController?
//    var topConstraint: NSLayoutConstraint?
//    var leftConstraint: NSLayoutConstraint?
//    var heightConstraint: NSLayoutConstraint?
//    var widthConstraint: NSLayoutConstraint?
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        collectionView.backgroundColor = UIColor(white: 0.95, alpha: 1)
//        collectionView.register(TodayCell.self, forCellWithReuseIdentifier: TodayCell.cellID)
//        collectionView.contentInset = UIEdgeInsets(top: 32, left: 0, bottom: 32, right: 0)
//    }
//    override func viewWillAppear(_ animated: Bool) {
//        self.navigationController?.navigationBar.isHidden = true
//    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 4
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TodayCell.cellID, for: indexPath)
//        return cell
//    }
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let fullScreenController = AppFullScreenController(style: .grouped)
//        let fullScreenView = fullScreenController.view!
//        view.addSubview(fullScreenView)
//        //沒呼叫addChild,TableViewController有時不會正確顯示cell
//        addChild(fullScreenController)
//        self.fullScreenController = fullScreenController
//        
//        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleRemoveRedView(gesture:)))
//        fullScreenView.addGestureRecognizer(tapGesture)
//        guard let cell = collectionView.cellForItem(at: indexPath) else { return }
//        //cell的frame只是以父View為基準,但這邊要的是跟整個螢幕相對的frame,所以給nil
//        guard let startingFrame = cell.superview?.convert(cell.frame, to: nil) else { return }
//        self.startingFrame = startingFrame
//        //使用startingFrame當作fullScreenView的起始frame,動畫會不夠順暢
//        topConstraint = fullScreenView.topAnchor.constraint(equalTo: view.topAnchor, constant: startingFrame.origin.y)
//        leftConstraint = fullScreenView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: startingFrame.origin.x)
//        heightConstraint = fullScreenView.heightAnchor.constraint(equalToConstant: startingFrame.height)
//        widthConstraint = fullScreenView.widthAnchor.constraint(equalToConstant: startingFrame.width)
//        [topConstraint, leftConstraint, heightConstraint, widthConstraint].forEach{ $0?.isActive = true }
//        self.view.layoutIfNeeded()
//        //展開
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
//            //setNeedsLayout,標記了需要刷新layout
//            self.topConstraint?.constant = 0
//            self.leftConstraint?.constant = 0
//            self.heightConstraint?.constant = self.view.frame.height
//            self.widthConstraint?.constant = self.view.frame.width
//            //如果有需要刷新的標記,馬上呼叫.layoutSubviews()刷新layout
//            self.view.layoutIfNeeded()
//            //iOS13使用CGAffineTransform時動畫會有bug
//            self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height
//        })
//        
//    }
//    @objc fileprivate func handleRemoveRedView(gesture: UITapGestureRecognizer){
//        //縮回
//        UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: .curveEaseOut, animations: {
//            guard let startingFrame = self.startingFrame else { return }
//            self.topConstraint?.constant = startingFrame.origin.y
//            self.leftConstraint?.constant = startingFrame.origin.x
//            self.heightConstraint?.constant = startingFrame.height
//            self.widthConstraint?.constant = startingFrame.width
//            self.view.layoutIfNeeded()
//            
//            if let tabBarFrame = self.tabBarController?.tabBar.frame {
//                self.tabBarController?.tabBar.frame.origin.y = self.view.frame.height - tabBarFrame.height
//            }
//        }) { _ in
//            gesture.view?.removeFromSuperview()
//            if let controller = self.fullScreenController {
//                //addChild後,記得remove掉
//                controller.removeFromParent()
//            }
//        }
//    }
//}
//extension TodayController: UICollectionViewDelegateFlowLayout {
//    //想要cell有左右的inset,不一定要設定sectionInset,因為設定了左右的sectionInset,sizeForItemAt()也要跟著減掉sectionInset
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        return CGSize(width: view.frame.width - 64, height: 450)
//    }
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
//        return 32
//    }
//}
