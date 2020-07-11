//
//  PlayerCollectionViewCell.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/07.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import SnapKit

class PlayerCollectionViewCell: UICollectionViewCell {
    private let textLabel = UILabel()
    
    static let reuseIdentifier = "PlayerCollectionViewCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(textLabel)
        textLabel.snp.makeConstraints { make in
           make.width.height.centerX.centerY.equalToSuperview()
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String) {
        textLabel.textColor = .brown
        textLabel.text = title
    }
}
