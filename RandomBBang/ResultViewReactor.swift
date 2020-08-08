//
//  ResultViewReactor.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/12.
//  Copyright © 2020 StudioX. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class ResultViewReactor: Reactor {
    enum Action {
        
    }
    
    enum Mutation {
        
    }
    
    struct State {
        var game: Game
    }
    
    let initialState: State
    
    init(game: Game) {
        let playerCount = game.players.filter { !$0.isHidden }.count
        let cost = game.cost
        let costDividedBy10 = cost / 10
        var costs: [Int] = []
        
        var ten = 10
        
        for i in 0..<playerCount {
            if ten > 0 {
                if i == playerCount - 1 {
                    costs.append(ten * costDividedBy10)
                } else {
                    let num = Int.random(in: 0...ten)
                    ten = ten - num
                    costs.append(num * costDividedBy10)
                }
            } else {
                costs.append(0)
            }
            
            
            print(i)
        }
        
        
        
        let sum = costs.reduce(0, +)
        
        if sum != cost {
            let index = costs.lastIndex(of: 0)
            costs.remove(at: index!)
            costs.append(cost - sum)
        }
        
        costs.shuffle()
        print(costs)
        print(costs.reduce(0, +) == cost)
        
        game.players.filter { !$0.isHidden }.forEach { player in
            player.cost = costs.popLast()!
        }
        
        dump(game.players)
        
        self.initialState = State(game: game)
    }
}
