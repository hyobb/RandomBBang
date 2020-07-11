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
            Player(name: "🦄", cost: 0),
            Player(name: "🐷", cost: 0),
            Player(name: "🐝", cost: 0),
            Player(name: "🐥", cost: 0),
            Player(name: "🦋", cost: 0),
            Player(name: "🦀", cost: 0),
            Player(name: "🐈", cost: 0),
            Player(name: "🦕", cost: 0)
        ]
    }
}

struct Player {
    var name: String
    var cost: Int
}
