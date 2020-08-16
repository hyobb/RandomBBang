//
//  GADBannerBaseViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/08/16.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import GoogleMobileAds
import SnapKit

class GADBannerBaseViewController: UIViewController {
    private let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bannerView.delegate = self
        bannerView.adUnitID = Helper.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
    }
}

extension GADBannerBaseViewController: GADBannerViewDelegate {
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
