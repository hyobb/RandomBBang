//
//  NewGameView.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/10.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import SnapKit
import Then

class NewGameView: UIView {
    let playerContainerView = UIView()
    let playerIconLabel = UILabel().then {
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
        
        addSubview(playerContainerView)
        playerContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(10)
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
            make.height.equalTo(playerContainerView.snp.height)
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

class ClassicGameView: NewGameView {
    private let costContainerView = UIView()
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
    
    override init() {
        super.init()
        
        addSubview(costContainerView)
        costContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        costContainerView.addSubview(costIconLabel)
        costIconLabel.snp.makeConstraints { make in
            make.width.height.equalTo(costContainerView.snp.height)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        costContainerView.addSubview(costTextField)
        costTextField.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.centerY.equalToSuperview()
            make.left.equalTo(costIconLabel.snp.right).offset(12)
        }
        costTextField.addBottomBorder()
        
        playerContainerView.snp.remakeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalTo(costContainerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LadderGameView: NewGameView {
    let targetContainerView = UIView()
    let targetIconLabel = UILabel().then {
        $0.text = "🎯"
    }
    let targetCountLabel = UILabel().then {
        $0.textColor = .white
        $0.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        $0.text = "돈 낼 사람 수"
        $0.sizeToFit()
    }
    
    let increaseTargetButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_add"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .darkGray
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow()
    }

    let decreaseTargetButton = UIButton().then {
        $0.setImage(UIImage(named: "icon_remove"), for: .normal)
        $0.backgroundColor = .white
        $0.tintColor = .darkGray
        $0.addCornerRadius(cornerRadius: 10)
        $0.addShadow()
    }
    
    override init() {
        super.init()
        
        addSubview(targetContainerView)
        targetContainerView.snp.makeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalToSuperview().offset(10)
            make.centerX.equalToSuperview()
        }
        
        targetContainerView.addSubview(targetIconLabel)
        targetIconLabel.snp.makeConstraints { make in
            make.width.height.equalTo(targetContainerView.snp.height)
            make.left.equalToSuperview().offset(12)
            make.centerY.equalToSuperview()
        }
        
        targetContainerView.addSubview(targetCountLabel)
        targetCountLabel.snp.makeConstraints { make in
            make.height.equalTo(targetContainerView.snp.height)
            make.left.equalTo(targetIconLabel.snp.right).offset(12)
            make.centerY.equalToSuperview()
        }
        
        targetContainerView.addSubview(increaseTargetButton)
        increaseTargetButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(12)
            make.width.height.equalTo(30)
        }
        
        targetContainerView.addSubview(decreaseTargetButton)
        decreaseTargetButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(52)
            make.width.height.equalTo(30)
        }
        
        playerContainerView.snp.remakeConstraints { make in
            make.width.equalToSuperview().inset(20)
            make.height.equalTo(36)
            make.top.equalTo(targetContainerView.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
