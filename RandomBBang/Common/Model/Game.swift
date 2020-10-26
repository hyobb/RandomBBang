//
//  GameViewModel.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/11.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

struct Game: Identifiable {
    var id: String
    var cost: Int
    var targetCount: Int
    var players: [Player]
    var type: PlayType
    var createdAt: Date
    
    init(
        id: String = UUID().uuidString,
        cost: Int,
        targetCount: Int,
        players: [Player],
        type: PlayType,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.cost = cost
        self.targetCount = targetCount
        self.players = players
        self.type = type
        self.createdAt = createdAt
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
        playStrategy.play(gameVM: self)
    }
    
    func getResultTitle() -> String {
        playStrategy.getResultTitle(gameVM: self)
    }
}

protocol ViewModel {
    
}

class GameViewModel: Gamable {
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
    
    func toGame() -> Game {
        let players = self.players.filter { !$0.isHidden }
        return Game(cost: cost, targetCount: targetCount, players: players, type: playStrategy.type)
    }
}

class GameListCellViewModel {
    let game: Game
    var date: String {
        let createdAt = game.createdAt
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "M월 d일"
        
        return dateFormatter.string(from: createdAt)
    }
    
    var type: String {
        switch game.type {
        case .classic:
            return "랜덤빵"
        case .ladder:
            return "사다리"
        }
    }
    
    var resultMessage: String {
        switch game.type {
        case .classic:
            return cost
        case .ladder:
            return targetCount
        }
    }
    var targetCount: String {
        return "🎯\(game.targetCount)명"
    }
    
    var cost: String {
        return "💸 \(Helper.getCurrencyString(from: game.cost))"
    }
    
    var playerCount: String {
        return "🤦🏻‍♂️\(game.players.count)명"
    }
    
    
    init(game: Game) {
        self.game = game
    }
}
