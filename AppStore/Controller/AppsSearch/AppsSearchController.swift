//
//  AppsSearchController.swift
//  AppStore
//
//  Created by t19960804 on 7/27/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsSearchController: UICollectionViewController {
    let cellID = "Cell"
    var results = [Result]()
    //參數searchResultsController,表示要秀出搜尋結果的Controller
    //但如果是在同一個Controller內則可傳nil
    let searchController = UISearchController(searchResultsController: nil)
    
    //有了下方init,初始化CollectionViewController時就不需要傳入collecitonViewLayout參數
    init() {
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.backgroundColor = .white
        self.collectionView!.register(SearchResultCell.self, forCellWithReuseIdentifier: cellID)
        setUpSearchController()
        fetchITunesData()
    }
    fileprivate func setUpSearchController(){
        navigationItem.searchController = searchController
        //search bar 固定顯示在畫面上
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    fileprivate func fetchITunesData(){
        NetworkService.shared.fetchDataFromITunes { [weak self] (results, error) in
            guard let self = self else { return }
            if let error = error {
                print("Fetch ITunes Data failed:\(error)")
                return
            }
            self.results = results
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as! SearchResultCell
        cell.result = results[indexPath.item]
        return cell
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AppsSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //調整Inset時,記得調整寬度
        return CGSize(width: self.view.frame.width, height: 380)
    }

}
