//
//  HomePagerViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/08.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class HomePagerViewController: ButtonBarPagerTabStripViewController {
    private lazy var classicGameVC: ClassicGameViewController = {
        let classicGameVC = ClassicGameViewController()
        classicGameVC.reactor = HomeViewReactor(playStrategy: ClassicStrategy())
        return classicGameVC
    }()
    
    private lazy var ladderGameVC: LadderGameViewController = {
        let ladderGameVC = LadderGameViewController()
        ladderGameVC.reactor = HomeViewReactor(playStrategy: LadderStrategy())
        return ladderGameVC
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        settings.style.buttonBarBackgroundColor = UIColor.darkGray
        settings.style.selectedBarBackgroundColor = UIColor.primaryBlue
        settings.style.selectedBarHeight = 2
        settings.style.buttonBarItemBackgroundColor = UIColor.darkGray
        settings.style.buttonBarItemFont = UIFont.systemFont(ofSize: 17, weight: .semibold)
        settings.style.buttonBarHeight = 44
        settings.style.buttonBarLeftContentInset = 24
        settings.style.buttonBarRightContentInset = 24
        
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.green
        
        self.delegate = self
    }

    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        return [classicGameVC, ladderGameVC]
    }
}
