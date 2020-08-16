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

class ResultViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
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
        print("Binded ResultViewReactor")
        dump(reactor.currentState.game)
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
