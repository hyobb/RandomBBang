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

import RealmSwift

class ResultViewReactor: Reactor {
    enum Action {
        case replay
    }
    
    enum Mutation {
        case replayGame
    }
    
    struct State {
        var gameVM: GameViewModel
        let gameRepository: AnyRepository<Game>
    }
    
    let initialState: State
    
    init(gameVM: GameViewModel = GameViewModel()) {
        self.initialState = State(
            gameVM: gameVM,
            gameRepository: AnyRepository<Game>()
        )
        
        try? currentState.gameRepository.insert(item: currentState.gameVM.toGame())
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
            newState.gameVM.play()
            try? newState.gameRepository.insert(item: newState.gameVM.toGame())
        }
        
        return newState
    }
    
    deinit {
        print("Deinit ResultViewReactor")
    }
}
