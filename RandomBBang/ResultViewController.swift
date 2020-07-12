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
    }
    
    func bind(reactor: ResultViewReactor) {
        
    }
}
