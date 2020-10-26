//
//  StorableGame.swift
//  RandomBBang
//
//  Created by 류효광 on 2020/09/27.
//  Copyright © 2020 StudioX. All rights reserved.
//

import Foundation
import RealmSwift

extension Game: Entity {
    private var storableGame: StorableGame {
        let realmGame = StorableGame()
        realmGame.uuid = id
        realmGame.cost = cost
        realmGame.targetCount = targetCount
        realmGame.type = type.rawValue
        realmGame.createdAt = createdAt
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        if let data = try? encoder.encode(players), let jsonString = String(data: data, encoding: .utf8) {
            realmGame.players = jsonString
        }
        
        return realmGame
    }
    
    func toStorable() -> StorableGame {
        return storableGame
    }
}

class StorableGame: Object, Storable {
    @objc dynamic var uuid = ""
    @objc dynamic var cost: Int = 0
    @objc dynamic var targetCount: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var players: String = ""
    @objc dynamic var createdAt: Date = Date()
    
    override static func primaryKey() -> String? {
        return "uuid"
    }
    
    var model: Game {
        get {
            let decoder = JSONDecoder()
            let playerList = try! decoder.decode(PlayerList.self, from: players.data(using: .utf8)!)
            
            return Game(
                id: uuid,
                cost: cost,
                targetCount: targetCount,
                players: playerList,
                type: PlayType(rawValue: type)!,
                createdAt: createdAt
            )
        }
    }
}
