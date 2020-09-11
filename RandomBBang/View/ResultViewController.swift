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

import GoogleMobileAds

class ResultViewController: GADBannerBaseViewController, View {
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
    
    private let resultView = GameResultContainerView()
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
        
        view.backgroundColor = UIColor.darkGray
        
        makeConstraints()
    }
    
    func bind(reactor: ResultViewReactor) {
        // Action
        shareButton.rx.tap
            .subscribe(onNext: {
                let resultString = reactor.currentState.game.players
                                    .filter { !$0.isHidden }
                                    .map { "\($0.name) \t \(Helper.getCurrencyString(from: $0.cost))\n" }
                                    .reduce("", +)
                    
                let text = "💸🤦🏻‍♂️랜덤빵 결과🥳🤩\n" + resultString + Helper.appStoreUrl
                
                    
                let activityVC = UIActivityViewController(activityItems: [ text ], applicationActivities: nil)
                
                self.present(activityVC, animated: true)
                
            })
            .disposed(by: disposeBag)
        
        replayButton.rx.tap
            .do(onNext: {
                self.timerVC.setTimer()
                self.present(self.timerVC, animated: true)

            })
            .delay(.seconds(3), scheduler: SerialDispatchQueueScheduler(qos: .background))
            .map { Reactor.Action.replay }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
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
        
        bottomButtonStackView.addArrangedSubview(replayButton)
        bottomButtonStackView.addArrangedSubview(shareButton)
        view.addSubview(bottomButtonStackView)
        bottomButtonStackView.snp.makeConstraints { make in
            make.top.equalTo(resultView.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
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
