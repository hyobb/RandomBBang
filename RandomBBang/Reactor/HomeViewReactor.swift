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
import RealmSwift

class HomeViewReactor: Reactor {
    enum Action {
        case addPlayer
        case removePlayer
        case didChangeCost(String?)
        case costEditingDidEnd
        case increaseTarget
        case decreaseTarget
    }

    enum Mutation {
        case increasePlayerCount
        case decreasePlayerCount
        case setGameCost(Int)
        case ceilGameCost
        case increaseTargetCount
        case decreaseTargetCount
    }

    struct State {
        var gameVM: GameViewModel
    }
    
    let initialState: State
    
    init(playStrategy: PlayStrategy) {
        self.initialState = State(
            gameVM: GameViewModel(playStrategy: playStrategy)
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
        case .increaseTarget:
            return Observable.just(Mutation.increaseTargetCount)
        case .decreaseTarget:
            return Observable.just(Mutation.decreaseTargetCount)
        }
    }

    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutation) -> HomeViewReactor.State {
        let newState = state
        
        switch mutation {
        case .increasePlayerCount:
            guard newState.gameVM.playerCount < newState.gameVM.players.count else { return newState }
            
            newState.gameVM.playerCount += 1
            for (index, player) in newState.gameVM.players.enumerated() {
                if index < newState.gameVM.playerCount {
                    player.isHidden = false
                } else {
                    player.isHidden = true
                }
            }
        case .decreasePlayerCount:
            guard newState.gameVM.playerCount > 2 else { return newState }
            
            newState.gameVM.playerCount -= 1
            for (index, player) in newState.gameVM.players.enumerated() {
                if index < newState.gameVM.playerCount {
                    player.isHidden = false
                } else {
                    player.isHidden = true
                }
            }
        case .setGameCost(let cost):
            newState.gameVM.cost = cost
        case .ceilGameCost:
            newState.gameVM.cost = Int(ceil(Double(newState.gameVM.cost) / Helper.ceilScale) * Helper.ceilScale)
        case .increaseTargetCount:
            guard newState.gameVM.targetCount < newState.gameVM.playerCount else { return newState }
            newState.gameVM.targetCount += 1

        case .decreaseTargetCount:
            guard newState.gameVM.targetCount > 2 else { return newState }
            newState.gameVM.targetCount -= 1
        }
        
        return newState
    }
}
