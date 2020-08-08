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
    
    private let resultView = GameResultContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        print("ResultViewController Did Load")
        
        view.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
        }
    }
    
    func bind(reactor: ResultViewReactor) {
        // Action
        
        // State
        reactor.state.map { "💸\t" + String($0.game.cost) }
            .bind(to: resultView.costLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden }.count }
            .map { "🤦🏻‍♂️\t" + String($0) }
            .bind(to: resultView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
            
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden } }
            .bind(to: resultView.playerTableView.rx.items(cellIdentifier: PlayerTableViewCell.reuseIdentifier, cellType: PlayerTableViewCell.self)) { indexPath, player, cell in
                cell.setup(title: "\(player.name)\t\(player.cost)ㅋㅋ")
        }
        .disposed(by: disposeBag)
        print("Binded ResultViewReactor")
        dump(reactor.currentState.game)
    }
}

class GameResultContainerView: UIView {
    let costLabel = UILabel().then {
        $0.text = "💸"
    }
    let playerCountLabel = UILabel().then {
        $0.text = "🤦🏻‍♂️"
    }
    let playerTableView = UITableView().then {
        $0.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
    }
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .gray
        
        addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(10)
        }
        
        addSubview(playerCountLabel)
        playerCountLabel.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.top.equalTo(costLabel.snp.bottom).offset(10)
        }
        
        addSubview(playerTableView)
        playerTableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(playerCountLabel.snp.bottom).offset(15)
            make.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
