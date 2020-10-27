//
//  GameListView.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/10/09.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation
import SwiftUI

class GameListViewHostingController: UIHostingController<GameListView> {

    override init(rootView: GameListView) {
        super.init(rootView: rootView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: GameListView())
    }
}

struct GameRow: View {
    var gameListCellVM: GameListCellViewModel
    
    init(game: Game) {
        self.gameListCellVM = GameListCellViewModel(game: game)
    }
    
    var body: some View {
        NavigationLink(destination: ResultView(game: gameListCellVM.game).edgesIgnoringSafeArea(.all)) {
            ZStack {
                HStack {
                    VStack {
                        Text(gameListCellVM.type)
                            .font(.body)
                            .fontWeight(.bold)
                        
                        Text(gameListCellVM.date)
                            .font(.caption)
                    }
                    
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text(gameListCellVM.playerCount)
                            .font(.subheadline)
                        Text(gameListCellVM.resultMessage)
                            .font(.subheadline)
                    }
                }
            }
        }
        .listRowBackground(Color(UIColor.darkGray))
    }
}


struct GameListView: View {
    private let gameRepo = AnyRepository<Game>()
    @State var games = [Game]()
    
    init() {
        UITableView.appearance().backgroundColor = UIColor.darkGray
    }
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    ForEach(games) { game in
                        GameRow(game: game)
                    }
                }
                
            }
            .navigationBarTitle("기록")
        }
        .onAppear {
            UITableView.appearance().separatorStyle = .none
            games = gameRepo.getAll()
        }
    }
}

struct ResultView: UIViewControllerRepresentable {
    typealias UIViewControllerType = ResultViewController
    var gameVM: GameViewModel
    
    init(game: Game) {
        gameVM = game.toGameViewModel()
        UINavigationBar.appearance().backgroundColor = UIColor.darkGray
    }

    func makeUIViewController(context: Context) -> ResultViewController {
        let resultVC = ResultViewController()
        resultVC.navigationController?.setNavigationBarHidden(true, animated: false)
        resultVC.reactor = ResultViewReactor(gameVM: self.gameVM)
        
        return resultVC
    }
    
    func updateUIViewController(_ uiViewController: ResultViewController, context: Context) {
        
    }
}
