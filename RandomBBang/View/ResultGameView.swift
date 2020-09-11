//
//  ResultGameView.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/10.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit

class GameResultView: UIView {
    let headerStackView = UIStackView().then {
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
