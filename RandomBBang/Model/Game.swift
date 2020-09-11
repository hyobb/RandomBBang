//
//  Game.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/11.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

class Player {
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
}

protocol Gamable {
    var cost: Int { get set }
    var targetCount: Int { get set }
    var playerCount: Int { get set }
    var players: [Player] { get set }
    var playStrategy: PlayStrategy { get set }
    init(playStrategy: PlayStrategy)
    
    func play()
    func getResultTitle() -> String
}

extension Gamable {
    func play() {
        playStrategy.play(game: self)
    }
    
    func getResultTitle() -> String {
        playStrategy.getResultTitle(game: self)
    }
}

class Game: Gamable {
    var cost: Int
    var targetCount: Int
    var players: [Player]
    var playerCount: Int
    var playStrategy: PlayStrategy

    required init(
        playStrategy: PlayStrategy = ClassicStrategy()
    ) {
        self.cost = 0
        self.targetCount = 1
        self.playerCount = 4
        self.players = [
            Player(name: "🦄", cost: 0, isHidden: false),
            Player(name: "🐷", cost: 0, isHidden: false),
            Player(name: "🐝", cost: 0, isHidden: false),
            Player(name: "🐥", cost: 0, isHidden: false),
            Player(name: "🦋", cost: 0, isHidden: true),
            Player(name: "🦀", cost: 0, isHidden: true),
            Player(name: "🐈", cost: 0, isHidden: true),
            Player(name: "🦕", cost: 0, isHidden: true),
            Player(name: "🍎", cost: 0, isHidden: true),
            Player(name: "🍌", cost: 0, isHidden: true),
            Player(name: "🥝", cost: 0, isHidden: true),
            Player(name: "🍊", cost: 0, isHidden: true),
            Player(name: "🍋", cost: 0, isHidden: true),
            Player(name: "🍔", cost: 0, isHidden: true),
            Player(name: "🍰", cost: 0, isHidden: true),
            Player(name: "🍺", cost: 0, isHidden: true)
        ]
        self.playStrategy = playStrategy
    }
}

