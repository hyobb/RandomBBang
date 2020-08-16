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

class TimerViewController: UIViewController {
    var disposeBag: DisposeBag! = DisposeBag()
    
    private let counterLabel = UILabel().then {
        $0.text = "💀🤑🤡😱😜🤬\n싸우지 마세요!"
        $0.numberOfLines = 0
        $0.textAlignment = .center
        $0.font = UIFont.systemFont(ofSize: 34, weight: .semibold)
    }
    private let timerSecValue: Int = 5
    private let colors = [UIColor("#F299A9"), UIColor("#622BD9"), UIColor("#4886D9") ,UIColor("#F2BD1D"), UIColor("#F24822")]
    private let fontSizeMultiples = [1, 2, 4, 7, 10]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colors[0]
    
        
        view.addSubview(counterLabel)
        counterLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
        }
        
        BehaviorSubject<Int>.interval(.seconds(1), scheduler: MainScheduler.asyncInstance)
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .bind { timePassed in
                if timePassed < 5 {
                    self.counterLabel.text = "\(self.timerSecValue - timePassed)"
                    self.counterLabel.font = UIFont.systemFont(ofSize: 34 *  CGFloat(self.fontSizeMultiples[timePassed]), weight: .semibold)
                    
//                    self.counterLabel.animate(.rotate(CGFloat(360 * timePassed)))
                    self.view.animate(.background(color: self.colors[timePassed % 5]))
                } else {
                    self.dismiss(animated: true) {
                        self.disposeBag = nil
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
