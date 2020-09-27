//
//  RandomBBangTests.swift
//  RandomBBangTests
//
//  Created by 류효광 on 2020/09/10.
//  Copyright © 2020 StudioX. All rights reserved.
//

import XCTest
@testable import RandomBBang

class RandomBBangTests: XCTestCase {
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testClassicStrategePlay() {
        // given
        let playerCount = 5
        let cost = 100_000
        let gameVM = GameViewModel(playStrategy: ClassicStrategy())
        gameVM.playerCount = playerCount
        gameVM.cost = cost
        
        // when
        gameVM.play()
        
        // then
        XCTAssertLessThan(gameVM.players.filter({ (p: Player) -> Bool in
            return !p.isHidden
            }).count, playerCount)
        XCTAssertEqual(cost, gameVM.players.reduce(0, { (sum: Int, p: Player) -> Int in
            return sum + p.cost
        }))
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
}
