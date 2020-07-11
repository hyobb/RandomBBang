//
//  Game.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/11.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

struct Game {
    var cost: Int
    var players: [Player]
    
    init() {
        self.cost = 0
        self.players = [
            Player(name: "🦄", cost: 0, isHidden: false),
            Player(name: "🐷", cost: 0, isHidden: false),
            Player(name: "🐝", cost: 0, isHidden: false),
            Player(name: "🐥", cost: 0, isHidden: false),
            Player(name: "🦋", cost: 0, isHidden: true),
            Player(name: "🦀", cost: 0, isHidden: true),
            Player(name: "🐈", cost: 0, isHidden: true),
            Player(name: "🦕", cost: 0, isHidden: true)
        ]
    }
}

class Player {
    var name: String
    var cost: Int
    var isHidden: Bool
    
    init(name: String, cost: Int, isHidden: Bool) {
        self.name = name
        self.cost = cost
        self.isHidden = isHidden
    }
}
