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
//        homeNavigationViewController.setNavigationBarHidden(true, animated: false)
        
        let homeTabIcon = UITabBarItem(title: "홈", image: UIImage(named: "home_icon"), selectedImage: nil)
        homePagerContainerVC.tabBarItem = homeTabIcon
        
        let controllers = [homeNavigationViewController]
        self.viewControllers = controllers
        self.tabBar.isHidden = true
    }
}
