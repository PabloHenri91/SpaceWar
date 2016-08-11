//
//  TimeBar.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 29/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class TimeBar: CropBox {
    
    var greenBar:SKSpriteNode!
    var greenBarMaxWidth:CGFloat = 1
    var labelDescription:Label!
    

    
    init(textureName:String = "TimeBar" ,x:Int, y:Int) {
        
     
        super.init(textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up)
        let texture = SKTexture(imageNamed: textureName)
        self.greenBarMaxWidth = texture.size().width + 4
        
        self.greenBar = SKSpriteNode(texture: nil, color: SKColor(red: 211/255, green: 1, blue: 158/255, alpha: 1), size: CGSize(width: 1, height: texture.size().height + 2))
        self.greenBar.anchorPoint = CGPoint(x: 0, y: 1)
        self.greenBar.texture?.filteringMode = Display.filteringMode

        self.addChild(self.greenBar)
        
        let border = SKSpriteNode(imageNamed: textureName + "Border")
        border.anchorPoint = CGPoint(x: 0, y: 1)
        self.addChild(border)
        
        self.labelDescription = Label(text: "teste" , fontSize: 11, x: Int(texture.size().width / 2), y: Int(texture.size().height / 2), shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 20/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelDescription)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(missionShip:MissionSpaceship) {
        let startDate = missionShip.missionspaceshipData!.startMissionDate
        let mission = MissionSpaceship.types[Int(missionShip.missionspaceshipData!.missionType.intValue)]
        let length = mission.duration
        self.update(startDate!, length: length)
    }
    
    func update(startDate:NSDate, length:Int) {
        
        
        let progress = (startDate.timeIntervalSinceNow * -1) + 1

        if Int(progress) < length {
            var width = (CGFloat(progress) / CGFloat(length) * self.greenBarMaxWidth)
            let height = self.greenBar.size.height
            
            if width < 0 {
                width = 0
            }
            
            let action = SKAction.resizeToWidth(width, height: height, duration: 1)
            self.greenBar.runAction(action)
            
            self.labelDescription.setText(GameMath.timeFormated(length - Int(progress)))
        } else {
            
            if self.greenBar.size.width < self.greenBarMaxWidth {
                let action = SKAction.resizeToWidth(self.greenBarMaxWidth, height: self.greenBar.size.height, duration: 1)
                self.greenBar.runAction(action)
            }
            
            self.labelDescription.setText("FINISHED")
        }

    }
}
