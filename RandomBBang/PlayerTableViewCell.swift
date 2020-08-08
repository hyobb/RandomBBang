//
//  PlayerTableViewCell.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/08/08.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit
import SnapKit

class PlayerTableViewCell: UITableViewCell {
    static let reuseIdentifier = "PlayerTableViewCell"
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setup(title: String) {
        textLabel?.text = title
    }
}
