//
//  FactorySpaceShipCard.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 30/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class FactorySpaceShipCard: Control {
    
    var spaceShip: Spaceship!
    var spaceShipImage: Control!
    var buttonDetalis: Button!
    var buttonBuy: Button!
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    
    var playerData = MemoryCard.sharedInstance.playerData
    
    init(spaceShip: Spaceship) {
        
        super.init()
        

        self.addChild(Control(textureName: "hangarShipCardSelected"))
        
        self.spaceShip = spaceShip
        self.spaceShipImage = Control(textureName: GameMath.spaceshipSkinImageName(level: self.spaceShip.level, type: self.spaceShip.type))
        self.addChild(self.spaceShipImage)
        self.spaceShipImage.screenPosition = CGPoint(x: 21, y: 41)
        self.spaceShipImage.resetPosition()
        
        self.buttonDetalis = Button(textureName: "shipDetailButton", text: "", x: 0, y: 0)
        self.addChild(self.buttonDetalis)

            
        self.buttonBuy = Button(textureName: "buttonSmall", text: "Buy",  x: 86, y: 85)
        self.addChild(self.buttonBuy!)
            
    
        
        
        
        
        
        self.labelLevel = Label(text: String(self.spaceShip.level) , fontSize: 15, x: 262, y: 14)
        self.addChild(self.labelLevel)
        
        self.labelName = Label(color:SKColor.whiteColor() ,text: self.spaceShip.type.name , x: 137, y: 23)
        self.addChild(self.labelName)
        
      
        self.labelDescription = Label(text: "Price: " + GameMath.spaceshipPrice(self.spaceShip.type).description, fontSize: 12 , x: 62, y: 58, horizontalAlignmentMode: .Left)
        self.addChild(self.labelDescription)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func buySpaceship(){
        print("buy")
        
            let spaceshipData = MemoryCard.sharedInstance.newSpaceshipData(type: self.spaceShip.type.index)
            let weaponData = MemoryCard.sharedInstance.newWeaponData(type: 0)
            spaceshipData.addWeaponData(weaponData)
            self.playerData.addSpaceshipData(spaceshipData)
            self.playerData.points = NSNumber(integer: self.playerData.points.integerValue - GameMath.spaceshipPrice(self.spaceShip.type))
        
        
    }

    
}

