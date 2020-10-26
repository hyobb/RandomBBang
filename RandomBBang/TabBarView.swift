//
//  TabBarView.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/06/15.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import SnapKit
import Then

class TabBarView: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homePagerVC = HomePagerViewController()
        let homePagerContainerVC = PagerContainerViewController(pagerVC: homePagerVC)
        let homeNavigationViewController = UINavigationController(rootViewController: homePagerContainerVC)
        
        let gameListView = GameListViewHostingController(rootView: GameListView())
        let listTabIcon = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        gameListView.tabBarItem = listTabIcon
//        homeNavigationViewController.setNavigationBarHidden(true, animated: false)
        
        let homeTabIcon = UITabBarItem(title: "홈", image: UIImage(named: "home_icon"), selectedImage: nil)
        homePagerContainerVC.tabBarItem = homeTabIcon
        
        let controllers = [homeNavigationViewController, gameListView]
        self.viewControllers = controllers
//        self.tabBar.isHidden = true
    }
}
