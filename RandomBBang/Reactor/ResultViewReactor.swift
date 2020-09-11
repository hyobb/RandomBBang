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
        case replay
    }
    
    enum Mutation {
        case replayGame
    }
    
    struct State {
        var playerCount: Int
        var game: Game
    }
    
    let initialState: State
    
    init(game: Game, playerCount: Int) {
        let playerCount = playerCount
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
        
        self.initialState = State(playerCount: playerCount, game: game)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .replay:
            return Observable.just(Mutation.replayGame)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .replayGame:
            let game = playGame(game: newState.game, playerCount: newState.playerCount)
            newState.game = game
        }
        
        return newState
    }
        
    
        
    func playGame(game: Game, playerCount: Int) -> Game {
        let playerCount = playerCount
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
        
        return game
    }
}
