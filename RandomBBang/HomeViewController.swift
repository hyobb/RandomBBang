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

class HomeViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    private let header = UIView()
    
    private let headerTitle = UILabel().then {
        $0.text = "랜덤빵"
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 34.0, weight: .bold)
    }
    
    private let newGameContainerView = NewGameContainerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(header)
        header.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.centerX.width.equalToSuperview()
            make.height.equalTo(24.0)
        }
        
        header.addSubview(headerTitle)
        headerTitle.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10.0)
        }
        
        view.addSubview(newGameContainerView)
        newGameContainerView.snp.makeConstraints { make in
            make.top.equalTo(header.snp.bottom)
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().inset(24)
        }
        
//        newGameContainerView.playerCollectionView.dataSource = self
//        newGameContainerView.playerCollectionView.delegate = self
        newGameContainerView.playerCollectionView.register(PlayerCollectionViewCell.self, forCellWithReuseIdentifier: PlayerCollectionViewCell.reuseIdentifier)
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
        
        
        
        // State
        
        reactor.state.map { $0.playerCount }
            .distinctUntilChanged()
            .map { "\($0)" }
            .bind(to: newGameContainerView.playerCountLabel.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state.map { $0.game.players }
            .bind(to: newGameContainerView.playerCollectionView.rx.items(cellIdentifier: PlayerCollectionViewCell.reuseIdentifier, cellType: PlayerCollectionViewCell.self)) { indexPath, player, cell in
                cell.setup(title: player.name)
            }
            .disposed(by: disposeBag)
    }
}

extension HomeViewController {
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 5
//    }
    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(PlayerCollectionViewCell.self), for: indexPath) as! PlayerCollectionViewCell
//        cell.setup(title: "\(indexPath.row)")
//
//        return cell
//    }
    
    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 2
        flowLayout.itemSize = CGSize(width: halfWidth * 0.8 , height: halfWidth * 0.8)
        newGameContainerView.playerCollectionView.collectionViewLayout = flowLayout
    }
}


class NewGameContainerView: UIView {
    private let costContainerview = UIView().then {
        $0.backgroundColor = .red
    }
    private let costIconLabel = UILabel().then {
        $0.text = "💸"
    }
    private let costTextField = UITextField().then {
        $0.backgroundColor = .none
        $0.frame = CGRect(x: 0, y: 0, width: 200, height: 24)
        $0.keyboardType = .numberPad
    }
    
    private let playerContainerView = UIView().then {
        $0.backgroundColor = .red
    }
    private let playerIconLabel = UILabel().then {
        $0.text = "🤦🏻‍♂️"
    }
    let playerCountLabel = UILabel().then {
        $0.textColor = .white
    }
    
    let increaseButton = UIButton().then {
        $0.setTitle("+", for: .normal)
        $0.backgroundColor = .white
        $0.setTitleColor(.darkGray, for: .normal)
        $0.titleLabel?.textColor = .darkGray
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }

    let decreaseButton = UIButton().then {
        $0.setTitle("-", for: .normal)
        $0.setTitleColor(.darkGray, for: .normal)
        $0.backgroundColor = .white
        $0.titleLabel?.textColor = .darkGray
        $0.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
    }
    
    let playerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
        $0.headerReferenceSize = CGSize(width: UIScreen.main.bounds.width, height: 48)
        $0.scrollDirection = .vertical
        $0.itemSize = CGSize(width: UIScreen.main.bounds.width / 2.0, height: 40)
        $0.minimumInteritemSpacing = 0
        $0.minimumLineSpacing = 0
    }).then {
        $0.allowsSelection = true
        $0.backgroundColor = UIColor.white
    }
    
    private let startButton = UIButton()
    
    init() {
        super.init(frame: .zero)
        
        self.backgroundColor = .gray
        
        self.snp.makeConstraints { make in
            make.height.equalTo(500)
        }
        
        addSubview(costContainerview)
        costContainerview.snp.makeConstraints { make in
            make.width.equalToSuperview()
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
//            make.width.lessThanOrEqualTo(costContainerview.snp.width).offset(60)
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
//            make.height.equalToSuperview().inset(6)
            make.left.equalTo(costIconLabel.snp.right).offset(12)
        }
        costTextField.addBottomBorder()
        
        addSubview(playerContainerView)
        playerContainerView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(36)
            make.top.equalTo(costContainerview.snp.bottom).offset(6)
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
        }
        
        playerContainerView.addSubview(decreaseButton)
        decreaseButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(48)
        }
        
        
        addSubview(playerCollectionView)
        playerCollectionView.snp.remakeConstraints {
            $0.width.centerX.equalToSuperview()
            $0.top.equalTo(playerContainerView.snp.bottom).offset(15)
            $0.bottom.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


extension UITextField {
    func addBottomBorder(){
        let bottomLine = CALayer()
        bottomLine.frame = CGRect(x: 0, y: self.frame.size.height - 5, width: self.frame.size.width, height: 5)
        bottomLine.backgroundColor = UIColor.blue.cgColor
        borderStyle = .none
        layer.addSublayer(bottomLine)
        layer.masksToBounds = false
    }
}
