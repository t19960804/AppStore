//
//  CompositionalCollectionViewController.swift
//  AppStore
//
//  Created by t19960804 on 1/18/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class CompositionalCollectionViewController: UICollectionViewController {
    let headerID = "CompositionalHeaderID"
    let multipleCellID = "CompositionalMultipleCellID"
    
    static let cellWidthRatio: CGFloat = 0.8
    //DiffableDataSource為了在資料變化時辨識差異，知道哪些是新增刪除的資料，需要設定 generic type，描述能辨識 section & item 的型別。
    //section & item 的型別必須遵從 protocol Hashable，因為這樣表格的 section & item 資料才能產生可判斷是否為同一筆資料的 hash value，DiffableDataSource 將用 hash value 判斷資料的變化，再用動畫呈現新增刪除的效果。
    //一定要宣告成全域變數,不然會從記憶體消失
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<SectionType, AnyHashable> = .init(collectionView: collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
        if let feed = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsPageHeaderCell.cellID, for: indexPath) as! AppsPageHeaderCell
            cell.feed = feed
            return cell
        } else if let result = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.multipleCellID, for: indexPath) as! AppsCategoryCell
            cell.feedResult = result
            return cell
        }
        return nil
    }
    init() {
        //Multiple Section,根據不同的section,回傳不同的layout
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
            //根據appendSection的陣列順序去做switch
            switch sectionNumber {
                //在self初始化完成之前,不能在closure內使用self.方法,會報錯
                case SectionType.TopSection.rawValue:
                    return CompositionalCollectionViewController.setUpTopSection()
            default:
                return CompositionalCollectionViewController.setUpMultipleAppsSection()
            }
        }
        super.init(collectionViewLayout: layout)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        section.contentInsets.top = 23
        return section
    }
    static func setUpMultipleAppsSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(CompositionalCollectionViewController.cellWidthRatio), heightDimension: .absolute(300)), subitems: [item])
        let section = NSCollectionLayoutSection(group: group)
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 23
        //Header設定,取代referenceSizeForHeaderInSection()
        //kind可以是任何字串,在實作viewForSupplementaryElementOfKind的時候,用來分辨header或footer
        //並提供要呈現的View
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: kind, alignment: .topLeading)]
        return section
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        navigationItem.title = "App"
        navigationController?.navigationBar.prefersLargeTitles = true
        //Top Section
        collectionView.register(AppsPageHeaderCell.self, forCellWithReuseIdentifier: AppsPageHeaderCell.cellID)
        //Multiple Apps Section
        collectionView.register(CompositionalSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView.register(AppsCategoryCell.self, forCellWithReuseIdentifier: multipleCellID)
        setUpDiffableDataSource()
    }
    fileprivate func setUpDiffableDataSource(){
        collectionView.dataSource = diffableDataSource
        setupSectionHeader()
        NetworkService.shared.fetchSocialApps { (apps, error) in
            if let error = error {
                print("Fetch SocailApps failed:\(error)")
                return
            }
            NetworkService.shared.fetchTopGrossingApps { (appsFeed, error) in
                if let error = error {
                    print("Fetch TopGrossingApps failed:\(error)")
                    return
                }
                NetworkService.shared.fetchEditorsChoiceGames { (gamesFeed, error) in
                    if let error = error {
                        print("Fetch EditorsChoiceGames failed:\(error)")
                        return
                    }
                    var snapShot = self.diffableDataSource.snapshot()//指定表格內容
                    snapShot.appendSections([.TopSection, .TopGrossingApps, .EditorChoiceGames])
                    //SocialApp
                    snapShot.appendItems(apps ?? [], toSection: .TopSection)
                    //TopGrossing
                    let results = appsFeed?.feed.results
                    snapShot.appendItems(results ?? [], toSection: .TopGrossingApps)
                    //Editor Choice
                    let gameResults = gamesFeed?.feed.results
                    snapShot.appendItems(gameResults ?? [], toSection: .EditorChoiceGames)
                    self.diffableDataSource.apply(snapShot)
                }
                
            }
        }
    }
    fileprivate func setupSectionHeader(){
        diffableDataSource.supplementaryViewProvider = .some({ (collectionView, kind, indexPath) -> UICollectionReusableView? in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerID, for: indexPath) as! CompositionalSectionHeader
            if let item = self.diffableDataSource.itemIdentifier(for: indexPath) {
                let snapShot = self.diffableDataSource.snapshot()
                let section = snapShot.sectionIdentifier(containingItem: item)!
                if section == .TopGrossingApps {
                    header.titleLabel.text = "Top Grossing iPhone Apps"
                } else {
                    header.titleLabel.text = "Editor's Choice Games"
                }
            }
            return header
        })
    }

    enum SectionType: Int, CaseIterable {
        case TopSection
        case TopGrossingApps
        case EditorChoiceGames
//        case TopFreeGames
    }
}

//appendSection(numberOfSection)
//appendItems(numberOfItemsInSection),讓items跟section綁定

//機制猜測
//設定section的layout時,會根據appendSections的陣列索引做switch
//appendItems會根據toSection參數,比對appendSection陣列的索引去決定每個append進去item的indexPath,以及決定item要被放入何種section的layout
//apply之後,要dequeueCell時再將item的indexPath填入做render
