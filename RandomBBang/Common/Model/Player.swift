//
//  Player.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/27.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

class Player: Codable {
    var name: String
    var cost: Int
    var isSelected: Bool
    var isHidden: Bool
    
    init(name: String, cost: Int, isHidden: Bool) {
        self.name = name
        self.cost = cost
        self.isSelected = false
        self.isHidden = isHidden
    }
    
    enum Codingkeys: String, CodingKey {
        case name, cost, isSelected
    }
}

typealias PlayerList = [Player]
