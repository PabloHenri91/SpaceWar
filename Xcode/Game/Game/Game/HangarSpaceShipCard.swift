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
    var spaceShipImage: Control!
    var buttonDetalis: Button!
    var buttonSelect: Button!
    var buttonUpgrade: Button!
    var labelLevel: Label!
    var labelName: Label!
    var labelDescription: Label!
    var selected: Bool
    
    
    
    init(spaceShip: Spaceship, selected: Bool) {
        
        self.selected = selected
        super.init()
        
        
        self.addChild(Control(textureName: "hangarShipCardSelected"))
       
        self.spaceShip = spaceShip
        self.spaceShipImage = Control(textureName: GameMath.spaceshipSkinImageName(level: self.spaceShip.level, type: self.spaceShip.type))
        self.addChild(self.spaceShipImage)
        self.spaceShipImage.screenPosition = CGPoint(x: 21, y: 41)
        self.spaceShipImage.resetPosition()
        
        self.buttonDetalis = Button(textureName: "shipDetailButton", text: "", x: 0, y: 0)
        self.addChild(self.buttonDetalis)
        
        if self.selected {
            self.buttonSelect = Button(textureName: "buttonSmall", text: "Remove",  x: 29, y: 85)
            self.addChild(self.buttonSelect)
        } else {
            self.buttonSelect = Button(textureName: "buttonSmall", text: "Select",  x: 29, y: 85)
            self.addChild(self.buttonSelect)
        }
        
    
        
        self.buttonUpgrade = Button(textureName: "buttonSmall", text: "Upgrade",  x: 144, y: 85)
        self.addChild(self.buttonUpgrade)
        
        self.labelLevel = Label(text: String(self.spaceShip.level) , fontSize: .small , x: 262, y: 14)
        self.addChild(self.labelLevel)
        
        self.labelName = Label(color:SKColor.whiteColor() ,text: self.spaceShip.type.name , x: 137, y: 23)
        self.addChild(self.labelName)
        
        self.labelDescription = Label(text: self.spaceShip.type.spaceshipDescription, fontSize: .small , x: 62, y: 58, horizontalAlignmentMode: .Left)
      
        self.addChild(self.labelDescription)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func removeSpaceship() {
        self.buttonSelect.removeFromParent()
        self.buttonSelect = Button(textureName: "buttonSmall", text: "Select",  x: 29, y: 85)
        self.addChild(self.buttonSelect)
        self.selected = !selected
    }
    
    func addSpaceship(){
        self.buttonSelect.removeFromParent()
        self.buttonSelect = Button(textureName: "buttonSmall", text: "Remove",  x: 29, y: 85)
        self.addChild(self.buttonSelect)
        self.selected = !selected
        
    }
    
}

