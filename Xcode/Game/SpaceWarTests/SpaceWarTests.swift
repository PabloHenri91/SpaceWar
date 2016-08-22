//
//  SpaceWarTests.swift
//  SpaceWarTests
//
//  Created by Pablo Henrique Bertaco on 8/10/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import XCTest
import SpriteKit
@testable import SpaceWar

class SpaceWarTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testResearchScene() {
        let scene = ResearchScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testMissionScene() {
        let scene = MissionScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testMothershipScene() {
        let scene = MothershipScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testFactoryScene() {
        let scene = FactoryScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testHangarScene() {
        let scene = HangarScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testBattleScene() {
        let scene = BattleScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testBattleTrainingScene() {
        let scene = BattleTrainingScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testChooseMissionScene() {
        let scene = ChooseMissionScene(missionSpaceship: MissionSpaceship(type: Int.random(MissionSpaceship.types.count), level: 1))
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testInviteFriendsScene() {
        let scene = InviteFriendsScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testLoadScene() {
        let scene = LoadScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
    func testSocialScene() {
        let scene = SocialScene()
        Control.gameScene.view?.presentScene(scene)
        scene.update(GameScene.currentTime)
    }
    
}
