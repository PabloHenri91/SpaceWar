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
        case mothership
        case factory
        case hangar
    }
    
    var state = states.mothership
    static var lastState = states.mothership
    
    var buttonResearch:Button!
    var buttonMission:Button!
    var buttonMothership:Button!
    var buttonFactory:Button!
    var buttonHangar:Button!
    
    var hover:Control!
    
    init(state:states) {
        super.init(textureName: "tabBarBackground", x: -54, y: 512, xAlign: .center, yAlign: .up)
        
        let top = 9
        let bottom = 9
        let left = 9
        let right = 9
        
        switch GameTabBar.lastState {
            
        case .research:
            self.buttonResearch = Button(textureName: "tabBarButton", x:84 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton", x:166 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton", x:218 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton", x:270 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton", x:322 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Control(textureName: "buttonResearch", x:54 ,y: 0)
            break
            
        case .mission:
            self.buttonResearch = Button(textureName: "tabBarButton", x:68 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton", x:142 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton", x:222 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton", x:273 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton", x:323 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Control(textureName: "buttonMission", x:112 ,y: 0)
            break
            
        case .mothership:
            self.buttonResearch = Button(textureName: "tabBarButton", x:73 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton", x:121 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton", x:199 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton", x:277 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton", x:326 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Control(textureName: "tabBarButtonBattle", x:169 ,y: 0)
            break
            
        case .factory:
            self.buttonResearch = Button(textureName: "tabBarButton", x:75 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton", x:126 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton", x:176 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton", x:257 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton", x:330 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Control(textureName: "buttonFactory", x:227 ,y: 0)
            break
            
        case .hangar:
            self.buttonResearch = Button(textureName: "tabBarButton", x:77 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton", x:129 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton", x:181 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton", x:233 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton", x:315 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Control(textureName: "buttonHangar", x:285 ,y: 0)
            break
        }
        
        if state != GameTabBar.lastState {
            
            let actionDuration = 0.25
            
            switch state {
                
            case .research:
                self.buttonResearch.runAction(SKAction.moveTo(self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:84 ,y: 18)), duration: actionDuration))
                self.buttonMission.runAction(SKAction.moveTo(self.buttonMission.getPositionWithScreenPosition(CGPoint(x:166 ,y: 18)), duration: actionDuration))
                self.buttonMothership.runAction(SKAction.moveTo(self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:218 ,y: 18)), duration: actionDuration))
                self.buttonFactory.runAction(SKAction.moveTo(self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:270 ,y: 18)), duration: actionDuration))
                self.buttonHangar.runAction(SKAction.moveTo(self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:322 ,y: 18)), duration: actionDuration))
                
                let control = Control(textureName: "buttonResearch")
                control.alpha = 0
                control.runAction(SKAction.fadeAlphaTo(1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.runAction(SKAction.moveTo(self.hover.getPositionWithScreenPosition(CGPoint(x:54 ,y: 0)), duration: actionDuration))
                
                break
                
            case .mission:
                self.buttonResearch.runAction(SKAction.moveTo(self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:68 ,y: 18)), duration: actionDuration))
                self.buttonMission.runAction(SKAction.moveTo(self.buttonMission.getPositionWithScreenPosition(CGPoint(x:142 ,y: 18)), duration: actionDuration))
                self.buttonMothership.runAction(SKAction.moveTo(self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:222 ,y: 18)), duration: actionDuration))
                self.buttonFactory.runAction(SKAction.moveTo(self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:273 ,y: 18)), duration: actionDuration))
                self.buttonHangar.runAction(SKAction.moveTo(self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:323 ,y: 18)), duration: actionDuration))
                
                let control = Control(textureName: "buttonMission")
                control.alpha = 0
                control.runAction(SKAction.fadeAlphaTo(1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.runAction(SKAction.moveTo(self.hover.getPositionWithScreenPosition(CGPoint(x:112 ,y: 0)), duration: actionDuration))
                
                break
                
            case .mothership:
                self.buttonResearch.runAction(SKAction.moveTo(self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:73 ,y: 18)), duration: actionDuration))
                self.buttonMission.runAction(SKAction.moveTo(self.buttonMission.getPositionWithScreenPosition(CGPoint(x:121 ,y: 18)), duration: actionDuration))
                self.buttonMothership.runAction(SKAction.moveTo(self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:199 ,y: 18)), duration: actionDuration))
                self.buttonFactory.runAction(SKAction.moveTo(self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:277 ,y: 18)), duration: actionDuration))
                self.buttonHangar.runAction(SKAction.moveTo(self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:326 ,y: 18)), duration: actionDuration))
                
                let control = Control(textureName: "tabBarButtonBattle")
                control.alpha = 0
                control.runAction(SKAction.fadeAlphaTo(1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.runAction(SKAction.moveTo(self.hover.getPositionWithScreenPosition(CGPoint(x:169 ,y: 0)), duration: actionDuration))
                
                break
                
            case .factory:
                self.buttonResearch.runAction(SKAction.moveTo(self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:75 ,y: 18)), duration: actionDuration))
                self.buttonMission.runAction(SKAction.moveTo(self.buttonMission.getPositionWithScreenPosition(CGPoint(x:126 ,y: 18)), duration: actionDuration))
                self.buttonMothership.runAction(SKAction.moveTo(self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:176 ,y: 18)), duration: actionDuration))
                self.buttonFactory.runAction(SKAction.moveTo(self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:257 ,y: 18)), duration: actionDuration))
                self.buttonHangar.runAction(SKAction.moveTo(self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:330 ,y: 18)), duration: actionDuration))
                
                let control = Control(textureName: "buttonFactory")
                control.alpha = 0
                control.runAction(SKAction.fadeAlphaTo(1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.runAction(SKAction.moveTo(self.hover.getPositionWithScreenPosition(CGPoint(x:227 ,y: 0)), duration: actionDuration))
                break
                
            case .hangar:
                self.buttonResearch.runAction(SKAction.moveTo(self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:77 ,y: 18)), duration: actionDuration))
                self.buttonMission.runAction(SKAction.moveTo(self.buttonMission.getPositionWithScreenPosition(CGPoint(x:129 ,y: 18)), duration: actionDuration))
                self.buttonMothership.runAction(SKAction.moveTo(self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:181 ,y: 18)), duration: actionDuration))
                self.buttonFactory.runAction(SKAction.moveTo(self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:233 ,y: 18)), duration: actionDuration))
                self.buttonHangar.runAction(SKAction.moveTo(self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:315 ,y: 18)), duration: actionDuration))
                
                let control = Control(textureName: "buttonHangar")
                control.alpha = 0
                control.runAction(SKAction.fadeAlphaTo(1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.runAction(SKAction.moveTo(self.hover.getPositionWithScreenPosition(CGPoint(x:285 ,y: 0)), duration: actionDuration))
                
                break
                
            }
            
            GameTabBar.lastState = state
        }
        
        self.addChild(self.buttonResearch)
        self.addChild(self.buttonMission)
        self.addChild(self.buttonMothership)
        self.addChild(self.buttonFactory)
        self.addChild(self.buttonHangar)
        
        self.addChild(self.hover)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
