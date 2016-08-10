//
//  ResearchDetailsScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 06/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//


import SpriteKit


class ResearchDetailsScene: GameScene {
    
    var playerData = MemoryCard.sharedInstance.playerData
    let ressearches = MemoryCard.sharedInstance.playerData.researches
    
    var box: Box!
    
    var buttonBack:Button!
    var buttonBegin:Button?
    var buttonSpeedUp: Button?
    var buttonColect: Button?
    var labelTime:Label!
    var needUpdate = true
    var lastUpdate: NSTimeInterval = 0
    
    var research: Research
    
    var controlArray:Array<MultiLineLabel>!
    
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case research
        

        
        
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.buttonBack = Button(textureName: "button", text: "Back", x: 96, y: 10, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
 
    }
    
    init(research: Research) {
        self.research = research
        super.init()
        
        self.box = Box(name: "Research detail box", textureName: "researchDetailsBox", x: 23, y: 76, xAlign: .center, yAlign: .center)
        self.addChild(self.box)
        
        
        let researchTitle = Label(text: self.research.researchType.name, fontSize: 16, x: 140, y: 21, fontName: GameFonts.fontName.museo1000)
        self.box.addChild(researchTitle)
        
        
        
        let description = MultiLineLabel(text: self.research.researchType.researchDescription, maxWidth: 249, fontSize: 14, x: 13, y: 61, fontName: GameFonts.fontName.museo500 , horizontalAlignmentMode: .Left)
        self.box.addChild(description)
        
        
        
        let labelCost = Label(text: self.research.researchType.cost.description , fontSize: 16, x: 185, y: 207, horizontalAlignmentMode: .Left)
        self.box.addChild(labelCost)
        
        let labelRequiriments = Label(text: "Requiriments", fontSize: 16, x: 13, y: 250, horizontalAlignmentMode: .Left)
        self.box.addChild(labelRequiriments)
        
        if let researchData = self.research.researchData {
            
        
        
            if (researchData.startDate != nil) {
                
                let time = GameMath.researchFinishTime(researchData.startDate! , researchTime: self.research.researchType.duration)
                
                if (time > 0) {
                    
                    //TODO: descomentar
                    //                self.buttonSpeedUp = Button(textureName: "buttonSmall", text: "SpeedUp", x: 90, y: 411, xAlign: .center, yAlign: .center)
                    //                self.box.addChild(self.buttonSpeedUp!)
                    
                    self.labelTime = Label(text: GameMath.timeFormated(time), fontSize: 16, x: 60, y: 207, horizontalAlignmentMode: .Left)
                    self.box.addChild(self.labelTime)
                    
                    
                } else {
                    
                    
                    
                    self.buttonColect = Button(textureName: "buttonSmall", text: "Colect", x: 90, y: 411, xAlign: .center, yAlign: .center)
                    self.box.addChild(self.buttonColect!)
                    
                    self.labelTime = Label(text: "Finished", fontSize: 16, x: 60, y: 207, horizontalAlignmentMode: .Left)
                    self.box.addChild(self.labelTime)
                }
                
                
            } else {
                
                
                self.labelTime = Label(text: GameMath.timeFormated(self.research.researchType.duration), fontSize: 16, x: 60, y: 207, horizontalAlignmentMode: .Left)
                self.box.addChild(self.labelTime)
                
                
                self.buttonBegin = Button(textureName: "buttonSmall", text: "Begin", x: 90, y: 411)
                self.box.addChild(self.buttonBegin!)
                
                
                
            }
        }
        
        self.controlArray = Array<MultiLineLabel>()
        
        for requisite in self.research.researchType.requisites {
            self.controlArray.append(MultiLineLabel(text: requisite, maxWidth:230  ,color: SKColor.whiteColor(), fontSize: 14))
        }
        
        if self.controlArray.count > 0 {
            let scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 138, y: 281, spacing: 10 , scrollDirection: .vertical)
             scrollNode.canScroll = false
            self.box.addChild(scrollNode)
        }
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        if(self.state == self.nextState) {
            //Estado atual
            switch (self.state) {
            case .normal:
                
                if ((currentTime - self.lastUpdate) > 1) {
                    self.lastUpdate = currentTime
                    
                    if (self.needUpdate) {
                        if (self.research.researchData?.startDate != nil) {
                            
                            let time = GameMath.researchFinishTime(self.research.researchData!.startDate! , researchTime: self.research.researchType.duration)
                            
                            if (time > 0) {
                                self.labelTime.setText(GameMath.timeFormated(time))
                            } else  {
                                self.needUpdate = false
                                
                                self.buttonSpeedUp?.removeFromParent()
                                
                                if let buttonColect = self.buttonColect {
                                    buttonColect.removeFromParent()
                                }
                                
                                self.buttonColect = Button(textureName: "buttonSmall", text: "Colect",  x: 86, y: 85)
                                self.addChild(self.buttonColect!)
                                self.labelTime.setText("Finished")
                            }
                            
                        } else {
                            self.needUpdate = false
                        }
                        
                    }
                }
                
                break
                
            default:
                break
            }
        } else {
            self.state = self.nextState
            
            //Próximo estado
            switch (self.nextState) {
                
            case .normal:
                break
                
            case .research:
                self.view?.presentScene(ResearchScene())
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
                case .normal:
                    
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .research
                        return
                    }
                    
                    if let buttonBegin = self.buttonBegin {
                        
                        if (buttonBegin.containsPoint(touch.locationInNode(self.box))){
                            
                            if (self.playerData.points.integerValue >= self.research.researchType.cost) {
                                if self.research.start() {
                                    self.playerData.points = self.playerData.points.integerValue - self.research.researchType.cost
                                    //TODO: self.playerDataCard.updatePoits()
                                    self.nextState = .research
                                } else {
                                    let alertBox = AlertBox(title: "Alert!", text: "You have a research doing, wait it finish", type: AlertBox.messageType.OK)
                                    self.addChild(alertBox)
                                }
                            } else {
                                let alertBox = AlertBox(title: "Alert!", text: "No enough bucks bro 😢😢", type: AlertBox.messageType.OK)
                                self.addChild(alertBox)
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
