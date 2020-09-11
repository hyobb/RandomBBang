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
        var game: Game
    }
    
    let initialState: State
    
    init(game: Game = Game()) {
        self.initialState = State(game: game)
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .replay:
            return Observable.just(Mutation.replayGame)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        let newState = state
        
        switch mutation {
        case .replayGame:
            newState.game.play()
        }
        
        return newState
    }
    
    deinit {
        print("Deinit ResultViewReactor")
    }
}
