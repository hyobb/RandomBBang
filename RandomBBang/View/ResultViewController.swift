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
import SnapKit
import Then
import RealmSwift

import GoogleMobileAds

class ResultViewController: GADBannerBaseViewController, View, UIGestureRecognizerDelegate {
    var disposeBag = DisposeBag()
    let timerVC = TimerViewController().then {
        $0.modalPresentationStyle = .overFullScreen
    }
    
    private let header = UIView()
    
    private let headerTitle = UILabel().then {
        $0.text = "결과"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }
    
    private let resultView = GameResultView()
    private let bottomButtonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 12
        $0.distribution = .fillEqually
    }
    private let replayButton = UIButton().then {
        $0.setTitle("다시하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = UIColor.primaryBlue
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow(opacity: 0.5)
    }
    private let shareButton = UIButton().then {
        $0.setTitle("공유하기", for: .normal)
        $0.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .semibold)
        $0.backgroundColor = UIColor.primaryBlue
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow(opacity: 0.5)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(Realm.Configuration.defaultConfiguration.fileURL!)

        view.backgroundColor = UIColor.darkGray
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        
        makeConstraints()
    }
    
    func bind(reactor: ResultViewReactor) {
        // Action
        shareButton.rx.tap
            .subscribe(onNext: {
                let resultString = reactor.currentState.gameVM.players
                                    .filter { !$0.isHidden }
                                    .map { "\($0.name) \t \(Helper.getCurrencyString(from: $0.cost))\n" }
                                    .reduce("", +)
                    
                let text = "💸🤦🏻‍♂️랜덤빵 결과🥳🤩\n" + resultString + Helper.appStoreUrl
                
                    
                let activityVC = UIActivityViewController(activityItems: [ text ], applicationActivities: nil)
                
                if UIDevice.current.userInterfaceIdiom == .pad, let popOver = activityVC.popoverPresentationController {
                    popOver.sourceView = self.shareButton
                }
                self.present(activityVC, animated: true)
            })
            .disposed(by: disposeBag)
        
        replayButton.rx.tap
            .do(onNext: {
                self.timerVC.setTimer()
                self.present(self.timerVC, animated: true)
            })
            .delay(.seconds(3), scheduler: MainScheduler.instance)
            .map { Reactor.Action.replay }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        // State
        reactor.state.map { $0.gameVM.getResultTitle() }
            .bind(to: resultView.costLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.gameVM.players.filter { !$0.isHidden }.count }
            .map { "🤦🏻‍♂️\t\t\($0) 명" }
            .bind(to: resultView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
            
        
        reactor.state.map { $0.gameVM.players.filter { !$0.isHidden } }
            .bind(to: resultView.playerTableView.rx.items(cellIdentifier: PlayerTableViewCell.reuseIdentifier, cellType: PlayerTableViewCell.self)) { indexPath, player, cell in
                var title: String = player.name
                
                if let _ = reactor.currentState.gameVM.playStrategy as? ClassicStrategy {
                    if player.cost == 0 {
                        title += "\t\t통과\tㅎㅎ!"
                    } else {
                        title += "\t\t\(Helper.getCurrencyString(from: player.cost))\tㅋㅋ!"
                    }
                } else {
                    title += player.isSelected ? "\t\t🎯 ㅋㅋ!" : "\t\t통과\tㅎㅎ!"
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
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
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
        
        bottomButtonStackView.addArrangedSubview(replayButton)
        bottomButtonStackView.addArrangedSubview(shareButton)
        view.addSubview(bottomButtonStackView)
        bottomButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        if let reactor = reactor, reactor.currentState.gameVM.playerCount > 8 {
            resultView.playerTableView.snp.remakeConstraints { make in
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-138)
                make.width.centerX.equalToSuperview()
                make.top.equalTo(resultView.headerStackView.snp.bottom).offset(15)
            }
        }
    }
}
