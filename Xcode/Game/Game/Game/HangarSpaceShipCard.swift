//
//  HangarSpaceShipCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 17/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarSpaceShipCard: Control {
    
    var spaceShip: Spaceship!
    var spaceShipImage: Spaceship!
    var buttonDetalis: Button!
    var buttonSelect: Button?
    var buttonFix: Button?
    var buttonUpgrade: Button?
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    var selected: Bool
    var crashed = false
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    init(spaceShip: Spaceship, selected: Bool) {
        
        self.selected = selected
        super.init()
        
        
        if let spaceshipData = spaceShip.spaceshipData {
         
            if (GameMath.spaceshipFixTime(spaceshipData.crashDate) > 0) {
                self.crashed = true
            }
        }
        
        
        self.addChild(Control(textureName: "hangarShipCardSelected"))
       
        self.spaceShip = spaceShip
        self.spaceShipImage = Spaceship(spaceshipData: spaceShip.spaceshipData!)
        self.spaceShipImage.loadAllyDetails()
        self.addChild(self.spaceShipImage)
        self.spaceShipImage.screenPosition = CGPoint(x: 21+16, y: 41+16)
        self.spaceShipImage.resetPosition()
        
        self.buttonDetalis = Button(textureName: "shipDetailButton", text: "", x: 0, y: 0)
        self.addChild(self.buttonDetalis)
        
        if self.crashed {
            
            self.buttonFix = Button(textureName: "buttonSmall", text: "Fix",  x: 86, y: 85)
            self.addChild(self.buttonFix!)
            
        } else {
            if self.selected {
                self.buttonSelect = Button(textureName: "buttonSmall", text: "Remove",  x: 29, y: 85)
                self.addChild(self.buttonSelect!)
            } else {
                self.buttonSelect = Button(textureName: "buttonSmall", text: "Select",  x: 29, y: 85)
                self.addChild(self.buttonSelect!)
            }
            
            self.buttonUpgrade = Button(textureName: "buttonSmall", text: "Upgrade",  x: 144, y: 85)
            self.addChild(self.buttonUpgrade!)
        }
        
        
        

        
        self.labelLevel = Label(text: String(self.spaceShip.level) , fontSize: 15, x: 262, y: 14)
        self.addChild(self.labelLevel)
        
        self.labelName = Label(color:SKColor.whiteColor() ,text: self.spaceShip.type.name , x: 137, y: 23)
        self.addChild(self.labelName)
        
        if self.crashed {
            if let spaceshipData = self.spaceShip.spaceshipData {
                self.labelDescription = Label(text: GameMath.timeFormated(GameMath.spaceshipFixTime(spaceshipData.crashDate)) , fontSize: 11 , x: 62, y: 58, horizontalAlignmentMode: .Left)
            }
        } else {
            //self.labelDescription = Label(text: self.spaceShip.type.spaceshipDescription, fontSize: 11 , x: 62, y: 58, horizontalAlignmentMode: .Left)
            self.labelDescription = Label(text: "Upgrade cost " + GameMath.spaceshipUpgradeCost(level: self.spaceShip.level, type: self.spaceShip.type).description , fontSize: 11 , x: 62, y: 58, horizontalAlignmentMode: .Left)
        }
        
      
        self.addChild(self.labelDescription)
        
    }
    
    
    func update() {
        if self.crashed {
            if let spaceshipData = spaceShip.spaceshipData {
                if (GameMath.spaceshipFixTime(spaceshipData.crashDate) > 0) {
                    self.labelDescription.setText(GameMath.timeFormated(GameMath.spaceshipFixTime(spaceshipData.crashDate)))
                } else {
                    self.crashed = false
                    self.buttonFix?.removeFromParent()
                    
                    if self.selected {
                        self.buttonSelect = Button(textureName: "buttonSmall", text: "Remove",  x: 29, y: 85)
                        self.addChild(self.buttonSelect!)
                    } else {
                        self.buttonSelect = Button(textureName: "buttonSmall", text: "Select",  x: 29, y: 85)
                        self.addChild(self.buttonSelect!)
                    }
                    self.buttonUpgrade = Button(textureName: "buttonSmall", text: "Upgrade",  x: 144, y: 85)
                    self.addChild(self.buttonUpgrade!)
                }
            }
            
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func removeSpaceship() {
        self.buttonSelect!.removeFromParent()
        self.buttonSelect = Button(textureName: "buttonSmall", text: "Select",  x: 29, y: 85)
        self.addChild(self.buttonSelect!)
        self.selected = !selected
    }
    
    func addSpaceship() {
        self.buttonSelect!.removeFromParent()
        self.buttonSelect = Button(textureName: "buttonSmall", text: "Remove",  x: 29, y: 85)
        self.addChild(self.buttonSelect!)
        self.selected = !selected
    }
    
    func upgradeSpaceship(cost: Int) {
        let xp = GameMath.spaceshipUpgradeXPBonus(level: self.spaceShip.level, type: self.spaceShip.type)
        self.spaceShip.upgrade()
        self.playerData.points = NSNumber(integer: self.playerData.points.integerValue - cost)
        self.playerData.motherShip.xp = NSNumber(integer: self.playerData.motherShip.xp.integerValue + xp)
        self.reloadCard()
    }
    
    func reloadCard() {
      
        self.labelLevel.setText(self.spaceShip.level.description)
        self.labelDescription.setText("Upgrade cost " + GameMath.spaceshipUpgradeCost(level: self.spaceShip.level, type: self.spaceShip.type).description)
    }
    
}

