//
//  chooseAsteroidAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 01/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class ChooseAsteroidAlert:Box {
    
    var buttonCancel: Button!
    var minerSpaceship: MissionSpaceship!
    var cropBox: CropBox!
    
    var scrollNode:ScrollNode?
    var controlArray:Array<Control>!
    
    init(minerSpaceship: MissionSpaceship) {

        let spriteNode = SKSpriteNode(imageNamed: "chooseAsteroidAlert")
        super.init(spriteNode: spriteNode)
        
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 105, y: -233, top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
            self?.scrollNode?.removeFromParent()
            })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "CHOOSE ASTEROID" , fontSize: 13, x: -127, y: -220, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        self.minerSpaceship = minerSpaceship
        
       
       
        let spaceshipImage = Control(textureName: "minerSpaceshipSmall", x: -127, y: -190)
        self.addChild(spaceshipImage)
        
        let minnerSpacehsipImage = Control(textureName: "minnerSpaceship", x: -120, y: -175)
        self.addChild(minnerSpacehsipImage)
        
        let labelDescription = MultiLineLabel(text: "Mining spaceships are designed to extract precious metals from asteroids. Increase your level to be able to mine bigger asteroids!", maxWidth: 168, x: -43, y: -174, fontSize: 11, horizontalAlignmentMode: .Left)
        self.addChild(labelDescription)
        
        let labelBegin = Label(text: "START MINING" , fontSize: 12, x: -127, y: -94 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelBegin)
        
        self.cropBox = CropBox(textureName: "chooseAsteroidCropBox", x: -141, y: -61, xAlign: .left, yAlign: .up)
        self.addChild(self.cropBox.cropNode)
        
        self.controlArray = Array<Control>()
        
        for i in 0..<(self.minerSpaceship.level * 2){
            self.controlArray.append(MissionTypeCard(missionSpaceship: minerSpaceship, index:i))
        }
        
        self.scrollNode = ScrollNode(name: "scroll", cells: self.controlArray, x: 0 , y: 0, spacing: 0 , scrollDirection: .vertical)
        
        
        if self.minerSpaceship.level < 4 {
            self.scrollNode!.canScroll = false
        }
        
        self.cropBox.addChild(self.scrollNode!)
        self.scrollNode!.alpha = 0
        self.scrollNode!.runAction(SKAction.fadeAlphaTo(1, duration: 0.25))
        
        self.popScale()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
