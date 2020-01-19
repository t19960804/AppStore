//
//  MusicController.swift
//  AppStore
//
//  Created by t19960804 on 1/5/20.
//  Copyright © 2020 t19960804. All rights reserved.
//

import UIKit

class MusicController: BaseListController {
    var musicFeedsResult = [Result]()
    let requestLimit = 20
    var isPaginating = false//避免fetchMore期間,使用者上下快速滑動造成多次fetchMore
    var isShortOfData = false//避免無限的fetchMore
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView.register(TrackCell.self, forCellWithReuseIdentifier: TrackCell.cellID)
        collectionView.register(TrackLoadingFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: TrackLoadingFooter.footerID)
        fetchData()
    }
    fileprivate func fetchData(){
        let string = "https://itunes.apple.com/search?term=Backstreet&offset=0&limit=\(requestLimit)"
        NetworkService.shared.fetchMusicFeeds(urlString: string) { (result, error) in
            if let error = error {
                print("Fetch music feeds error:\(error)")
                return
            }
            self.musicFeedsResult = result?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return musicFeedsResult.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackCell.cellID, for: indexPath) as! TrackCell
        cell.music = musicFeedsResult[indexPath.item]
        let needFetchMoreData = indexPath.item == musicFeedsResult.count - 1
        if needFetchMoreData && !isPaginating && !isShortOfData{
            isPaginating = true
            fetchMoreData()
        }
        return cell
    }
    //viewDiaload做fetch,陣列的筆數為20筆
    //每次fetch陣列會多20筆(offset為資料request的起始點)
    fileprivate func fetchMoreData(){
        let string = "https://itunes.apple.com/search?term=Backstreet&offset=\(musicFeedsResult.count)&limit=\(requestLimit)"
        NetworkService.shared.fetchMusicFeeds(urlString: string) { (result, error) in
            if let error = error {
                print("Fetch music feeds error:\(error)")
                return
            }
            self.isShortOfData = result?.results.count == 0
            self.musicFeedsResult += result?.results ?? []
            //載入的速度太快,footer太快就消失,所以讓執行緒延遲兩秒
            sleep(2)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.isPaginating = false
            }
        }
    }
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: TrackLoadingFooter.footerID, for: indexPath) as! TrackLoadingFooter
        return footer
    }
    
}
extension MusicController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let height: CGFloat = isShortOfData ? 0 : 100
        return CGSize(width: view.frame.width, height: height)
    }
}
