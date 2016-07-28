//
//  GameTabBar.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/28/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameTabBar: Control {
    
    enum states {
        case research
        case mission
        case battle
        case factory
        case hangar
    }
    
    var state = states.battle
    
    var buttonResearch:Button!
    var buttonMission:Button!
    var buttonMothership:Button!
    var buttonFactory:Button!
    var buttonHangar:Button!
    
    init(state:states) {
        super.init(textureName: "tabBarBackground", x: -54, y: 512, xAlign: .center, yAlign: .up)
        
        switch state {
        case .research:
            self.buttonResearch = Button(textureName: "buttonResearch", x:54 ,y: 0)
            self.buttonMission = Button(textureName: "tabBarButton", x:166 ,y: 18)
            self.buttonMothership = Button(textureName: "tabBarButton", x:218 ,y: 18)
            self.buttonFactory = Button(textureName: "tabBarButton", x:270 ,y: 18)
            self.buttonHangar = Button(textureName: "tabBarButton", x:322 ,y: 18)
            break
        case .mission:
            self.buttonResearch = Button(textureName: "tabBarButton", x:68 ,y: 18)
            self.buttonMission = Button(textureName: "buttonMission", x:112 ,y: 0)
            self.buttonMothership = Button(textureName: "tabBarButton", x:222 ,y: 18)
            self.buttonFactory = Button(textureName: "tabBarButton", x:273 ,y: 18)
            self.buttonHangar = Button(textureName: "tabBarButton", x:323 ,y: 18)
            break
        case .battle:
            self.buttonResearch = Button(textureName: "tabBarButton", x:73 ,y: 18)
            self.buttonMission = Button(textureName: "tabBarButton", x:121 ,y: 18)
            self.buttonMothership = Button(textureName: "tabBarButtonBattle", x:169 ,y: 0)
            self.buttonFactory = Button(textureName: "tabBarButton", x:277 ,y: 18)
            self.buttonHangar = Button(textureName: "tabBarButton", x:326 ,y: 18)
            break
        case .factory:
            self.buttonResearch = Button(textureName: "tabBarButton", x:75 ,y: 18)
            self.buttonMission = Button(textureName: "tabBarButton", x:126 ,y: 18)
            self.buttonMothership = Button(textureName: "tabBarButton", x:176 ,y: 18)
            self.buttonFactory = Button(textureName: "buttonFactory", x:227 ,y: 0)
            self.buttonHangar = Button(textureName: "tabBarButton", x:330 ,y: 18)
            break
        case .hangar:
            self.buttonResearch = Button(textureName: "tabBarButton", x:77 ,y: 18)
            self.buttonMission = Button(textureName: "tabBarButton", x:129 ,y: 18)
            self.buttonMothership = Button(textureName: "tabBarButton", x:181 ,y: 18)
            self.buttonFactory = Button(textureName: "tabBarButton", x:233 ,y: 18)
            self.buttonHangar = Button(textureName: "buttonHangar", x:285 ,y: 0)
            break
        }
        
        self.addChild(self.buttonResearch)
        self.addChild(self.buttonMission)
        self.addChild(self.buttonMothership)
        self.addChild(self.buttonFactory)
        self.addChild(self.buttonHangar)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
