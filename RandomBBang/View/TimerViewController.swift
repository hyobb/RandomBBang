//
//  TimerViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/08/14.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import RxSwift
import Motion

import GoogleMobileAds

class TimerViewController: GADBannerBaseViewController {
    var disposeBag: DisposeBag! = DisposeBag()
    
    private let counterLabel = UILabel().then {
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    private let timerSecValue: Int = 5
    private let colors = [UIColor("#F299A9"), UIColor("#622BD9"), UIColor("#4886D9") ,UIColor("#F2BD1D"), UIColor("#F24822")]
    private let fontSizeMultiples = [1, 2, 4, 7, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(counterLabel)
        counterLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setTimer()
    }
    
    func setTimer() {
        view.backgroundColor = colors[0]
        counterLabel.text = "💀🤑🤡😱😜🤬\n싸우지 마세요!"
        counterLabel.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
        
        BehaviorSubject<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .bind { timePassed in
                if timePassed < 5 {
                    self.counterLabel.text = "\(self.timerSecValue - timePassed)"
                    self.counterLabel.font = UIFont.systemFont(ofSize: 34 *  CGFloat(self.fontSizeMultiples[timePassed]), weight: .semibold)
                    
                    self.view.animate(.background(color: self.colors[timePassed % 5]))
                } else {
                    self.dismiss(animated: true) {
                        self.disposeBag = nil
                        self.disposeBag = DisposeBag()
                    }
                }
        }
        .disposed(by: disposeBag)
    }
}
