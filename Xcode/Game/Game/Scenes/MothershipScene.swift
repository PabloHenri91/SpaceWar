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
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        
        self.addChild(Label(color: GameColors.white, text: "MothershipScene", x: 10, y: 10, xAlign: .center, yAlign: .center, verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left))
        
        let background = Control(textureName: "background", x:-53, xAlign: .center, yAlign: .center)
        background.zPosition = -2
        self.addChild(background)
        
        self.buttonBattle = Button(textureName: "button", text: "Battle", x: 93, y: 247, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBattle)
        
        self.buttonSocial = Button(textureName: "button", text: "Social", x: 93, y: 299, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonSocial)
        
        self.buttonHangar = Button(textureName: "button", text: "Hangar", x: 20, y: 351, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonHangar)
        
        let control = Control(spriteNode: SKSpriteNode(color: SKColor.whiteColor(), size: CGSize(width: 1,height: 1)), x:160, y:284, xAlign: .center, yAlign: .center)
        control.zPosition = -1
        self.addChild(control)
        control.addChild(Mothership(mothershipData: self.playerData.motherShip))
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
                self.view?.presentScene(BattleScene())
                break
            case .social:
                #if os(iOS)
                    self.view?.presentScene(SocialScene())
                #endif
                break
            case .hangar:
                self.view?.presentScene(HangarScene())
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
                        return
                    }
                    
                    if(self.buttonHangar.containsPoint(touch.locationInNode(self))) {
                        self.nextState = states.hangar
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
