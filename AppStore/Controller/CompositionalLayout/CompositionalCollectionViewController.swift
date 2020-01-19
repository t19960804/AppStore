//
//  CompositionalCollectionViewController.swift
//  AppStore
//
//  Created by t19960804 on 1/18/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class CompositionalCollectionViewController: UICollectionViewController {
    let cellID = "Cell"
    
//    init() {
//        //若要讓畫面的右邊有一部分下個cell,在group為fractionalWidth(1)的情況下,調整item的寬是沒有用的,
//        //因為group的寬度還是會佔滿,要調整的是group本身的寬
//        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
//        item.contentInsets.trailing = 16
//        item.contentInsets.bottom = 16
//        //group決定item的排列方向
//        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
//        let section = NSCollectionLayoutSection(group: group)
//        //讓 section 可以與 CollectionView 滾動的 90 度方向滾動
//        section.orthogonalScrollingBehavior = .groupPaging
//        section.contentInsets.leading = 23
//        let layout = UICollectionViewCompositionalLayout(section: section)
//        super.init(collectionViewLayout: layout)
//    }
    init() {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets.trailing = 16
        item.contentInsets.bottom = 16
        //group,一次paging有多少cell,那些cell就是一個group
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item,item,item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 23
        let layout = UICollectionViewCompositionalLayout(section: section)
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "App"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 20
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = .red
        return cell
    }
}
