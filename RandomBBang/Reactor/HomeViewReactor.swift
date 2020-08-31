//
//  HomeViewReactor.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/06/15.
//  Copyright © 2020 StudioX. All rights reserved.
//

import ReactorKit
import RxCocoa
import RxSwift

class HomeViewReactor: Reactor {
    enum Action {
        case addPlayer
        case removePlayer
        case didChangeCost(String?)
        case costEditingDidEnd
    }

    enum Mutation {
        case increasePlayerCount
        case decreasePlayerCount
        case setGameCost(Int)
        case ceilGameCost
    }

    struct State {
        var playerCount: Int
        var game: Game
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(
            playerCount: 4,
            game: Game()
        )
    }
    
    func mutate(action: HomeViewReactor.Action) -> Observable<HomeViewReactor.Mutation> {
        switch action {
        case .addPlayer:
            return Observable.just(Mutation.increasePlayerCount)
        case .removePlayer:
            return Observable.just(Mutation.decreasePlayerCount)
        case .didChangeCost(let string):
            guard let costString = string, let cost = Helper.getIntValue(from: costString) else { return .empty() }
            return Observable.just(Mutation.setGameCost(cost))
        case .costEditingDidEnd:
            return Observable.just(Mutation.ceilGameCost)
        }
    }

    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutation) -> HomeViewReactor.State {
        var newState = state
        
        switch mutation {
        case .increasePlayerCount:
            guard newState.playerCount < 8 else { return newState }
            
            newState.playerCount += 1
            for (index, player) in newState.game.players.enumerated() {
                if index < newState.playerCount {
                    player.isHidden = false
                } else {
                    player.isHidden = true
                }
            }
        case .decreasePlayerCount:
            guard newState.playerCount > 2 else { return newState }
            
            newState.playerCount -= 1
            for (index, player) in newState.game.players.enumerated() {
                if index < newState.playerCount {
                    player.isHidden = false
                } else {
                    player.isHidden = true
                }
            }
        case .setGameCost(let cost):
            newState.game.cost = cost
        case .ceilGameCost:
            newState.game.cost = Int(ceil(Double(newState.game.cost) / Helper.ceilScale) * Helper.ceilScale)
        }
        
        return newState
    }
}
