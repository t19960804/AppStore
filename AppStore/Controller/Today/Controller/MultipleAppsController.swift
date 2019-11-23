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
    fileprivate var insetPadding: CGFloat = 16
    
    let dismissButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "close_button"), for: .normal)
        //當Button Type為System，圖片的顏色將由 Tint 決定
        btn.tintColor = .lightGray
        btn.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return btn
    }()
    var mode: Mode = .small
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
        collectionView.contentInset = mode == .fullScreen ? UIEdgeInsets(top: 0, left: insetPadding, bottom: 0, right: insetPadding) : UIEdgeInsets.zero
        collectionView.isScrollEnabled = mode == .fullScreen
        collectionView.register(AppsCategoryCell.self, forCellWithReuseIdentifier: AppsCategoryCell.id)
        
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
}
