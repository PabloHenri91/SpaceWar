//
//  TimeBar.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 29/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class TimeBar: CropBox {
    
    enum types {
        case missionSpaceshipTimer
        case researchTimer
    }
    
    var greenBar:SKSpriteNode!
    var greenBarMaxWidth:CGFloat = 1
    var labelDescription:Label?
    
    init(textureName:String = "TimeBar", borderTextureName:String = "Border", x:Int, y:Int, loadLabel:Bool = true, type:types, loadBorder:Bool = true) {
     
        super.init(textureName: textureName, x: x, y: y, xAlign: .left, yAlign: .up)
        let texture = SKTexture(imageNamed: textureName)
        self.greenBarMaxWidth = texture.size().width + 4
        
        var color = SKColor.clearColor()
        
        switch type {
        case  .missionSpaceshipTimer:
            color = SKColor(red: 173/255, green: 231/255, blue: 109/255, alpha: 1)
            break
        case .researchTimer:
            color = SKColor(red: 159/255, green: 220/255, blue: 231/255, alpha: 1)
            break
        }
        
        self.greenBar = SKSpriteNode(texture: nil, color: color, size: CGSize(width: 1, height: texture.size().height + 2))
        self.greenBar.texture?.filteringMode = Display.filteringMode
        self.greenBar.anchorPoint = CGPoint(x: 0, y: 1)

        self.addChild(self.greenBar)
        
        if loadBorder {
            let border = SKSpriteNode(imageNamed: textureName + borderTextureName)
            border.texture?.filteringMode = Display.filteringMode
            border.anchorPoint = CGPoint(x: 0, y: 1)
            self.addChild(border)
        }
        
        if loadLabel {
            self.labelDescription = Label(text: "teste" , fontSize: 11, x: Int(texture.size().width / 2), y: Int(texture.size().height / 2), shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 20/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDescription!)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func update(missionShip:MissionSpaceship) {
        let startDate = missionShip.missionspaceshipData!.startMissionDate
        let mission = MissionSpaceship.types[Int(missionShip.missionspaceshipData!.missionType.intValue)]
        let duration = mission.duration
        self.update(startDate: startDate!, duration: duration)
    }
    
    func update(startDate startDate:NSDate, duration:Int) {
        
        let progress = (startDate.timeIntervalSinceNow * -1) + 1

        if Int(progress) < duration {
            var width = (CGFloat(progress) / CGFloat(duration) * self.greenBarMaxWidth)
            let height = self.greenBar.size.height
            
            if width < 0 {
                width = 0
            }
            
            let action = SKAction.resizeToWidth(width, height: height, duration: 1)
            self.greenBar.runAction(action)
            
            self.labelDescription?.setText(GameMath.timeFormated(duration - Int(progress)))
        } else {
            
            if self.greenBar.size.width < self.greenBarMaxWidth {
                let action = SKAction.resizeToWidth(self.greenBarMaxWidth, height: self.greenBar.size.height, duration: 1)
                self.greenBar.runAction(action)
            }
            
            self.labelDescription?.setText("FINISHED")
        }
    }
}
