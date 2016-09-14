//
//  SpeedUpMiningAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 10/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpeedUpMiningAlert:Box {
    
    var buttonCancel:Button!
    var missionSpaceship:MissionSpaceship!
    var missionType:MissionType!
    
    var timeBar: TimeBar!
    var buttonWatch:Button!
    var labelWatch:Label!
//    var buttonSocial:Button!
    var buttonFinish:Button!
    
    var playerData:PlayerData!
    
    var lastUpdate:NSTimeInterval = 0
    
    var headerControl:Control!
    
    var date: NSDate!
    
    init(missionSpaceship:MissionSpaceship) {
        
        self.playerData = MemoryCard.sharedInstance.playerData
        
        
        let spriteNode = SKSpriteNode(imageNamed: "speedupMinningAlert")
        super.init(spriteNode: spriteNode)
        
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 105, y: -130,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
        })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: "SPEED UP MINING" , fontSize: 13, x: -127, y: -117, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        self.missionSpaceship = missionSpaceship
        self.missionType = MissionSpaceship.types[Int(missionSpaceship.missionspaceshipData!.missionType.intValue)]//TODO: fatal error: Index out of range
        
        self.date = self.missionSpaceship.missionspaceshipData!.startMissionDate!
        
        let labelName = Label(text: "LITTLE ASTEROID" , fontSize: 12, x: -127, y: -82 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelName)
        
        let labelReward = Label(text: "REWARD:" , fontSize: 11, x: -78, y: -53 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelReward)
        
        let iconXP = Control(textureName: "xpIcon", x: -78, y: -36)
        self.addChild(iconXP)
        
        let labelXP = Label(text: self.missionType.xpBonus.description , fontSize: 10, x: -60, y: -35, xAlign: .left , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo500)
        self.addChild(labelXP)
        
        let iconFragments = Control(textureName: "fragIcon", x: -22, y: -36)
        self.addChild(iconFragments)
        
        let labelFragments = Label(text: self.missionType.pointsBonus.description , fontSize: 10, x: -10, y: -35, xAlign: .left , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo500)
        self.addChild(labelFragments)
        
        let spaceshipImage = Control(textureName: "minnerSpaceshipTiny", x: -127, y: -62)
        self.addChild(spaceshipImage)
        
        self.timeBar = TimeBar(textureName: "timeBarSmall", x: 40, y: -53, type: TimeBar.types.missionSpaceshipTimer)
        self.addChild(self.timeBar.cropNode)
        
        self.timeBar.update(self.missionSpaceship)
        
        let labelDiamond = Label(text: "FINISH" , fontSize: 11, x: 20, y: 27 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelDiamond)
        
//        let labelSocial = Label(text: "DECREASE 3H" , fontSize: 11, x: -111, y: 87 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
//        self.addChild(labelSocial)
        
        self.labelWatch = Label(text: "DECREASE 1H" , fontSize: 11, x: -111, y: 27 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(self.labelWatch)
        
        self.buttonWatch = Button(textureName: "buttonWatch", text: "WATCH", fontSize: 13, x: -111, y: 40, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
        self.addChild(self.buttonWatch)
        
        #if os(iOS)
            if !GameAdManager.sharedInstance.zoneIsReady {
                self.buttonWatch.alpha = 0
                self.labelWatch.alpha = 0
            }
        #else
            self.buttonWatch.alpha = 0
            self.labelWatch.alpha = 0
        #endif
        
        let time = GameMath.timeLeft(startDate: self.missionSpaceship.missionspaceshipData!.startMissionDate!, duration: self.missionType.duration)
        var diamonds = Int(round(Double(time) / 3600))
        
        if diamonds < 1 {
            diamonds = 1
        }
        
        self.buttonFinish = Button(textureName: "buttonDiamonds", text: diamonds.description, fontSize: 13, x: 20, y: 40, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 44/255, green: 150/255, blue: 59/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
        self.addChild(self.buttonFinish)
        
//        self.buttonSocial = Button(textureName: "buttonSocial", text: "ASK HELP", fontSize: 13, x: -111, y: 100, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
//        self.addChild(self.buttonSocial)
//        
//        for i in 0..<3 {
//            let x = -5 + 40 * i
//            let facebookPlacehold = Control(textureName: "facebookFriendPlaceholder", x: x, y: 87)
//            self.addChild(facebookPlacehold)
//        }
        
 
        
        self.setScale(0)
        
        self.runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.10), SKAction.scaleTo(1, duration: 0.10)]))
    }
    
    func update(currentTime: NSTimeInterval) {
        
        if currentTime - self.lastUpdate > 1 {
            self.lastUpdate = currentTime
            self.timeBar.update(self.missionSpaceship)
        }
        
    }
    
    func finishWithPremiumPoints() -> Bool {
        
        let time = GameMath.timeLeft(startDate: self.missionSpaceship.missionspaceshipData!.startMissionDate!, duration: self.missionType.duration)
        
        var diamonds = Int(round(Double(time) / 3600))
        if diamonds < 1 {
            diamonds = 1
        }
        
        if self.playerData.premiumPoints.integerValue >= diamonds {
            
            self.playerData.premiumPoints = NSNumber(integer: self.playerData.premiumPoints.integerValue - diamonds)
            print(self.date.dateByAddingTimeInterval(Double(time * -1)))
            //self.missionSpaceship.speedUp(NSTimeInterval(time))
            
            return true
        }
        
        return false
    }
    
    func speedUpWithVideoAd() {
        self.missionSpaceship.speedUp(NSTimeInterval(3600))
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
