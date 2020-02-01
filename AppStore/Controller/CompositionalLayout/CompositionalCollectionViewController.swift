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
    var socialApps = [SocialApp]()
    var editorChoiceGames: AppsFeed?
    var topGrossingApps: AppsFeed?
    var topFreeGames: AppsFeed?
    
    static let cellWidthRatio: CGFloat = 0.8
    //DiffableDataSource 控制表格的內容時，為了在資料變化時辨識差異，知道哪些是新增刪除的資料，需要設定 generic type，描述能辨識 section & item 的型別。
    //section & item 的辨識型別必須遵從 protocol Hashable，因為這樣表格的 section & item 資料才能產生可判斷是否為同一筆資料的 hash value，DiffableDataSource 將用 hash value 判斷資料的變化，再用動畫呈現新增刪除的效果。
    //一定要宣告成全域變數,不然會從記憶體消失
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<SectionType, SocialApp> = .init(collectionView: collectionView) { (collectionView, indexPath, socialApp) -> UICollectionViewCell? in
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsPageHeaderCell.cellID, for: indexPath) as! AppsPageHeaderCell
        cell.feed = socialApp
        return cell
    }
    init() {
        //Multiple Section,根據不同的section,回傳不同的layout
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) -> NSCollectionLayoutSection? in
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
        //Header設定,取代referenceSizeForHeaderInSection()
        //kind可以是任何字串,在實作viewForSupplementaryElementOfKind的時候,用來分辨header或footer
        //並提供要呈現的View
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [NSCollectionLayoutBoundarySupplementaryItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(60)), elementKind: kind, alignment: .topLeading)]
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
        collectionView.register(CompositionalSectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerID)
        collectionView.register(AppsPageHeaderCell.self, forCellWithReuseIdentifier: AppsPageHeaderCell.cellID)
        collectionView.register(AppsCategoryCell.self, forCellWithReuseIdentifier: multipleCellID)
        //一次性抓取所有json,並且只reload collectionview一次
        //fetchAppsData()
        setUpDiffableDataSource()
    }
    fileprivate func setUpDiffableDataSource(){
        collectionView.dataSource = diffableDataSource
        
        NetworkService.shared.fetchSocialApps { (apps, error) in
            if let error = error {
                print("Fetch SocailApps failed:\(error)")
                return
            }
            //指定表格內容
            var snapShot = self.diffableDataSource.snapshot()
            //SectionIdentifierType & ItemIdentifierType 必須和當初 UITableViewDiffableDataSource 指定的 generic type 一致
            snapShot.appendSections([.TopSection])
            snapShot.appendItems(apps ?? [], toSection: .TopSection)
            self.diffableDataSource.apply(snapShot)
        }
    }
    fileprivate func fetchAppsData(){
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        NetworkService.shared.fetchSocialApps { (apps, error) in
            if let error = error {
                print("Fetch SocailApps failed:\(error)")
                return
            }
            self.socialApps = apps ?? []
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchEditorsChoiceGames { (feeds, error) in
            if let error = error {
                print("Fetch EditorsChoiceGames failed:\(error)")
                return
            }
            self.editorChoiceGames = feeds
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchTopGrossingApps { (feeds, error) in
            if let error = error {
                print("Fetch TopGrossingApps failed:\(error)")
                return
            }
            self.topGrossingApps = feeds
            dispatchGroup.leave()
        }
        
        dispatchGroup.enter()
        NetworkService.shared.fetchTopFreeGames { (feeds, error) in
            if let error = error {
                print("Fetch TopFreeGames failed:\(error)")
                return
            }
            self.topFreeGames = feeds
            dispatchGroup.leave()
        }
        dispatchGroup.notify(queue: .main) {
            self.collectionView.reloadData()
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return SectionType.allCases.count
        return 1
    }
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        let type = SectionType.allCases[section]
//        switch type {
//        case .TopSection:
//            return socialApps.count
//        case .EditorChoiceGames:
//            return editorChoiceGames?.feed.results.count ?? 0
//        case .TopGrossingApps:
//            return topGrossingApps?.feed.results.count ?? 0
//        case .TopFreeGames:
//            return topFreeGames?.feed.results.count ?? 0
//        }
//    }
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let type = SectionType.allCases[indexPath.section]
//
//        switch type {
//        case .TopSection:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppsPageHeaderCell.cellID, for: indexPath) as! AppsPageHeaderCell
//            cell.feed = socialApps[indexPath.item]
//            return cell
//        default:
//            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: multipleCellID, for: indexPath) as! AppsCategoryCell
//            if type == .EditorChoiceGames {
//                cell.feedResult = editorChoiceGames?.feed.results[indexPath.item]
//            } else if type == .TopGrossingApps {
//                cell.feedResult = topGrossingApps?.feed.results[indexPath.item]
//            } else {
//                cell.feedResult = topFreeGames?.feed.results[indexPath.item]
//            }
//            return cell
//        }
//
//    }
//    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        var id = ""
//        let type = SectionType.allCases[indexPath.section]
//        switch type {
//        case .TopSection:
//            id = socialApps[indexPath.item].id
//        case .EditorChoiceGames:
//            id = editorChoiceGames?.feed.results[indexPath.item].id ?? ""
//        case .TopGrossingApps:
//            id = topGrossingApps?.feed.results[indexPath.item].id ?? ""
//        case .TopFreeGames:
//            id = topFreeGames?.feed.results[indexPath.item].id ?? ""
//        }
//        let detailController = AppDetailController(appID: id)
//        navigationController?.pushViewController(detailController, animated: true)
//    }
//    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerID, for: indexPath) as! CompositionalSectionHeader
//        let type = SectionType.allCases[indexPath.section]
//        switch type {
//        case .EditorChoiceGames:
//            header.titleLabel.text = editorChoiceGames?.feed.title
//        case .TopGrossingApps:
//            header.titleLabel.text = topGrossingApps?.feed.title
//        case .TopFreeGames:
//            header.titleLabel.text = topFreeGames?.feed.title
//        default:
//            break//不做任何事必須使用break來結束switch block,然後繼續往下執行
//        }
//        return header
//    }
    enum SectionType: Int, CaseIterable {
        case TopSection
        case EditorChoiceGames
//        case TopGrossingApps
//        case TopFreeGames
    }
}
