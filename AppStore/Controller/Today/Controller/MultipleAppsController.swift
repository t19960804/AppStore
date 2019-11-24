//
//  MultipleAppsController.swift
//  AppStore
//
//  Created by t19960804 on 11/16/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class MultipleAppsController: BaseListController {
    var apps = [FeedResult]()
    fileprivate var itemSpacing: CGFloat = 16
    fileprivate var insetPadding: CGFloat = 24
    var todayItem: TodayItem!
    var mode: Mode = .small
    
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "close_button"), for: .normal)
        //當Button Type為System，圖片的顏色將由 Tint 決定
        btn.tintColor = .lightGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    
    //MARK: - init
    init(mode: Mode){
        self.mode = mode
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        if mode == .fullScreen {
            setUpConstraints()
        }
        //inset也會影響到Header
        collectionView.contentInset = mode == .fullScreen ? UIEdgeInsets(top: 30, left: insetPadding, bottom: 12, right: insetPadding) : UIEdgeInsets.zero
        collectionView.isScrollEnabled = mode == .fullScreen
        collectionView.register(AppsCategoryCell.self, forCellWithReuseIdentifier: AppsCategoryCell.id)
        collectionView.register(MultipleAppsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MultipleAppsHeader.headerID)
        
    }
    override func viewDidLayoutSubviews() {
        if let header = self.collectionView.supplementaryView(forElementKind: UICollectionView.elementKindSectionHeader, at: IndexPath(item: 0, section: 0)) as? MultipleAppsHeader {
            header.categoryLabel.text = todayItem.category
            header.titleLabel.text = todayItem.title
        }
    }
    
    fileprivate func setUpConstraints(){
        view.addSubview(dismissButton)
        dismissButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 20).isActive = true
        dismissButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        dismissButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dismissButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
    }
    @objc func handleDismiss(){
        dismiss(animated: true)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mode == .fullScreen ? apps.count : min(apps.count, 4)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsCategoryCell.id, for: indexPath) as! AppsCategoryCell
        //self.apps因為fetchData時候做判斷了,不會有nil的情況,最多就空陣列
        //如果self.apps為空陣列就不會觸發cellForItemAt,最多只觸發到numberOfItemsInSection
        //所以賦值給feedResult做Implicitly Unwrap的時候不會有事,但是傳nil就會crash
        cell.feedResult = self.apps[indexPath.item]
        return cell

    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = apps[indexPath.item].id
        let appDetailController = AppDetailController(appID: id)
        present(appDetailController, animated: true)
    }
    enum Mode {
        case small, fullScreen
    }
}
extension MultipleAppsController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if mode == .fullScreen {
            let height: CGFloat = 68
            return CGSize(width: view.frame.width - (insetPadding * 2), height: height)
        }
        let height = (view.frame.height - 3 * itemSpacing) / 4
        return CGSize(width: view.frame.width, height: height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return itemSpacing
    }
    //MARK: - Header
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if mode == .fullScreen {
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: MultipleAppsHeader.headerID, for: indexPath)
            return header
        }
        return UICollectionReusableView()
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if mode == .fullScreen {
            return CGSize(width: view.frame.width, height: 120)
        }
        return CGSize(width: 0, height: 0)
    }
    //調整collectionView跟Header的距離
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if mode == .fullScreen {
            return UIEdgeInsets(top: 12, left: 0, bottom: 0, right: 0)
        }
        return .zero
    }
}

