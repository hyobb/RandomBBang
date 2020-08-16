//
//  ResultViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/12.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

import GoogleMobileAds

class ResultViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
    
    private let header = UIView()
    
    private let headerTitle = UILabel().then {
        $0.text = "결과"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }
    
    private let resultView = GameResultContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        
        bannerView.delegate = self
        bannerView.adUnitID = Helper.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        makeConstraints()
    }
    
    func bind(reactor: ResultViewReactor) {
        // Action
        
        // State
        reactor.state.map { $0.game.cost }
            .map { "💸\t\t\(Helper.getCurrencyString(from: $0))" }
            .bind(to: resultView.costLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden }.count }
            .map { "🤦🏻‍♂️\t\t\($0) 명" }
            .bind(to: resultView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
            
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden } }
            .bind(to: resultView.playerTableView.rx.items(cellIdentifier: PlayerTableViewCell.reuseIdentifier, cellType: PlayerTableViewCell.self)) { indexPath, player, cell in
                var title: String
                if player.cost == 0 {
                    title = "\(player.name)\t\t통과\tㅎㅎ!"
                } else {
                    title = "\(player.name)\t\t\(Helper.getCurrencyString(from: player.cost))\tㅋㅋ!"
                }
                cell.setup(title: title)
        }
        .disposed(by: disposeBag)
    }
}

extension ResultViewController {
    private func makeConstraints() {
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.width.equalToSuperview()
            make.height.equalTo(44.0)
        }
        
        header.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(24)
        }

        view.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.bottom.equalTo(resultView.playerTableView.snp.bottom).offset(15)
        }
    }
}

extension ResultViewController: GADBannerViewDelegate {
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


class GameResultContainerView: UIView {
    private let headerStackView = UIStackView().then {
        $0.axis = .vertical
        $0.distribution = .fillEqually
        $0.alignment = .center
        $0.addBackground(color: UIColor.orange)
    }
    private let costContainerview = UIView()
    let costLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    private let playerContainerView = UIView()
    let playerCountLabel = UILabel().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    let playerTableView = UITableView().then {
        $0.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        $0.backgroundColor = UIColor.primaryGray
        $0.separatorStyle = .none
        $0.flashScrollIndicators()
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.primaryGray
        self.addCornerRadius()
        self.addShadow()
        
        addSubview(headerStackView)
        headerStackView.snp.makeConstraints { make in
            make.top.left.right.equalToSuperview()
            make.height.equalTo(80)
        }
        
        headerStackView.addArrangedSubview(costContainerview)
        headerStackView.addArrangedSubview(playerContainerView)
        
        costContainerview.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        costContainerview.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(150)
        }
        
        playerContainerView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
        }
        
        playerContainerView.addSubview(playerCountLabel)
        playerCountLabel.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.greaterThanOrEqualTo(150)
        }
        
        addSubview(playerTableView)
        playerTableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(headerStackView.snp.bottom).offset(15)
            make.height.equalTo(44 * 4 + 25)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIStackView {
    func addBackground(color: UIColor) {
        let subView = UIView(frame: bounds)
        subView.addCornerRadius(corners: [.layerMaxXMinYCorner, .layerMinXMinYCorner], cornerRadius: 15)
        subView.backgroundColor = color
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
    }
}
