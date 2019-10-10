//
//  AppsSearchController.swift
//  AppStore
//
//  Created by t19960804 on 7/27/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class AppsSearchController: BaseListController {
    var results = [Result]()
    //參數searchResultsController,表示要秀出搜尋結果的Controller
    //但如果是在同一個Controller內則可傳nil
    let searchController = UISearchController(searchResultsController: nil)
    var timer: Timer?
    
    let emptyResultLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "Please enter search keywords..."
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textAlignment = .center
        return lb
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        collectionView!.register(SearchResultCell.self, forCellWithReuseIdentifier: SearchResultCell.cellID)
        setUpSearchController()
        setUpConstraints()
    }
    fileprivate func setUpConstraints(){
        collectionView.addSubview(emptyResultLabel)
        emptyResultLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        emptyResultLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }
    fileprivate func setUpSearchController(){
        navigationItem.searchController = searchController
        //search bar 固定顯示在畫面上
        navigationItem.hidesSearchBarWhenScrolling = false
        //預設為true,當點擊searchController準備搜尋時,searchController的底層會變暗,false時不會變暗
        searchController.obscuresBackgroundDuringPresentation = false
        //若ViewController的definesPresentationContext為true,當searchController被“present"時,則只會在該ViewController上
        //而不是整個UINavigationController(因為有些頁面不需要searchController）
        definesPresentationContext = true
        searchController.searchBar.delegate = self
    }
    fileprivate func fetchITunesData(with keywords: String){
        NetworkService.shared.fetchDataFromITunes(searchKeyWords: keywords) { [weak self] (searchResult, error) in
            guard let self = self else { return }
            if let error = error {
                print("Fetch ITunes Data failed:\(error)")
                return
            }
            self.results = searchResult?.results ?? []
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        emptyResultLabel.isHidden = !results.isEmpty
        return results.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SearchResultCell.cellID, for: indexPath) as! SearchResultCell
        cell.result = results[indexPath.item]
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let id = String(results[indexPath.item].trackId)
        let detailController = AppDetailController(appID: id)
        navigationController?.pushViewController(detailController, animated: true)
    }
}

extension AppsSearchController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //調整Inset時,記得調整寬度
        return CGSize(width: self.view.frame.width, height: 380)
    }
}
extension AppsSearchController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        //當輸入速度過快時,會導致多次的fetch,進而畫面閃爍,所以這邊使用Timer做延遲
        //停止上一次的Timer
        timer?.invalidate()
        //重新初始化一個週期為0.5秒的Timer
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { [weak self] (_) in
            guard let self = self else { return }
            self.fetchITunesData(with: searchText)
        })
        
    }
}
