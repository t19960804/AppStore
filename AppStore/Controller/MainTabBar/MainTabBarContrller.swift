//
//  MainTabBarContrller.swift
//  AppStore
//
//  Created by t19960804 on 7/27/19.
//  Copyright © 2019 t19960804. All rights reserved.
//

import UIKit

class MainTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let musicNavController = creatNavController(viewController: MusicController(), title: "Music", imageName: "music")
        let appNavController = creatNavController(viewController: AppsPageController(), title: "Apps", imageName: "apps")
        let searchNavController = creatNavController(viewController: AppsSearchController(), title: "Search", imageName: "search")
        let todayNavController = creatNavController(viewController: TodayController(), title: "Today", imageName: "today_icon")

        
        self.viewControllers = [musicNavController,
                                todayNavController,
                                searchNavController,
                                appNavController]
    }
    fileprivate func creatNavController(viewController: UIViewController, title: String, imageName: String) -> UINavigationController{
        //設定NanBar的title,不可以直接對UINavigationController設定,會無效
        //要對UINavigationController的rootViewController設定
        viewController.navigationItem.title = title
        //viewController.view.backgroundColor = .white
        let navController = UINavigationController(rootViewController: viewController)
        navController.tabBarItem.title = title
        navController.tabBarItem.image = UIImage(named: imageName)
        navController.navigationBar.prefersLargeTitles = true
        return navController
    }
}

//UITabBarController-重點
//透過viewControllers屬性控制要顯示的Controllers
//Controller底下有個tabBarItem屬性可以控制item(title / image)
