//
//  PlayStrategy.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/10.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation

protocol PlayStrategy {
    var type: PlayType { get }
    func play(gameVM: Gamable)
    func getResultTitle(gameVM: Gamable) -> String
}
enum PlayType: String {
    case classic, ladder
}

class ClassicStrategy: PlayStrategy {
    var type: PlayType = .classic
    
    func play(gameVM: Gamable) {
        let playerCount = gameVM.playerCount
        let cost = gameVM.cost
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
        
        gameVM.players.filter { !$0.isHidden }.forEach { player in
            player.cost = costs.popLast()!
        }
        
        if !costs.isEmpty {
            gameVM.players.last!.cost += costs.last!
        }
    }
    
    func getResultTitle(gameVM: Gamable) -> String {
        return "💸\t\t\(Helper.getCurrencyString(from: gameVM.cost))"
    }
}

class LadderStrategy: PlayStrategy {
    let type: PlayType = .ladder
    
    func play(gameVM: Gamable) {
        var selections: [Bool] = []
        let playerCount = gameVM.playerCount
        
        for i in 0..<playerCount {
            if i < gameVM.targetCount {
                selections.append(true)
            } else {
                selections.append(false)
            }
        }
        selections.shuffle()
        
        for i in 0..<playerCount {
            gameVM.players[i].isSelected = selections[i]
        }
    }
    
    func getResultTitle(gameVM: Gamable) -> String {
        return "🎯\t\t\(gameVM.targetCount) 명"
    }
}
