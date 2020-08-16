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

class TimerViewController: UIViewController {
    var disposeBag: DisposeBag! = DisposeBag()
    private let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
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
    
        bannerView.delegate = self
        bannerView.adUnitID = Helper.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
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

extension TimerViewController: GADBannerViewDelegate {
    func addBannerViewToView(_ bannerView: GADBannerView) {
        bannerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(bannerView)
        if #available(iOS 11.0, *) {
            // In iOS 11, we need to constrain the view to the safe area.
            positionBannerViewFullWidthAtBottomOfSafeArea(bannerView)
        }
        else {
            // In lower iOS versions, safe area is not available so we use
            // bottom layout guide and view edges.
            positionBannerViewFullWidthAtBottomOfView(bannerView)
        }
    }
    
    // MARK: - view positioning
    @available (iOS 11, *)
    func positionBannerViewFullWidthAtBottomOfSafeArea(_ bannerView: UIView) {
        bannerView.snp.makeConstraints { make in
            make.left.right.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func positionBannerViewFullWidthAtBottomOfView(_ bannerView: UIView) {
        view.snp.remakeConstraints { make in
            make.leading.trailing.equalTo(bannerView)
            make.bottom.equalTo(bannerView.snp.top)
        }
    }
    
    /// Tells the delegate an ad request loaded an ad.
    func adViewDidReceiveAd(_ bannerView: GADBannerView) {
        print("adViewDidReceiveAd")
        addBannerViewToView(bannerView)
    }
    
    /// Tells the delegate an ad request failed.
    func adView(_ bannerView: GADBannerView,
                didFailToReceiveAdWithError error: GADRequestError) {
        print("adView:didFailToReceiveAdWithError: \(error.localizedDescription)")
    }
    
    /// Tells the delegate that a full-screen view will be presented in response
    /// to the user clicking on an ad.
    func adViewWillPresentScreen(_ bannerView: GADBannerView) {
        print("adViewWillPresentScreen")
    }
    
    /// Tells the delegate that the full-screen view will be dismissed.
    func adViewWillDismissScreen(_ bannerView: GADBannerView) {
        print("adViewWillDismissScreen")
    }
    
    /// Tells the delegate that the full-screen view has been dismissed.
    func adViewDidDismissScreen(_ bannerView: GADBannerView) {
        print("adViewDidDismissScreen")
    }
    
    /// Tells the delegate that a user click will open another app (such as
    /// the App Store), backgrounding the current app.
    func adViewWillLeaveApplication(_ bannerView: GADBannerView) {
        print("adViewWillLeaveApplication")
    }
}
