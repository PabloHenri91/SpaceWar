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
    
    var hover:Button!
    
    init(state:states) {
        super.init(textureName: "tabBarBackground", x: -54, y: 513, xAlign: .center, yAlign: .up)
        self.zPosition = 100
        
        let top = 9
        let bottom = 9
        let left = 9
        let right = 9
        
        let hoverTextFontName = GameFonts.fontName.museo1000
        let hoverTextFontSize = CGFloat(11)
        
        let hoverTextColor = SKColor.white
        let hoverTextShadowColor = SKColor(red: 0, green: 0, blue: 0, alpha: 20/100)
        
        let hoverTextOffset = CGPoint(x: 0, y: -9)
        
        let hoverTextShadowOffset = CGPoint(x: 0, y: -1)
        
        switch GameTabBar.lastState {
            
        case .research:
            self.buttonResearch = Button(textureName: "tabBarButton0", x:84 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton1", x:166 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton2", x:218 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton3", x:270 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton4", x:322 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Button(textureName: "buttonResearch", text: "Researches", fontSize: hoverTextFontSize, x:54 ,y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
            break
            
        case .mission:
            self.buttonResearch = Button(textureName: "tabBarButton0", x:68 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton1", x:142 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton2", x:222 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton3", x:273 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton4", x:323 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Button(textureName: "buttonMission", text: "Miners", fontSize: hoverTextFontSize, x: 112 ,y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
            break
            
        case .mothership:
            self.buttonResearch = Button(textureName: "tabBarButton0", x:73 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton1", x:121 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton2", x:199 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton3", x:277 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton4", x:326 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Button(textureName: "tabBarButtonBattle", text: "Battle", fontSize: hoverTextFontSize, x: 169 ,y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
            break
            
        case .factory:
            self.buttonResearch = Button(textureName: "tabBarButton0", x:75 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton1", x:126 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton2", x:176 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton3", x:257 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton4", x:330 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Button(textureName: "buttonFactory", text: "Factory", fontSize: hoverTextFontSize, x: 227, y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
            break
            
        case .hangar:
            self.buttonResearch = Button(textureName: "tabBarButton0", x:77 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMission = Button(textureName: "tabBarButton1", x:129 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonMothership = Button(textureName: "tabBarButton2", x:181 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonFactory = Button(textureName: "tabBarButton3", x:233 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            self.buttonHangar = Button(textureName: "tabBarButton4", x:315 ,y: 18, top: top, bottom: bottom, left: left, right: right)
            
            self.hover = Button(textureName: "buttonHangar", text: "Hangar", fontSize: hoverTextFontSize, x: 285, y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
            break
        }
        
        if state != GameTabBar.lastState {
            
            let actionDuration = 0.25
            
            switch state {
                
            case .research:
                self.buttonResearch.run(SKAction.move(to: self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:84 ,y: 18)), duration: actionDuration))
                self.buttonMission.run(SKAction.move(to: self.buttonMission.getPositionWithScreenPosition(CGPoint(x:166 ,y: 18)), duration: actionDuration))
                self.buttonMothership.run(SKAction.move(to: self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:218 ,y: 18)), duration: actionDuration))
                self.buttonFactory.run(SKAction.move(to: self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:270 ,y: 18)), duration: actionDuration))
                self.buttonHangar.run(SKAction.move(to: self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:322 ,y: 18)), duration: actionDuration))
                
                let control = Button(textureName: "buttonResearch", text: "Researches", fontSize: hoverTextFontSize, x:0 ,y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
                control.alpha = 0
                control.run(SKAction.fadeAlpha(to: 1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.run(SKAction.move(to: self.hover.getPositionWithScreenPosition(CGPoint(x:54 ,y: 0)), duration: actionDuration))
                
                break
                
            case .mission:
                self.buttonResearch.run(SKAction.move(to: self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:68 ,y: 18)), duration: actionDuration))
                self.buttonMission.run(SKAction.move(to: self.buttonMission.getPositionWithScreenPosition(CGPoint(x:142 ,y: 18)), duration: actionDuration))
                self.buttonMothership.run(SKAction.move(to: self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:222 ,y: 18)), duration: actionDuration))
                self.buttonFactory.run(SKAction.move(to: self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:273 ,y: 18)), duration: actionDuration))
                self.buttonHangar.run(SKAction.move(to: self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:323 ,y: 18)), duration: actionDuration))
                
                let control = Button(textureName: "buttonMission", text: "Miners", fontSize: hoverTextFontSize, x: 0 ,y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
                control.alpha = 0
                control.run(SKAction.fadeAlpha(to: 1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.run(SKAction.move(to: self.hover.getPositionWithScreenPosition(CGPoint(x:112 ,y: 0)), duration: actionDuration))
                
                break
                
            case .mothership:
                self.buttonResearch.run(SKAction.move(to: self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:73 ,y: 18)), duration: actionDuration))
                self.buttonMission.run(SKAction.move(to: self.buttonMission.getPositionWithScreenPosition(CGPoint(x:121 ,y: 18)), duration: actionDuration))
                self.buttonMothership.run(SKAction.move(to: self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:199 ,y: 18)), duration: actionDuration))
                self.buttonFactory.run(SKAction.move(to: self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:277 ,y: 18)), duration: actionDuration))
                self.buttonHangar.run(SKAction.move(to: self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:326 ,y: 18)), duration: actionDuration))
                
                let control = Button(textureName: "tabBarButtonBattle", text: "Battle", fontSize: hoverTextFontSize, x: 0 ,y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
                control.alpha = 0
                control.run(SKAction.fadeAlpha(to: 1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.run(SKAction.move(to: self.hover.getPositionWithScreenPosition(CGPoint(x:169 ,y: 0)), duration: actionDuration))
                
                break
                
            case .factory:
                self.buttonResearch.run(SKAction.move(to: self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:75 ,y: 18)), duration: actionDuration))
                self.buttonMission.run(SKAction.move(to: self.buttonMission.getPositionWithScreenPosition(CGPoint(x:126 ,y: 18)), duration: actionDuration))
                self.buttonMothership.run(SKAction.move(to: self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:176 ,y: 18)), duration: actionDuration))
                self.buttonFactory.run(SKAction.move(to: self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:257 ,y: 18)), duration: actionDuration))
                self.buttonHangar.run(SKAction.move(to: self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:330 ,y: 18)), duration: actionDuration))
                
                let control = Button(textureName: "buttonFactory", text: "Factory", fontSize: hoverTextFontSize, x: 0, y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
                control.alpha = 0
                control.run(SKAction.fadeAlpha(to: 1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.run(SKAction.move(to: self.hover.getPositionWithScreenPosition(CGPoint(x:227 ,y: 0)), duration: actionDuration))
                break
                
            case .hangar:
                self.buttonResearch.run(SKAction.move(to: self.buttonResearch.getPositionWithScreenPosition(CGPoint(x:77 ,y: 18)), duration: actionDuration))
                self.buttonMission.run(SKAction.move(to: self.buttonMission.getPositionWithScreenPosition(CGPoint(x:129 ,y: 18)), duration: actionDuration))
                self.buttonMothership.run(SKAction.move(to: self.buttonMothership.getPositionWithScreenPosition(CGPoint(x:181 ,y: 18)), duration: actionDuration))
                self.buttonFactory.run(SKAction.move(to: self.buttonFactory.getPositionWithScreenPosition(CGPoint(x:233 ,y: 18)), duration: actionDuration))
                self.buttonHangar.run(SKAction.move(to: self.buttonHangar.getPositionWithScreenPosition(CGPoint(x:315 ,y: 18)), duration: actionDuration))
                
                let control = Button(textureName: "buttonHangar", text: "Hangar", fontSize: hoverTextFontSize, x: 0, y: 0, fontColor: hoverTextColor, fontShadowColor: hoverTextShadowColor, fontShadowOffset: hoverTextShadowOffset, fontName: hoverTextFontName, textOffset: hoverTextOffset)
                control.alpha = 0
                control.run(SKAction.fadeAlpha(to: 1, duration: actionDuration))
                self.hover.addChild(control)
                self.hover.run(SKAction.move(to: self.hover.getPositionWithScreenPosition(CGPoint(x:285 ,y: 0)), duration: actionDuration))
                
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
        
        Button.buttonList.remove(self.buttonResearch)
        Button.buttonList.remove(self.buttonMission)
        Button.buttonList.remove(self.buttonMothership)
        Button.buttonList.remove(self.buttonFactory)
        Button.buttonList.remove(self.buttonHangar)
        Button.buttonList.remove(self.hover)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
