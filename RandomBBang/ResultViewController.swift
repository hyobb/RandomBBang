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
        
        view.backgroundColor = UIColor.darkGray
        
        
        resultView.playerTableView.snp.makeConstraints { make in
            make.height.equalTo(45 * (reactor?.currentState.playerCount ?? 4))
        }
        
        view.addSubview(resultView)
        resultView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
            make.bottom.equalTo(resultView.playerTableView.snp.bottom).offset(15)
        }
    }
    
    func bind(reactor: ResultViewReactor) {
        // Action
        
        // State
        reactor.state.map { String($0.game.cost) }
            .bind(to: resultView.costLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden }.count }
            .map { String($0) }
            .bind(to: resultView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
            
        
        reactor.state.map { $0.game.players.filter { !$0.isHidden } }
            .bind(to: resultView.playerTableView.rx.items(cellIdentifier: PlayerTableViewCell.reuseIdentifier, cellType: PlayerTableViewCell.self)) { indexPath, player, cell in
                print("\(indexPath)")
                cell.setup(title: "\(player.name)\t\(player.cost)ㅋㅋ")
        }
        .disposed(by: disposeBag)
        print("Binded ResultViewReactor")
        dump(reactor.currentState.game)
    }
}

//extension ResultViewController: UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        reactor
//    }
//}

class GameResultContainerView: UIView {
    private let costContainerview = UIView()
    private let costIconLabel = UILabel().then {
        $0.text = "💸"
    }
    let costLabel = UILabel()
    
    private let playerContainerView = UIView()
    private let playerIconLabel = UILabel().then {
        $0.text = "🤦🏻‍♂️"
    }
    let playerCountLabel = UILabel()
    
    let playerTableView = UITableView().then {
        $0.register(PlayerTableViewCell.self, forCellReuseIdentifier: PlayerTableViewCell.reuseIdentifier)
        $0.backgroundColor = UIColor.primaryGray
        $0.separatorStyle = .none
        $0.isScrollEnabled = false
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
        
        costContainerview.addSubview(costLabel)
        costLabel.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
            make.left.equalTo(costIconLabel.snp.right).offset(12)
        }
        
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
        
        addSubview(playerTableView)
        playerTableView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.top.equalTo(playerContainerView.snp.bottom).offset(15)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
