//
//  SpeedUpMiningAlert.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 10/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class SpeedUpAlert:Box {
    
    var playerData:PlayerData!
    
    var missionSpaceshipData: MissionSpaceshipData?
    var researchData: ResearchData?
    
    var buttonCancel:Button!
    var timeBar: TimeBar!
    var buttonWatch:Button!
    var labelWatch:Label!
    var buttonFinish:Button!
    
    var lastUpdate:NSTimeInterval = 0
    
    var headerControl:Control!
    
    var type = EventCard.types.none
    
    var duration = 1
    
    init(researchData: ResearchData) {
        let spriteNode = SKSpriteNode(imageNamed: "speedupMinningAlert")
        super.init(spriteNode: spriteNode)
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.type = EventCard.types.researchEvent
        
        let researchType = Research.types[researchData.type.integerValue]
        
        let spaceship = Spaceship(type: researchType.spaceshipUnlocked!, level: 1)
        spaceship.addWeapon(Weapon(type: researchType.weaponUnlocked!, level: spaceship.level, loadSoundEffects: false))
        
        self.researchData = researchData
        self.playerData = MemoryCard.sharedInstance.playerData
        
        let timeBarType = TimeBar.types.researchTimer
        
        let labelTitleText = "SPEED UP RESEARCH"
        
        var labelReward = ""
        var icon0TextureName = ""
        var icon1TextureName = ""
        
        var label0Text = spaceship.maxHealth.description
        var label1Text = spaceship.weapon!.damage.description
        
        var labelNameText = ""
        
        if researchData.spaceshipLevel.integerValue == 0 {
            labelReward = "ATTRIBUTES:"
            icon0TextureName = "lifeIcon"
            icon1TextureName = "damageIcon"
            
            label0Text = spaceship.maxHealth.description
            label1Text = spaceship.weapon!.damage.description
            
            labelNameText = spaceship.displayName()
            
        } else {
            labelReward = "MAX LEVEL:"
            icon0TextureName = "levelUpIcon"
            icon1TextureName = ""
            
            label0Text = ""//researchData.spaceshipLevel.integerValue.description + " -> " + (researchData.spaceshipLevel.integerValue + 10).description
            label1Text = ""
            
            let label0 = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 1), text: researchData.spaceshipLevel.integerValue.description, fontSize: 11, x: -60, y: -25, xAlign: .left, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500)
            self.addChild(label0)
            
            let label1 = Label(color: SKColor(red: 62/255, green: 77/255, blue: 88/255, alpha: 1), text: " -> ", fontSize: 11, x: Int(label0.position.x + label0.calculateAccumulatedFrame().width), y: -25, xAlign: .left, verticalAlignmentMode: .Baseline, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo500)
            self.addChild(label1)
            
            let label2 = Label(color: SKColor(red: 121/255, green: 190/255, blue: 75/255, alpha: 1), text: (researchData.spaceshipLevel.integerValue + 10).description, fontSize: 11, x: Int(label1.position.x + label1.calculateAccumulatedFrame().width), y: -25, xAlign: .left, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo1000)
            self.addChild(label2)
            
            let label3 = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 1), text: "---", fontSize: 11, x: -60, y: -25, xAlign: .left, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500)
            self.addChild(label3)
            
            let label4 = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 1), text: "--", fontSize: 11, x: -58, y: -25, xAlign: .left, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, fontName: GameFonts.fontName.museo500)
            self.addChild(label4)
            
            labelNameText = spaceship.displayName() + " Improvement " + (researchData.spaceshipLevel.integerValue/10).description
        }
        
        self.duration = researchType.duration
        
        let timeLeft = GameMath.timeLeft(researchData)
        var diamonds = Int(round(Double(timeLeft) / 3600))
        
        if diamonds < 1 {
            diamonds = 1
        }
        
        let buttonFinishText = diamonds.description
        
        let spaceshipImage = Control(textureName: "speedUpAlertSpaceshipBackground", x: -127, y: -62)
        
        spaceship.setScale(min((spaceshipImage.size.width-5)/spaceship.size.width, (spaceshipImage.size.height-5)/spaceship.size.height))
        if spaceship.xScale > 2 {
            spaceship.setScale(2)
        }
        spaceship.position = CGPoint(x: spaceshipImage.size.width/2, y: -spaceshipImage.size.height/2)
        spaceshipImage.addChild(spaceship)
        
        self.load(spaceshipImage: spaceshipImage, timeBarType: timeBarType, labelTitleText: labelTitleText, labelNameText: labelNameText.uppercaseString, labelReward: labelReward, icon0TextureName: icon0TextureName, icon1TextureName: icon1TextureName, label0Text: label0Text, label1Text: label1Text, buttonFinishText: buttonFinishText)
        
        self.timeBar.update(researchData: researchData)
        
        //        self.buttonSocial = Button(textureName: "buttonSocial", text: "ASK HELP", fontSize: 13, x: -111, y: 100, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 75/255, green: 87/255, blue: 98/255, alpha: 1), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
        //        self.addChild(self.buttonSocial)
        //
        //        for i in 0..<3 {
        //            let x = -5 + 40 * i
        //            let facebookPlacehold = Control(textureName: "facebookFriendPlaceholder", x: x, y: 87)
        //            self.addChild(facebookPlacehold)
        //        }

    }
    
    init(missionSpaceshipData:MissionSpaceshipData) {
        
        let spriteNode = SKSpriteNode(imageNamed: "speedupMinningAlert")
        super.init(spriteNode: spriteNode)
        spriteNode.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        
        self.type = EventCard.types.missionSpaceshipEvent
        
        self.missionSpaceshipData = missionSpaceshipData
        self.playerData = MemoryCard.sharedInstance.playerData
        
        let timeBarType = TimeBar.types.missionSpaceshipTimer
        
        let labelTitleText = "SPEED UP MINING"
        let labelNameText = "LITTLE ASTEROID"
        let labelReward = "REWARD:"
        let icon0TextureName = "xpIcon"
        let icon1TextureName = "fragIcon"
        
        let missionSpaceshipType = Mission.types[missionSpaceshipData.missionType.integerValue]
        
        self.duration = missionSpaceshipType.duration
        
        let label0Text = missionSpaceshipType.xpBonus.description
        let label1Text = missionSpaceshipType.pointsBonus.description
        
        let timeLeft = GameMath.timeLeft(missionSpaceshipData)
        var diamonds = Int(round(Double(timeLeft) / 3600))
        
        if diamonds < 1 {
            diamonds = 1
        }
        
        let buttonFinishText = diamonds.description
        
        let spaceshipImage = Control(textureName: "minnerSpaceshipTiny", x: -127, y: -62)
        
        self.load(spaceshipImage: spaceshipImage, timeBarType: timeBarType, labelTitleText: labelTitleText, labelNameText: labelNameText, labelReward: labelReward, icon0TextureName: icon0TextureName, icon1TextureName: icon1TextureName, label0Text: label0Text, label1Text: label1Text, buttonFinishText: buttonFinishText)
        
        self.timeBar.update(missionSpaceshipData: missionSpaceshipData)
    }
    
    func load(spaceshipImage spaceshipImage: Control, timeBarType: TimeBar.types, labelTitleText: String, labelNameText: String, labelReward: String, icon0TextureName: String, icon1TextureName: String, label0Text: String, label1Text: String, buttonFinishText: String) {
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 105, y: -130,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
        })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: labelTitleText , fontSize: 13, x: -127, y: -117, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        let labelName = Label(text: labelNameText, fontSize: 12, x: -127, y: -82 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelName)
        
        let labelReward = Label(text: labelReward, fontSize: 11, x: -78, y: -53 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelReward)
        
        let icon0 = Control(textureName: icon0TextureName, x: -78, y: -36)
        self.addChild(icon0)
        
        let label0 = Label(text: label0Text, fontSize: 10, x: -60, y: -35, xAlign: .left , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo500)
        self.addChild(label0)
        
        if icon1TextureName != "" {
            let icon1 = Control(textureName: icon1TextureName, x: -22, y: -36)
            self.addChild(icon1)
        }
        
        let label1 = Label(text: label1Text, fontSize: 10, x: -10, y: -35, xAlign: .left , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), verticalAlignmentMode: .Top, horizontalAlignmentMode: .Left,  fontName: GameFonts.fontName.museo500)
        self.addChild(label1)
        
        self.addChild(spaceshipImage)
        
        self.timeBar = TimeBar(textureName: "timeBarSmall", x: 40, y: -53, type: timeBarType)
        self.addChild(self.timeBar.cropNode)
        
        let labelDiamond = Label(text: "FINISH" , fontSize: 11, x: 20, y: 27 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left)
        self.addChild(labelDiamond)
        
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
        
        self.buttonFinish = Button(textureName: "buttonDiamonds", text: buttonFinishText, fontSize: 13, x: 20, y: 40, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), fontShadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, textOffset: CGPoint(x: 8, y: 0))
        self.addChild(self.buttonFinish)
        
        self.setScale(0)
        
        self.runAction(SKAction.sequence([SKAction.scaleTo(1.1, duration: 0.10), SKAction.scaleTo(1, duration: 0.10)]))
    }
    
    func timeLeft() -> Int {
        
        switch self.type {
            
        case .missionSpaceshipEvent, .researchEvent:
            return GameMath.timeLeft(self.startDate()!, duration: self.duration)
            
        default:
            return 0
        }
    }
    
    func startDate() -> NSDate? {
        switch self.type {
            
        case .missionSpaceshipEvent:
            return self.missionSpaceshipData?.startMissionDate
            
        case .researchEvent:
            return self.researchData?.startDate
            
        default:
            return nil
        }
    }
    
    func update(currentTime: NSTimeInterval) {
        
        if currentTime - self.lastUpdate > 1 {
            self.lastUpdate = currentTime
            switch self.type {
            case .missionSpaceshipEvent:
                self.timeBar.update(missionSpaceshipData: self.missionSpaceshipData!)
                break
            case .researchEvent:
                self.timeBar.update(researchData: self.researchData!)
                break
            case .none:
                break
            }
        }
    }
    
    func finishWithPremiumPoints() -> Bool {
        
        let timeLeft = self.timeLeft()
        
        var diamonds = Int(round(Double(timeLeft) / 3600))
        if diamonds < 1 {
            diamonds = 1
        }
        
        if self.playerData.premiumPoints.integerValue >= diamonds {
            
            self.playerData.premiumPoints = NSNumber(integer: self.playerData.premiumPoints.integerValue - diamonds)
            
            switch self.type {
            case .missionSpaceshipEvent:
                self.missionSpaceshipData?.startMissionDate = NSDate(timeInterval: Double(timeLeft) * -1, sinceDate: self.missionSpaceshipData!.startMissionDate!)
                break
            case .researchEvent:
                self.researchData?.startDate = NSDate(timeInterval: Double(timeLeft) * -1, sinceDate: self.researchData!.startDate!)
                break
            case .none:
                return false
            }
            
            return true
        }
        
        return false
    }
    
    func speedUpWithVideoAd() {
        
        let videoTimeBonus:Double = 3600
        
        switch self.type {
        case .missionSpaceshipEvent:
            self.missionSpaceshipData?.startMissionDate = NSDate(timeInterval: videoTimeBonus * -1, sinceDate: self.missionSpaceshipData!.startMissionDate!)
            break
        case .researchEvent:
            self.researchData?.startDate = NSDate(timeInterval: videoTimeBonus * -1, sinceDate: self.researchData!.startDate!)
            break
        case .none:
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
