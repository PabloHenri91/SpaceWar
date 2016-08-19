//
//  ChooseMissionScene.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 04/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class ChooseMissionScene: GameScene {
    
    
    var missionSpaceship: MissionSpaceship!
    var buttonBack:Button!
    
    var scrollNode:ScrollNode!
    var controlArray:Array<MissionTypeCard>!
    
    enum states : String {
        //Estado principal
        case normal
        
        //Estados de saida da scene
        case missionScene
        
        
    }
    
    //Estados iniciais
    var state = states.normal
    var nextState = states.normal
    
    
    init(missionSpaceship: MissionSpaceship) {
        super.init()
        self.missionSpaceship = missionSpaceship
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        let background = Control(textureName: "missionsAlert", x: 17, y: 24, xAlign: .center, yAlign: .center)
        self.addChild(background)
        
        self.buttonBack = Button(textureName: "buttonCancelChooseMission", text: "", x: 282, y: 7, xAlign: .center, yAlign: .center)
        self.addChild(self.buttonBack)
        
        self.addChild(Label(color: SKColor.blackColor(), text: "Choose mission",fontSize: 12, x: 161, y: 42, xAlign: .center, yAlign: .center))
        
        self.controlArray = Array<MissionTypeCard>()
        
        for i in 0..<(self.missionSpaceship.level * 2){
            self.controlArray.append(MissionTypeCard(missionSpaceship: self.missionSpaceship, index:i))
        }
        
        
        self.scrollNode = ScrollNode(name: "scroll", cells: controlArray, x: 31, y: 68, xAlign: .center, yAlign: .center, spacing: 10 , scrollDirection: .vertical)
        self.scrollNode.canScroll = false
        self.addChild(self.scrollNode)
        
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
                
            case .missionScene:
                self.view?.presentScene(MissionScene())
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
                case .normal:
                    
                    
                    if(self.buttonBack.containsPoint(touch.locationInNode(self))) {
                        self.nextState = .missionScene
                        return
                    }
                    
                    
                    if self.scrollNode.containsPoint(touch.locationInNode(self)) {
                        for item in self.scrollNode.cells {
                            if item.containsPoint(touch.locationInNode(self.scrollNode)) {
                                if let card = item as? MissionTypeCard {
                                    
                                    if card.buttonSelect.containsPoint(touch.locationInNode(card)) {
                                        card.selectMission()
                                        self.nextState = .missionScene
                                    }
                                    return
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
