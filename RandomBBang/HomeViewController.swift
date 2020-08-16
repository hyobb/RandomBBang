//
//  HomeViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/06/15.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

import GoogleMobileAds

class HomeViewController: UIViewController, View{
    var disposeBag = DisposeBag()
    private let bannerView = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
			
    private let header = UIView()
    
    private let headerTitle = UILabel().then {
        $0.text = "랜덤빵"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }
    
    private let newGameContainerView = NewGameContainerView()
    
    private let startButton = UIButton().then {
        $0.setTitle("랜덤빵 시작하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = UIColor.primaryBlue
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow(opacity: 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
    
        bannerView.delegate = self
        bannerView.adUnitID = Helper.adUnitID
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        makeConstraints()
        setupFlowLayout()
    }
    
    func bind(reactor: HomeViewReactor) {
        // Action
        newGameContainerView.increaseButton.rx.tap
            .map { Reactor.Action.addPlayer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        newGameContainerView.decreaseButton.rx.tap
            .map { Reactor.Action.removePlayer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        newGameContainerView.costTextField.rx.text
            .distinctUntilChanged()
            .map { Reactor.Action.didChangeCost($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)

        newGameContainerView.costTextField.rx.text
            .orEmpty
            .distinctUntilChanged()
            .valueToCurrencyFormatted()
            .bind(to: newGameContainerView.costTextField.rx.text)
            .disposed(by: disposeBag)
        
        newGameContainerView.costTextField.rx.controlEvent([.editingDidEnd])
            .asObservable()
            .map { Reactor.Action.costEditingDidEnd }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.playerCount }
            .distinctUntilChanged()
            .map { "\($0) 명" }
            .bind(to: newGameContainerView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden } }
            .bind(to: newGameContainerView.playerCollectionView.rx.items(cellIdentifier: PlayerCollectionViewCell.reuseIdentifier, cellType: PlayerCollectionViewCell.self)) { indexPath, player, cell in
                cell.setup(title: player.name)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.playerCount }
            .map { $0 < 8 }
            .bind(to: newGameContainerView.increaseButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.playerCount }
            .map { $0 > 2 }
            .bind(to: newGameContainerView.decreaseButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.game.cost }
            .map { $0 > 0 }
            .bind(to: startButton.rx.isEnabled)
            .disposed(by: disposeBag)
            
        reactor.state.map { $0.game.cost }
            .map {
                if $0 == 0 {
                    return ""
                } else {
                    return Helper.getCurrencyString(from: $0)
                }
            }
            .bind(to: newGameContainerView.costTextField.rx.text)
            .disposed(by: disposeBag)
        
        
        // View
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                
                let timerVC = TimerViewController()
                timerVC.modalPresentationStyle = .overFullScreen
                self.present(timerVC, animated: true)
    
                let resultViewController = ResultViewController()
                resultViewController.reactor = ResultViewReactor(game: reactor.currentState.game, playerCount: reactor.currentState.playerCount)
                
                self.navigationController?.pushViewController(resultViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.8 , height: halfWidth * 0.3)
        newGameContainerView.playerCollectionView.collectionViewLayout = flowLayout
    }
    
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
        
        view.addSubview(newGameContainerView)
        newGameContainerView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(400)
        }
        
        newGameContainerView.playerCollectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier)
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.top.equalTo(newGameContainerView.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}

extension HomeViewController: GADBannerViewDelegate {
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


class NewGameContainerView: UIView {
    private let costContainerview = UIView()
    private let costIconLabel = UILabel().then {
        $0.text = "💸"
    }
    let costTextField = UITextField().then {
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.placeholder = "금액을 입력하세요"
        $0.backgroundColor = .none
        $0.textColor = .white
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        $0.keyboardType = .numberPad
        $0.addDoneButtonOnKeyboard()
    }
    
    private let playerContainerView = UIView()
    private let playerIconLabel = UILabel().then {
        $0.text = "🤦🏻‍♂️"
    }
    let playerCountLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
    }
    
    let increaseButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_add"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .darkGray
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow()
    }

    let decreaseButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_remove"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .darkGray
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow()
    }
    
    let playerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 48)
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width / 2.0, height: 40)
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }).then {
        $0.allowsSelection = true
        $0.backgroundColor = UIColor.primaryGray
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = UIColor.primaryGray
        self.addCornerRadius()
        self.addShadow()
        
        addSubview(costContainerview)
        costContainerview.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        costContainerview.addSubview(costIconLabel)
        costIconLabel.snp.makeConstraints { make in
            make.width.height.equalTo(costContainerview.snp.height)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        costContainerview.addSubview(costTextField)
        costTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
            make.left.equalTo(costIconLabel.snp.right).offset(12)
        }
        costTextField.addBottomBorder()
        
        addSubview(playerContainerView)
        playerContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalTo(costContainerview.snp.bottom).offset(6)
            make.centerX.equalToSuperview()
        }
        
        playerContainerView.addSubview(playerIconLabel)
        playerIconLabel.snp.makeConstraints { make in
            make.width.height.equalTo(playerContainerView.snp.height)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        playerContainerView.addSubview(playerCountLabel)
        playerCountLabel.snp.makeConstraints { make in
            make.width.height.equalTo(playerContainerView.snp.height)
            make.left.equalTo(playerIconLabel.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        playerContainerView.addSubview(increaseButton)
        increaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.width.height.equalTo(30)
        }
        
        playerContainerView.addSubview(decreaseButton)
        decreaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(52)
            make.width.height.equalTo(30)
        }
        
        
        addSubview(playerCollectionView)
        playerCollectionView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(playerContainerView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height, width: self.frame.size.width, height: 2)
        bottomLine.backgroundColor = UIColor.lightGray.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
        layer.masksToBounds = false
    }
    
    @IBInspectable var doneAccessory: Bool{
        get{
            return self.doneAccessory
        }
        set (hasDone) {
            if hasDone{
                addDoneButtonOnKeyboard()
            }
        }
    }

    func addDoneButtonOnKeyboard() {
        let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50))
        doneToolbar.barStyle = .default
        
        let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let done: UIBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(self.doneButtonAction))
        
        let items = [flexSpace, done]
        doneToolbar.items = items
        doneToolbar.sizeToFit()
        
        self.inputAccessoryView = doneToolbar
    }
    
    @objc func doneButtonAction() {
        self.resignFirstResponder()
    }
}

extension UIView {
    func addShadow(opacity: Float = 0.7) {
        layer.shadowOpacity = opacity
        layer.shadowRadius = 10
        layer.masksToBounds = false
    }
    
    func addCornerRadius(corners: CACornerMask = [.layerMaxXMaxYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMinXMinYCorner], cornerRadius: CGFloat = 15) {
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corners
        clipsToBounds = true
    }
}
