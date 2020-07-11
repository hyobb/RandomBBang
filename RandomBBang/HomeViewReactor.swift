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
    }

    enum Mutation {
        case increasePlayerCount
        case decreasePlayerCount
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
        }
    }

    func reduce(state: HomeViewReactor.State, mutation: HomeViewReactor.Mutation) -> HomeViewReactor.State {
        var newState = state
        
        switch mutation {
        case .increasePlayerCount:
            newState.playerCount += 1
        case .decreasePlayerCount:
            newState.playerCount -= 1
        }

        return newState
    }
}
