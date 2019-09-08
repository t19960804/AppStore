//
//  NetworkService.swift
//  AppStore
//
//  Created by t19960804 on 8/9/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import Foundation

class NetworkService {
    
    //Singleton
    static let shared = NetworkService()
    //只有這個類別可以初始化自己
    private init(){
        
    }
    //如果在Controller寫fetchDataFromITunes寫(),就不需要completion handler
    //因為URLSession.shared.dataTask本身就是async,可以在裡面直接處理
    //但這邊獨立出一個Network Layer,所以為了跟controller之間溝通,故透過completion handler回傳
    func fetchDataFromITunes(searchKeyWords: String, completion: @escaping ([Result],Error?) -> Void){
        let urlString = "https://itunes.apple.com/search?term=\(searchKeyWords)&entity=software"
        guard let url = URL(string: urlString) else { return }
        //為何需要.resume()?
        //URLSessionTask 物件想成產生一個下載或上傳資料的任務。但它只是產生任務，並不代表任務開始執行，要等呼叫 resume 才會開始執行
        //為何叫作.resume()而不是.start()?
        //Apple 提到剛產生的 task 將處在暫停的狀態(suspended state)，因此我們必須呼叫 resume() 來啟動它
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion([],error)
                return
            }
            guard let data = data else { return }
            do {
                //呼叫拋出函式時，必須加上try
                //do區塊執行想做的事，並利用 try 呼叫可能丟出錯誤的 function。再由 catch區塊處理錯誤
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                completion(searchResult.results, nil)
            } catch {
                completion([],error)
            }
        }
        task.resume()
    }
    //使用completion回傳資料要記得把Error考慮進去
    func fetchTopGrossingApps(completion: @escaping (AppsFeed?, Error?) -> Void){
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-grossing/all/25/explicit.json"
        fetchDataFromAPI(with: urlString, completion: completion)
    }
    func fetchEditorsChoiceGames(completion: @escaping (AppsFeed?, Error?) -> Void){
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/new-games-we-love/all/25/explicit.json"
        fetchDataFromAPI(with: urlString, completion: completion)
    }
    func fetchTopFreeGames(completion: @escaping (AppsFeed?, Error?) -> Void){
        let urlString = "https://rss.itunes.apple.com/api/v1/us/ios-apps/top-free/all/25/explicit.json"
        fetchDataFromAPI(with: urlString, completion: completion)
    }
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void){
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let data = data else { return }
            do {
                let feed = try JSONDecoder().decode([SocialApp].self, from: data)
                completion(feed, nil)
            } catch {
                completion(nil,error)
            }
        }
        task.resume()
    }
    fileprivate func fetchDataFromAPI(with urlString: String, completion: @escaping (AppsFeed?, Error?) -> Void){
        guard let url = URL(string: urlString) else { return }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                completion(nil,error)
                return
            }
            guard let data = data else { return }
            do {
                let gamesFeed = try JSONDecoder().decode(AppsFeed.self, from: data)
                completion(gamesFeed, nil)
            } catch {
                completion(nil,error)
            }
        }
        task.resume()
    }
}
