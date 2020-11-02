//
//  LadderGameViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/09.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import XLPagerTabStrip

import GoogleMobileAds

class LadderGameViewController: GADBannerBaseViewController, View{
    var disposeBag = DisposeBag()
   
    private let newGameView = LadderGameView()
    private let resultViewController = ResultViewController()
    
    private let startButton = UIButton().then {
        $0.setTitle("사다리 시작하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = UIColor.primaryBlue
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow(opacity: 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.darkGray
        
        makeConstraints()
        setupFlowLayout()
    }
    
    func bind(reactor: HomeViewReactor) {
        // Action
        newGameView.increaseButton.rx.tap
            .map { Reactor.Action.addPlayer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    
        newGameView.decreaseButton.rx.tap
            .map { Reactor.Action.removePlayer }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        newGameView.increaseTargetButton.rx.tap
            .map { Reactor.Action.increaseTarget }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        newGameView.decreaseTargetButton.rx.tap
        .map { Reactor.Action.decreaseTarget }
        .bind(to: reactor.action)
        .disposed(by: disposeBag)
            
        
        // State
        reactor.state.map { $0.gameVM.playerCount }
            .distinctUntilChanged()
            .map { "\($0) 명" }
            .bind(to: newGameView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.players.filter { !$0.isHidden } }
            .bind(to: newGameView.playerCollectionView.rx.items(cellIdentifier: PlayerCollectionViewCell.reuseIdentifier, cellType: PlayerCollectionViewCell.self)) { indexPath, player, cell in
                cell.setup(title: player.name)
            }
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.playerCount < $0.gameVM.players.count }
            .bind(to: newGameView.increaseButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.playerCount > 2 }
            .bind(to: newGameView.decreaseButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.targetCount < $0.gameVM.playerCount }
            .bind(to: startButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.targetCount }
            .distinctUntilChanged()
            .map { "\($0) 명" }
            .bind(to: newGameView.targetCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.targetCount + 1 < $0.gameVM.playerCount }
            .bind(to: newGameView.increaseTargetButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.targetCount > 1 }
            .bind(to: newGameView.decreaseTargetButton.rx.isEnabled)
            .disposed(by: disposeBag)
            
        // View
        startButton.rx.tap
            .subscribe(onNext: { [weak self] in
                guard let `self` = self else { return }
                let currentState = reactor.currentState
                let gameVM = currentState.gameVM
                gameVM.play()
                
                try? currentState.gameRepository.insert(item: gameVM.toGame())
                
                self.resultViewController.reactor = ResultViewReactor(gameVM: gameVM)
                
                self.present(self.resultViewController.timerVC, animated: true)
                self.navigationController?.pushViewController(self.resultViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension LadderGameViewController: IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: PagerTabStripViewController) -> IndicatorInfo {
        return IndicatorInfo(title: "사다리")
    }
}


extension LadderGameViewController {
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.8 , height: halfWidth * 0.3)
        newGameView.playerCollectionView.collectionViewLayout = flowLayout
    }
    
    private func makeConstraints() {
        view.addSubview(newGameView)
        newGameView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(24)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(350)
        }
        
        newGameView.playerCollectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier)
        
        view.addSubview(startButton)
        startButton.snp.makeConstraints { make in
            make.top.equalTo(newGameView.snp.bottom).offset(20)
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.centerX.equalToSuperview()
        }
    }
}
