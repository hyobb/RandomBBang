//
//  ResultViewController.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/07/12.
//  Copyright © 2020 StudioX. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift

class ResultViewController: UIViewController, View {
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        print("ResultViewController Did Load")
        dump(reactor?.currentState.game)
        
        let game = reactor?.currentState.game
        
        let playerCount = game?.players.filter { !$0.isHidden }.count
        let cost = game?.cost
        let costDividedBy10 = (cost ?? 0) / 10
        var costs: [Int] = []
        
        var ten = 10
        
        
        guard let count = playerCount else { return }
        
        for i in 0..<count {
            if ten > 0 {
                if i == count - 1 {
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
            costs.append(cost! - sum)
        }
        
        costs.shuffle()
        print(costs)
        print(costs.reduce(0, +) == cost)
        
        game?.players.filter { !$0.isHidden }.forEach { player in
            player.cost = costs.popLast()!
        }
        
        dump(game?.players)
    }
    
    func bind(reactor: ResultViewReactor) {
        
    }
}
