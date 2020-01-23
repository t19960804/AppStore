//
//  CompositionalCollectionViewController.swift
//  AppStore
//
//  Created by t19960804 on 1/18/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class CompositionalCollectionViewController: UICollectionViewController {
    let cellID = "CompositionalTest"
    static let cellWidthRatio: CGFloat = 0.8
    
    init() {
        //Multiple Section,根據不同的section,回傳不同的layout
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            switch sectionNumber {
                //在self初始化完成之前,不能在closure內使用self.方法,會報錯
                case SectionType.TopSection.rawValue:
                    return CompositionalCollectionViewController.setUpTopSection()
                case SectionType.MultipleAppsSection.rawValue:
                    return CompositionalCollectionViewController.setUpMultipleAppsSection()
            default:
                print("Unknow Section")
                return nil
            }
            
        }
        super.init(collectionViewLayout: layout)
    }
    static func setUpTopSection() -> NSCollectionLayoutSection {
        //若要讓畫面的右邊有一部分下個cell,在group為fractionalWidth(1)的情況下,調整item的寬是沒有用的,
        //因為group的寬度還是會佔滿,要調整的是group本身的寬
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        //group決定item的排列方向
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(CompositionalCollectionViewController.cellWidthRatio), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        //讓 section 可以與 CollectionView 滾動的 90 度方向滾動
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 23
        return section
    }
    static func setUpMultipleAppsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(CompositionalCollectionViewController.cellWidthRatio), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 23
        return section
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "App"
        navigationController?.navigationBar.prefersLargeTitles = true
        collectionView.register(AppsPageHeaderCell.self, forCellWithReuseIdentifier: AppsPageHeaderCell.cellID)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case SectionType.TopSection.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsPageHeaderCell.cellID, for: indexPath)
            return cell
        case SectionType.MultipleAppsSection.rawValue:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
            cell.backgroundColor = .blue
            return cell
        default:
            print("Unknow Cell")
            return UICollectionViewCell()
        }
        
    }
    enum SectionType: Int {
        case TopSection
        case MultipleAppsSection
    }
}
