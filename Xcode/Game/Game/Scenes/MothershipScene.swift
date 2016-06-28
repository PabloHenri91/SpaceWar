//
//  MothershipScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MothershipScene: GameScene {
    
    enum states : String {
        //Estado principal
        case mothership
        
        //Estados de saida da scene
        case battle
        
        //Estados de saida da scene
        case hangar
        
        //Estados de saida da scene
        case social
        
        //Estados de saida da scene
        case research
        
        //Estados de saida da scene
        case mission
        
        //Estados de saida da scene
        case factory
        
        //Estado de mensagem de alerta
        case alert
        
        
    }
    
    //Estados iniciais
    var state = states.mothership
    var nextState = states.mothership
    
    var playerData:PlayerData!
    
    var buttonBattle:Button!
    var buttonMission:Button!
    var buttonHangar:Button!
    var buttonLab:Button!
    var buttonBuy:Button!
    
    var labelLevel:Label!
    var labelLevelShadow:Label!
    
    var labelPoints:Label!
    //var labelPointsBorder = [Label]()
    var labelPointsShadow:Label!
    
    var labelXP:Label!
    var labelXPShadow:Label!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.playerData = MemoryCard.sharedInstance.playerData
        
        let xpForNextLevel = GameMath.xpForNextLevel(level: self.playerData.motherShip.level.integerValue)
        let xp = self.playerData.motherShip.xp.integerValue
        if (xpForNextLevel <= xp) {
            self.playerData.motherShip.level = NSNumber(int: self.playerData.motherShip.level.integerValue + 1)
            self.playerData.motherShip.xp = NSNumber(integer: xp - xpForNextLevel)
            let alertBox = AlertBox(title: "Level up", text: "You go to level " + self.playerData.motherShip.level.description + "! 😃 ", type: AlertBox.messageType.OK)
            self.addChild(alertBox)
        }
        
        self.addChild(Control(textureName: "background", x: 0, y: 0, xAlign: .center, yAlign: .center))
        
        //Header
        self.addChild(Control(textureName: "control1", x: 0, y: 0, xAlign: .center, yAlign: .up))
        self.addChild(Control(textureName: "control2", x: 0, y: 22, xAlign: .center, yAlign: .up))
        self.addChild(Control(textureName: "control0", x: 109, y: 12, xAlign: .center, yAlign: .up))
        
        //Label Level
        let labelLevelColor = SKColor(red: 50/255, green: 61/255, blue: 74/255, alpha: 1)// Preto
        let labelLevelShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 12/100)
        let labelLevelText = self.playerData.motherShip.level.description
        
        self.labelLevelShadow = Label(color: labelLevelShadowColor, text: labelLevelText, fontSize: 15, x: 160, y: 34, xAlign: .center, yAlign: .up, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center)
        self.labelLevel = Label(color: labelLevelColor, text: labelLevelText, fontSize: 15, x: 160, y: 33, xAlign: .center, yAlign: .up, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center)
        
        self.addChild(self.labelLevelShadow)
        self.addChild(self.labelLevel)
        //
        
        //Label points
        let labelPointsShadowColor = SKColor(red: 94/255, green: 127/255, blue: 27/255, alpha: 1)// Verde
        let labelPointsColor = SKColor.whiteColor()
        let labelPointsText = self.playerData.points.description + " Frag"
        //FontSize -2 13 +2
        
        self.labelPoints = Label(color: labelPointsColor, text: labelPointsText, fontSize: 13, x: 265, y: 33+2, xAlign: .center, yAlign: .up, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center)
        self.labelPointsShadow = Label(color: labelPointsShadowColor, text: labelPointsText, fontSize: 13, x: 265, y: 34+2, xAlign: .center, yAlign: .up, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center)
        
        self.addChild(self.labelPointsShadow)
        self.addChild(self.labelPoints)
        //
        
        //Label XP
        let labelXPShadowColor = SKColor(red: 67/255, green: 89/255, blue: 19/255, alpha: 1)// Verde
        let labelXPColor = SKColor.whiteColor()
        let labelXPText = self.playerData.motherShip.xp.description + " XP"
        //FontSize -2 13 +2
        
        self.labelXP = Label(color: labelXPColor, text: labelXPText, fontSize: 13, x: 54, y: 33+2, xAlign: .center, yAlign: .up, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center)
        self.labelXPShadow = Label(color: labelXPShadowColor, text: labelXPText, fontSize: 13, x: 54, y: 34+2, xAlign: .center, yAlign: .up, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center)
        
        self.addChild(self.labelXPShadow)
        self.addChild(self.labelXP)
        //
        
        //Footer
        self.addChild(Control(textureName: "footerBackground", x: 0, y: 521, xAlign: .center, yAlign: .down))
        
        self.buttonHangar = Button(textureName: "buttonHangar", x: 262, y: 521, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonHangar)
        
        self.buttonMission = Button(textureName: "buttonSocial", x: 58, y: 521, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonMission)
        
        self.buttonBattle = Button(textureName: "buttonBattle", x: 115, y: 514, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonBattle)
        
        self.buttonLab = Button(textureName: "buttonLab", x: 0, y: 521, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonLab)
        
        self.buttonBuy = Button(textureName: "buttonBuy", x: 204, y: 521, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonBuy)
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
            case .battle:
                self.view?.presentScene(BattleScene(), transition: GameScene.transition)
                break
            case .social:
                #if os(iOS)
                    self.view?.presentScene(SocialScene(), transition: GameScene.transition)
                #endif
                break
            case .hangar:
                self.view?.presentScene(HangarScene(), transition: GameScene.transition)
                break
            case .research:
                self.view?.presentScene(ResearchScene(), transition: GameScene.transition)
                break
            case .mission:
                self.view?.presentScene(MissionScene(), transition: GameScene.transition)
                break
            case .factory:
                self.view?.presentScene(FactoryScene(), transition: GameScene.transition)
                break
            case .alert:
                break
            case .mothership:
                self.blackSpriteNode.hidden = true
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
        
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.mothership:
                    if(self.buttonBattle.containsPoint(touch.locationInNode(self))) {
                        if (self.playerData.motherShip.spaceships.count == 4) {
                            self.nextState = states.battle
                        } else {
                            self.blackSpriteNode.hidden = false
                            self.blackSpriteNode.zPosition = 100000
                            
                            
                            let teste = AlertBox(title: "Alerta!!!", text: "Estão faltando naves, vá ao hangar", type: .OK)
                            teste.zPosition = self.blackSpriteNode.zPosition + 1
                            self.addChild(teste)
                            teste.buttonOK.addHandler {
                                print("ok")
                                self.nextState = .hangar
                            }
                            self.nextState = .alert
                        }
                        
                        return
                    }
                    
                    if(self.buttonMission.containsPoint(touch.locationInNode(self))) {
                            self.nextState = states.mission
                        return
                    }
                    
                    if(self.buttonHangar.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.hangar
                        return
                    }
                    
                    if(self.buttonLab.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.research
                        return
                    }
                    
                    if(self.buttonBuy.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.factory
                        return
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }

}
