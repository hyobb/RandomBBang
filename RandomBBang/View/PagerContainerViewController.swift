//
//  PagerContainerViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/09.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import XLPagerTabStrip

class PagerContainerViewController: UIViewController {
    private let pagerVC: PagerTabStripViewController
    
    init(pagerVC: PagerTabStripViewController) {
        self.pagerVC = pagerVC
        
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray

        addChild(pagerVC)
        pagerVC.didMove(toParent: self)
        view.addSubview(pagerVC.view)
        pagerVC.view.snp.remakeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.width.equalToSuperview()
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
    }
}
