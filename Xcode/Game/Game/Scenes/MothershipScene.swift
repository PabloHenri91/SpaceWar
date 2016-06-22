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
        
        //Estado de mensagem de alerta
        case alert
    }
    
    //Estados iniciais
    var state = states.mothership
    var nextState = states.mothership
    
    let playerData = MemoryCard.sharedInstance.playerData
    let selectedShips = MemoryCard.sharedInstance.playerData.motherShip.spaceships
    
    var buttonBattle:Button!
    var buttonSocial:Button!
    var buttonHangar:Button!
    var buttonLab:Button!
    var buttonBuy:Button!
    
    var labelLevel:Label!
    var labelLevelShadow:Label!
    
    var labelPoints:Label!
    //var labelPointsBorder = [Label]()
    var labelPointsShadow:Label!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
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
        
        //Footer
        self.addChild(Control(textureName: "footerBackground", x: 0, y: 521, xAlign: .center, yAlign: .down))
        
        self.buttonHangar = Button(textureName: "buttonHangar", x: 262, y: 521, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonHangar)
        
        self.buttonSocial = Button(textureName: "buttonSocial", x: 58, y: 521, xAlign: .center, yAlign: .down)
        self.addChild(self.buttonSocial)
        
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
                self.view?.presentScene(BattleScene(), transition: self.transition)
                break
            case .social:
                #if os(iOS)
                    self.view?.presentScene(SocialScene(), transition: self.transition)
                #endif
                break
            case .hangar:
                self.view?.presentScene(HangarScene(), transition: self.transition)
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
                        print(selectedShips.count)
                        if (selectedShips.count == 4) {
                            self.nextState = states.battle
                        } else {
                            self.blackSpriteNode.hidden = false
                            self.blackSpriteNode.zPosition = 100000
                            
                            
                            let teste = AlertBox(title: "Alerta!!!", text: "Estão faltando naves, vá ao hangar", type: .OK)
                            teste.zPosition = self.blackSpriteNode.zPosition + 1
                            self.addChild(teste)
                            teste.buttonOK.addHandler {
                                print("ok")
                                self.nextState = .mothership
                            }
                            self.nextState = .alert
                        }
                        
                        return
                    }
                    
                    if(self.buttonSocial.containsPoint(touch.locationInNode(self))) {
                        #if os(iOS)
                            self.nextState = states.social
                        #endif
                        print("buttonSocial Pressed")
                        return
                    }
                    
                    if(self.buttonHangar.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.hangar
                        return
                    }
                    
                    if(self.buttonLab.containsPoint(touch.locationInNode(self))) {
                        print("buttonLab Pressed")
                        return
                    }
                    
                    if(self.buttonBuy.containsPoint(touch.locationInNode(self))) {
                        print("buttonBuy Pressed")
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
