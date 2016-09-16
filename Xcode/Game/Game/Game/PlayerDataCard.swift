//
//  PlayerDataCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/26/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit
import GameKit

class PlayerDataCard: Control {
    
    var labelLevel:Label!
    var labelLevelShadow:Label!
    
    var labelXP:Label!
    var labelXPShadow:Label!
    
    var labelPoints:Label!
    var labelPremiumPoints:Label!
    
    var xpBarCircle:SKShapeNode!
    var xpBarSpriteNode:SKSpriteNode?
    
    var statistics:PlayerDataCardStatistics!
    
    
    var buttonStore:Button!

    override init() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.intValue)
        
        if playerData.motherShip.xp.intValue >= xpForNextLevel {
            playerData.motherShip.level = (playerData.motherShip.level.intValue + 1) as NSNumber
            playerData.motherShip.xp = (playerData.motherShip.xp.intValue - xpForNextLevel) as NSNumber
            
            Metrics.levelUp()
            #if os(iOS)
                if let vc = Control.gameScene.view?.window?.rootViewController as? GameViewController {
                    vc.saveLevel(Int(playerData.motherShip.level))
                }
            #endif
            
            let scene = Control.gameScene!
            
            let alertBox = AlertBox(title: "Level Up!", text: "You are now on level ".translation() + playerData.motherShip.level.description + "! " + String.winEmoji(), type: AlertBox.messageType.ok)
            alertBox.buttonOK.addHandler({
                scene.setDefaultState()
            })
            scene.setAlertState()
            scene.addChild(alertBox)
        }
        
        xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.intValue)
        
        super.init(textureName: "playerDataCardBackground", x: -58, y: 0, xAlign: .center, yAlign: .up)
        self.zPosition = 100
        
        self.statistics = PlayerDataCardStatistics()
        self.addChild(self.statistics)
        
        self.loadXPBar(xp: playerData.motherShip.xp.intValue, xpForNextLevel: xpForNextLevel)
        self.loadLabelXP(playerData.motherShip.xp.description + "/" + xpForNextLevel.description)
        
        
        self.addChild(Control(textureName: "playerDataCardBackground1", x: 166, y: 14))
        
        self.loadLabelLevel(playerData.motherShip.level.description)
        
        self.loadResourcesLabels(playerData.points.intValue, premiumPoints: playerData.premiumPoints.intValue)
        
        self.buttonStore = Button(textureName: "buttonTakeMyMoney", x: 343, y: 19, touchArea:CGSize(width: 64,height: 64))
        self.addChild(self.buttonStore)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        self.statistics.update()
    }
    
    func loadResourcesLabels(_ points:Int, premiumPoints:Int) {
        let valueFontName = GameFonts.fontName.museo1000
        let fontSize = CGFloat(9)
        let pointsColor = SKColor(red: 255/255, green: 162/255, blue: 87/255, alpha: 1)
        let premiumPointsColor = SKColor(red: 119/255, green: 97/255, blue: 174/255, alpha: 1)
        
        let labelPointsValuePosition = CGPoint(x: 287, y: 27)
        
        let labelPremiumPointsValuePosition = CGPoint(x: 287, y: 41)
        
        self.labelPoints = Label(color: pointsColor, text: points.description, fontSize: fontSize, x: Int(labelPointsValuePosition.x), y: Int(labelPointsValuePosition.y), verticalAlignmentMode: .center, horizontalAlignmentMode: .left, fontName: valueFontName)
        self.addChild(self.labelPoints)
        
        self.labelPremiumPoints = Label(color: premiumPointsColor, text: premiumPoints.description, fontSize: fontSize, x: Int(labelPremiumPointsValuePosition.x), y: Int(labelPremiumPointsValuePosition.y), verticalAlignmentMode: .center, horizontalAlignmentMode: .left, fontName: valueFontName)
        self.addChild(self.labelPremiumPoints)
    }
    
    func loadLabelLevel(_ text:String) {
        let fontName = GameFonts.fontName.museo1000
        let positionX = 217
        let positionY = 35
        let fontSize = CGFloat(14)
        let color = SKColor(red: 60/255, green: 75/255, blue: 88/255, alpha: 1)
        let shadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 8/100)
        
        self.labelLevel = Label(color: color, text: text, fontSize: fontSize, x: positionX, y: positionY, verticalAlignmentMode: .center, horizontalAlignmentMode: .center, fontName: fontName)
        
        self.labelLevelShadow = Label(color: shadowColor, text: text, fontSize: fontSize, x: positionX, y: positionY + 1, verticalAlignmentMode: .center, horizontalAlignmentMode: .center, fontName: fontName)
        
        self.addChild(self.labelLevelShadow)
        self.addChild(self.labelLevel)
    }
    
    func loadLabelXP(_ text:String) {
        let fontName = GameFonts.fontName.museo1000
        let positionX = 114
        let positionY = 35
        let fontSize = CGFloat(9)
        let color = SKColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let shadowColor = SKColor(red: 28/255, green: 112/255, blue: 141/255, alpha: 100/100)
        
        self.labelXP = Label(color: color, text: text, fontSize: fontSize, x: positionX, y: positionY, verticalAlignmentMode: .center, horizontalAlignmentMode: .center, fontName: fontName)
        
        self.labelXPShadow = Label(color: shadowColor, text: text, fontSize: fontSize, x: positionX, y: positionY +  1, verticalAlignmentMode: .center, horizontalAlignmentMode: .center, fontName: fontName)
        
        self.addChild(self.labelXPShadow)
        self.addChild(self.labelXP)
    }
    
    func loadXPBar(xp:Int, xpForNextLevel:Int) {
        
        let color = SKColor(red: 45/255, green: 195/255, blue: 245/255, alpha: 1)
        let width:CGFloat = 103 * (CGFloat(xp)/CGFloat(xpForNextLevel))
        let height:CGFloat = 17
        let positionX:CGFloat = 166
        let positionY:CGFloat = -26
        
        self.xpBarCircle = SKShapeNode(circleOfRadius: CGFloat(height/2))
        self.xpBarCircle.fillColor = color
        self.xpBarCircle.strokeColor = SKColor.clear
        self.xpBarCircle.position = CGPoint(x: (positionX - width) + (height/2), y: positionY - (height/2))
        
        if width > height/2 {
            let anchorPoint = CGPoint(x: 1, y: 1)
            self.xpBarSpriteNode = SKSpriteNode(texture: nil, color: color, size: CGSize(width: width - (height/2), height: height))
            self.xpBarSpriteNode!.texture?.filteringMode = Display.filteringMode
            self.xpBarSpriteNode!.anchorPoint = anchorPoint
            self.xpBarSpriteNode!.position = CGPoint(x: positionX, y: positionY)
            self.addChild(self.xpBarSpriteNode!)
        } else {
            let anchorPoint = CGPoint(x: 1, y: 1)
            self.xpBarSpriteNode = SKSpriteNode(texture: nil, color: color, size: CGSize(width: 1, height: height))
            self.xpBarSpriteNode!.texture?.filteringMode = Display.filteringMode
            self.xpBarSpriteNode!.anchorPoint = anchorPoint
            self.xpBarSpriteNode!.position = CGPoint(x: positionX + 1, y: positionY)
            self.addChild(self.xpBarSpriteNode!)
        }
        
        self.addChild(self.xpBarCircle)
    }
    
    fileprivate func updateLevel() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let text = playerData.motherShip.level.description
        
        self.labelLevel.setText(text)
        self.labelLevelShadow.setText(text)
        
        let duration:Double = 0.10
        var actions = [SKAction]()
        actions.append(SKAction.scale(to: 1.5, duration: duration))
        actions.append(SKAction.scale(to: 1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelLevel.run(action)
        self.labelLevelShadow.run(action)
    }
    
    func updateXP() {
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        var xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.intValue)
        
        if playerData.motherShip.xp.intValue >= xpForNextLevel {
            playerData.motherShip.level = NSNumber(value: playerData.motherShip.level.intValue + 1 as Int32)
            self.updateLevel()
            playerData.motherShip.xp = NSNumber(value: playerData.motherShip.xp.intValue - xpForNextLevel as Int)
            
            Metrics.levelUp()
            #if os(iOS)
                if let vc = Control.gameScene.view?.window?.rootViewController as? GameViewController {
                    vc.saveLevel(Int(playerData.motherShip.level))
                }
            #endif
            
            let scene = Control.gameScene!
            
            let alertBox = AlertBox(title: "Level Up!", text: "You are now on level ".translation() + playerData.motherShip.level.description + "! " + String.winEmoji(), type: AlertBox.messageType.ok)
            alertBox.buttonOK.addHandler({
                scene.setDefaultState()
            })
            scene.setAlertState()
            scene.addChild(alertBox)
        }
        
        xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.intValue)
        
        let text = playerData.motherShip.xp.description + "/" + xpForNextLevel.description
        
        self.labelXP.setText(text)
        self.labelXPShadow.setText(text)
        
        let duration:Double = 0.10
        var actions = [SKAction]()
        actions.append(SKAction.scale(to: 1.5, duration: duration))
        actions.append(SKAction.scale(to: 1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelXP.run(action)
        self.labelXPShadow.run(action)
        
        let positionX:CGFloat = 166
        let positionY:CGFloat = -26
        let width:CGFloat = 103 * (CGFloat(playerData.motherShip.xp.intValue)/CGFloat(xpForNextLevel))
        let height:CGFloat = 17
        
        self.xpBarCircle.position = CGPoint(x: (positionX - width) + (height/2), y: positionY - (height/2))
        
        if let xpBarSpriteNode = self.xpBarSpriteNode {
            if width > height/2 {
                xpBarSpriteNode.isHidden = false
                xpBarSpriteNode.size = CGSize(width: width - (height/2), height: height)
                xpBarSpriteNode.position = CGPoint(x: positionX, y: positionY)
            } else {
                xpBarSpriteNode.isHidden = true
            }
        }
    }
    
    func updatePoints() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let text = playerData.points.description
        
        self.labelPoints.setText(text)
        
        let duration:Double = 0.10
        var actions = [SKAction]()
        actions.append(SKAction.scale(to: 1.5, duration: duration))
        actions.append(SKAction.scale(to: 1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelPoints.run(action)
    }
    
    func updatePremiumPoints() {
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let text = playerData.premiumPoints.description
        
        self.labelPremiumPoints.setText(text)
        
        let duration:Double = 0.10
        var actions = [SKAction]()
        actions.append(SKAction.scale(to: 1.5, duration: duration))
        actions.append(SKAction.scale(to: 1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelPremiumPoints.run(action)
    }
    
    override func removeFromParent() {
        self.xpBarSpriteNode = nil
        self.xpBarCircle = nil
        super.removeFromParent()
    }
}

class PlayerDataCardStatistics: Control {
    
    let spriteNodeWidth = 435
    
    let playerDataCardBackground2PositionY = 384
    var playerDataCardBackground2Width:CGFloat = 0
    
    var touchIsMooving = false
    
    var isOpen = false
    
    var buttonConfig:Button!
    var buttonRanking:Button!
    
    override init() {
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        let spriteNode = SKSpriteNode(texture: nil, color: SKColor.white, size: CGSize(width: 1, height: 1))
        
        super.init(spriteNode: spriteNode, size: CGSize(width: self.spriteNodeWidth, height: self.playerDataCardBackground2PositionY), x: 0, y: 0)
        Control.controlList.remove(self)
        self.zPosition = -50
        self.position = self.getPositionWithScreenPosition(CGPoint(x: 0, y: -self.playerDataCardBackground2PositionY))
        
        let control = Control(textureName: "playerDataCardBackground2", y: self.playerDataCardBackground2PositionY)
        self.playerDataCardBackground2Width = control.size.width
        self.addChild(control)
        
        self.buttonConfig = Button(textureName: "buttonConfig", x: 341, y: 75, touchArea:CGSize(width: 32,height: 32))
        self.buttonConfig.isHidden = true//TODO: buttonConfig
        self.addChild(self.buttonConfig)
        
        let fontColor = SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1)
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 10/100)
        
        self.buttonRanking = Button(textureName: "buttonRanking", text: "Ranking", fontSize:10, x: 333, y: 143, touchArea:CGSize(width: 32,height: 32), fontColor:fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: CGPoint(x: 0, y: -1), pressedFontColor: fontColor, fontName: GameFonts.fontName.museo1000, textOffset:CGPoint(x: 0, y: -20))
        self.addChild(self.buttonRanking)
        #if os(iOS)
            self.buttonRanking.addHandler {
                (Control.gameScene.view?.window?.rootViewController as? GameViewController)?.showLeader()
            }
        #endif
        
        self.addChild(Control(textureName: "iconColoredChartPie", x: 74, y: 141))
        
        self.addChild(Control(textureName: "iconAvailableUpdates", x: 79, y: 347))
        self.addChild(Label(color: fontColor, text: "Available Updates", fontSize: 15, x: 217, y: 369, fontName: GameFonts.fontName.museo1000, shadowColor: fontShadowColor, shadowOffset: CGPoint(x: 0, y: -2)))
        
        
        let availableUpdates = [Any]()
        if availableUpdates.count > 0 {
            //TODO: Available Updates
        } else {
            self.addChild(Control(textureName: "iconNoUpdatesAvailable", x: 208, y: 393))
        }
        
        self.addChild(Label(color: fontColor, text: "General Statistics", fontSize: 15, x: 124, y: 160, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000, shadowColor: fontShadowColor, shadowOffset: CGPoint(x: 0, y: -2)))
        
        self.addChild(Control(textureName: "iconPlayerAvatar", x: 79, y: 67))
        
        self.addChild(Label(color: fontColor, text: playerData.name, fontSize: 12, x: 124, y: 83, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000, shadowColor: fontShadowColor, shadowOffset: CGPoint(x: 0, y: -2)))
        
        //TODO GKLocalPlayer ??? update
        if GKLocalPlayer.localPlayer().isAuthenticated {
            self.addChild(Label(color: fontColor, text: "Connected to the Game Center", fontSize: 10, x: 124, y: 97, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500, shadowColor: fontShadowColor, shadowOffset: CGPoint(x: 0, y: -2)))
        }
        
        self.addChild(Control(textureName: "statisticsIcons", x: 81, y: 190))
        
        // winCount
        let winCountLabel = Label(color: fontColor, text: "Victories: ", fontSize: 11, x: 110, y: 207, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500)
        
        let winCountValueXOffset = Int(winCountLabel.calculateAccumulatedFrame().size.width)
        let winCountValue = Label(color: fontColor, text: playerData.winCount.intValue.description, fontSize: 11, x: 110 + winCountValueXOffset, y: 207, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
        
        self.addChild(winCountLabel)
        self.addChild(winCountValue)
        // winCount
        
        
        // MVP
        var bestSpaceshipName = "Unavailable"
        var bestSspaceshipKillCount = 0
        
        for item in playerData.spaceships {
            if let spaceshipData = item as? SpaceshipData {
                if spaceshipData.killCount.intValue > bestSspaceshipKillCount {
                    if let weaponData = (spaceshipData.weapons.anyObject() as? WeaponData) {
                        bestSspaceshipKillCount = spaceshipData.killCount.intValue
                        bestSpaceshipName = Spaceship.displayName(spaceshipData.type.intValue, weaponType: weaponData.type.intValue) + ". Killed ".translation()
                    }
                }
            }
        }
        
        let labelBestSpaceshipLabel = Label(color: fontColor, text: "MVP: ", fontSize: 11, x: 110, y: 235, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
        
        let labelBestSpaceshipNameXOffset = Int(labelBestSpaceshipLabel.calculateAccumulatedFrame().size.width)
        let labelBestSpaceshipName = Label(color: fontColor, text: bestSpaceshipName, fontSize: 11, x: 110 + labelBestSpaceshipNameXOffset, y: 235, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500)
        
        if bestSspaceshipKillCount > 0 {
            let labelBestSpaceshipKillCountXOffset = labelBestSpaceshipNameXOffset + Int(labelBestSpaceshipName.calculateAccumulatedFrame().size.width)
            let labelBestSpaceshipKillCount = Label(color: fontColor, text: bestSspaceshipKillCount.description, fontSize: 11, x: 110 + labelBestSpaceshipKillCountXOffset, y: 235, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
            
            let labelBestSpaceshipKillCountRightXOffset = labelBestSpaceshipKillCountXOffset + Int(labelBestSpaceshipKillCount.calculateAccumulatedFrame().size.width)
            let labelBestSpaceshipKillCountRight = Label(color: fontColor, text: "enemies.", fontSize: 11, x: 110 + labelBestSpaceshipKillCountRightXOffset, y: 235, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500)
            
            self.addChild(labelBestSpaceshipKillCountRight)
            self.addChild(labelBestSpaceshipKillCount)
        }
        
        self.addChild(labelBestSpaceshipLabel)
        self.addChild(labelBestSpaceshipName)
        // MVP
        
        
        
        
        //best winning streak
        let labelWinningStreakLabel = Label(color: fontColor, text: "Best Winning Streak: ", fontSize: 11, x: 110, y: 263, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500)
        
        let labelWinningStreakValueXOffset = Int(labelWinningStreakLabel.calculateAccumulatedFrame().size.width)
        let labelWinningStreakValue = Label(color: fontColor, text: playerData.winningStreakBest.intValue.description, fontSize: 11, x: 110 + labelWinningStreakValueXOffset, y: 263, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
        
        self.addChild(labelWinningStreakValue)
        self.addChild(labelWinningStreakLabel)
        //best winning streak
        
        
        // pointsSum
        let labelPointsSumLabel = Label(color: fontColor, text: "Collected a total of ", fontSize: 11, x: 110, y: 291, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500)
        
        let labelPointsSumXOffset = Int(labelPointsSumLabel.calculateAccumulatedFrame().size.width)
        let labelPointsSumValue = Label(color: fontColor, text: playerData.pointsSum.intValue.description, fontSize: 11, x: 110 + labelPointsSumXOffset, y: 291, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
        
        let iconFragmentsXOffset = labelPointsSumXOffset + Int(labelPointsSumValue.calculateAccumulatedFrame().size.width) + 2
        let labelFragments =  Label(color: fontColor, text: " fragments.", fontSize: 11, x: 110 + iconFragmentsXOffset, y: 291, verticalAlignmentMode: .baseline, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo500)
        
        self.addChild(labelPointsSumLabel)
        self.addChild(labelPointsSumValue)
        self.addChild(labelFragments)
        // pointsSum
        
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 3/100), size: CGSize(width: 1, height: 1)),
            size: CGSize(width: self.spriteNodeWidth,
                height: 10), y: 122))
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 3/100), size: CGSize(width: 1, height: 1)),
            size: CGSize(width: self.spriteNodeWidth,
                height: 10), y: 326))
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 8/100), size: CGSize(width: 1, height: 1)),
            size: CGSize(width: self.spriteNodeWidth,
                height: 2), y: 324))
        
        self.addChild(Control( spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 8/100), size: CGSize(width: 1, height: 1)),
            size: CGSize(width: self.spriteNodeWidth,
                height: 2), y: 120))
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateOnTouchesBegan() {
        self.touchIsMooving = true
    }
    
    func update() {
        if self.touchIsMooving {
            let lastPosition = self.position
            let y:CGFloat = lastPosition.y + Control.dy
            if y > 0 && y < 384 {
                self.run(SKAction.move(by: CGVector(dx: 0, dy: Control.dy), duration: 2/60))
            }
            
            
            Control.gameScene.blackSpriteNode.alpha = 1 - self.position.y/CGFloat(self.playerDataCardBackground2PositionY)
            Control.gameScene.blackSpriteNode.zPosition = 25
            Control.gameScene.blackSpriteNode.isHidden = false
        }
    }
    
    func updateOnTouchesEnded() {
        
        if self.touchIsMooving {
            
            if abs(Control.totalDy) > 16 {
                if Control.totalDy > 0 {
                    self.close()
                } else {
                    self.open()
                }
            } else {
                if self.isOpen {
                    self.forceOpen()
                } else {
                    self.forceClose()
                }
            }
            
            if Control.touchesArray.count <= 0 {
                self.touchIsMooving = false
            }
            
        } else {
            self.close()
        }
    }
    
    func close() {
        if self.isOpen {
            self.isOpen = false
            self.forceClose()
        }
    }
    
    fileprivate func forceClose() {
        self.run(SKAction.move(to: CGPoint(x:0, y: self.playerDataCardBackground2PositionY), duration: 0.25))
        Control.gameScene.blackSpriteNode.run(SKAction.fadeAlpha(to: 0, duration: 0.25), completion: {
            Control.gameScene.blackSpriteNode.isHidden = true
            Control.gameScene.blackSpriteNode.alpha = 1
        }) 
    }
    
    func open() {
        if !self.isOpen {
            self.isOpen = true
            self.forceOpen()
        }
    }
    
    fileprivate func forceOpen() {
        self.run(SKAction.move(to: CGPoint(x:0, y: 0), duration: 0.25))
        Control.gameScene.blackSpriteNode.isHidden = false
        Control.gameScene.blackSpriteNode.run(SKAction.fadeAlpha(to: 1, duration: 0.25))
    }
}
