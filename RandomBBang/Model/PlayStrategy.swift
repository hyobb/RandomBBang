//
//  PlayStrategy.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/10.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

protocol PlayStrategy {
    func play(game: Gamable)
    func getResultTitle(game: Gamable) -> String
}

class ClassicStrategy: PlayStrategy {
    func play(game: Gamable) {
        let playerCount = game.playerCount
        let cost = game.cost
        let costDividedBy10 = cost / 10
        var costs: [Int] = []
        
        var ten = 10
        
        for i in 0..<playerCount {
            if ten > 0 {
                if i == playerCount - 1 {
                    costs.append(ten * costDividedBy10)
                } else {
                    let num = Int.random(in: 1...min(ten, 5))
                    ten = ten - num
                    costs.append(num * costDividedBy10)
                }
            } else {
                costs.append(0)
            }
        }
        
        let sum = costs.reduce(0, +)
        
        if sum != cost {
            let index = costs.lastIndex(of: 0)
            costs.remove(at: index!)
            costs.append(cost - sum)
        }
        
        costs.shuffle()
        
        game.players.filter { !$0.isHidden }.forEach { player in
            player.cost = costs.popLast()!
        }
        
        if !costs.isEmpty {
            game.players.last!.cost += costs.last!
        }
    }
    
    func getResultTitle(game: Gamable) -> String {
        return "💸\t\t\(Helper.getCurrencyString(from: game.cost))"
    }
}

class LadderStrategy: PlayStrategy {
    func play(game: Gamable) {
        var selections: [Bool] = []
        let playerCount = game.playerCount
        
        for i in 0..<playerCount {
            if i < game.targetCount {
                selections.append(true)
            } else {
                selections.append(false)
            }
        }
        selections.shuffle()
        
        for i in 0..<playerCount {
            game.players[i].isSelected = selections[i]
        }
    }
    
    func getResultTitle(game: Gamable) -> String {
        return "🎯\t\t\(game.targetCount) 명"
    }
}
