//
//  FactoryScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 28/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//
import SpriteKit


class FactoryScene: GameScene {
    
    
    var playerData = MemoryCard.sharedInstance.playerData
    let playerShips = MemoryCard.sharedInstance.playerData.unlockedSpaceships as! Set<SpaceshipData>
    let weapons = MemoryCard.sharedInstance.playerData.weapons as! Set<WeaponData>
    
    var labelShips:Label!
    var buttonBack:Button!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<FactorySpaceShipCard>!
    
    var spaceShipListShape: CropBox!
    
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estado de alertBox
        case alert
        
        
        //Estados de saida da scene
        case mothership
        
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
 
        
    
        
        let line = Control(textureName: "lineHangar")
        self.addChild(line)
        line.screenPosition = CGPoint(x: 0, y: 194)
        line.resetPosition()
        
        self.spaceShipListShape = CropBox(textureName: "spaceShipListShape")
        self.addChild(spaceShipListShape)
        self.spaceShipListShape.screenPosition = CGPoint(x: 20, y: 228)
        self.spaceShipListShape.resetPosition()
        
        
        self.labelShips = Label(color: SKColor.whiteColor(), text: "Unlocked spaceships",fontSize: GameFonts.fontSize.medium.rawValue, x: 57, y: 213, horizontalAlignmentMode: .Left)
        self.addChild(self.labelShips)
        
        self.controlArray = Array<FactorySpaceShipCard>()
        
        for item in playerShips {
            for weapon in weapons {
                let spaceship = Spaceship(spaceshipData: item)
                spaceship.weapon = Weapon(weaponData: weapon)
                self.controlArray.append(FactorySpaceShipCard(spaceShip: spaceship))
            }
        }
        
    
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 0, y: 75, spacing: 0 , scrollDirection: .vertical)
        self.spaceShipListShape.addChild(self.scrollNode)
        
        
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
                
            case states.normal:
                break
                
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case states.normal:
                self.blackSpriteNode.hidden = true
                break
                
                
            case .mothership:
                self.view?.presentScene(MothershipScene(), transition: GameScene.transition)
                break
                
            case .alert:
                break
                
            default:
                #if DEBUG
                    fatalError()
                #endif
                break
            }
        }
    }
    
    override func touchesEnded(taps touches: Set<UITouch>) {
        super.touchesEnded(taps: touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                case states.normal:
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .mothership
                        return
                    }
                    
                    
                    if (self.scrollNode.containsPoint(touch.locationInNode(self.spaceShipListShape.cropNode))) {
                        for item in self.scrollNode.cells {
                            if (item.containsPoint(touch.locationInNode(self.scrollNode))) {
                                if let card = item as? FactorySpaceShipCard {
                                    
                                    if (card.buttonBuy.containsPoint(touch.locationInNode(card))) {
                                        if ((card.position.y < 140) && (card.position.y > -130)) {
                                            
                                            if (self.playerData.points.integerValue > GameMath.spaceshipPrice(card.spaceShip.type)) {
                                                card.buySpaceship()
                                            } else {
                                                
                                                self.blackSpriteNode.hidden = false
                                                self.blackSpriteNode.zPosition = 100000
                                                
                                                
                                                let teste = AlertBox(title: "Alert!!!", text: "Insuficient funds!", type: .OK)
                                                teste.zPosition = self.blackSpriteNode.zPosition + 1
                                                self.addChild(teste)
                                                teste.buttonOK.addHandler {
                                                    self.nextState = .normal
                                                }
                                                self.nextState = .alert
                                                
                                            }
                                            
                                
                                        }
                                    }
                                }
                            }
                            
                        }
                    }
                    
                    break
                    
                default:
                    break
                }
            }
        }
        
    }
    
}