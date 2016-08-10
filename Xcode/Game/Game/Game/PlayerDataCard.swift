//
//  PlayerDataCard.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/26/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

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

    override init() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        var xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.integerValue)
        
        if playerData.motherShip.xp.integerValue >= xpForNextLevel {
            playerData.motherShip.level = NSNumber(int: playerData.motherShip.level.integerValue + 1)
            playerData.motherShip.xp = NSNumber(integer: playerData.motherShip.xp.integerValue - xpForNextLevel)
            
            Metrics.levelUp()
            if let vc = Control.gameScene.view?.window?.rootViewController as? GameViewController {
                vc.saveLevel(Int(playerData.motherShip.level))
            }
            
            let scene = Control.gameScene
            
            let alertBox = AlertBox(title: "Level Up!", text: "You are now on level " + playerData.motherShip.level.description + "! " + String.winEmoji(), type: AlertBox.messageType.OK)
            alertBox.buttonOK.addHandler({
                scene.setDefaultState()
            })
            scene.setAlertState()
            scene.addChild(alertBox)
        }
        
        xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.integerValue)
        
        super.init(textureName: "playerDataCardBackground", x: -58, y: 0, xAlign: .center, yAlign: .up)
        self.zPosition = 100
        
        self.statistics = PlayerDataCardStatistics()
        self.addChild(self.statistics)
        
        self.loadXPBar(xp: playerData.motherShip.xp.integerValue, xpForNextLevel: xpForNextLevel)
        self.loadLabelXP(playerData.motherShip.xp.description + "/" + xpForNextLevel.description)
        
        
        self.addChild(Control(textureName: "playerDataCardBackground1", x: 166, y: 14))
        
        self.loadLabelLevel(playerData.motherShip.level.description)
        
        self.loadResourcesLabels(playerData.points.integerValue, premiumPoints: playerData.premiumPoints.integerValue)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        self.statistics.update()
    }
    
    func loadResourcesLabels(points:Int, premiumPoints:Int) {
        let valueFontName = GameFonts.fontName.museo1000
        let fontSize = CGFloat(9)
        let pointsColor = SKColor(red: 255/255, green: 162/255, blue: 87/255, alpha: 1)
        let premiumPointsColor = SKColor(red: 119/255, green: 97/255, blue: 174/255, alpha: 1)
        
        let labelPointsValuePosition = CGPoint(x: 287, y: 27)
        
        let labelPremiumPointsValuePosition = CGPoint(x: 287, y: 41)
        
        self.labelPoints = Label(color: pointsColor, text: points.description, fontSize: fontSize, x: Int(labelPointsValuePosition.x), y: Int(labelPointsValuePosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Left, fontName: valueFontName)
        self.addChild(self.labelPoints)
        
        self.labelPremiumPoints = Label(color: premiumPointsColor, text: premiumPoints.description, fontSize: fontSize, x: Int(labelPremiumPointsValuePosition.x), y: Int(labelPremiumPointsValuePosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Left, fontName: valueFontName)
        self.addChild(self.labelPremiumPoints)
    }
    
    func loadLabelLevel(text:String) {
        let fontName = GameFonts.fontName.museo1000
        let positionX = 217
        let positionY = 35
        let fontSize = CGFloat(14)
        let color = SKColor(red: 60/255, green: 75/255, blue: 88/255, alpha: 1)
        let shadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 8/100)
        
        self.labelLevel = Label(color: color, text: text, fontSize: fontSize, x: positionX, y: positionY, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.labelLevelShadow = Label(color: shadowColor, text: text, fontSize: fontSize, x: positionX, y: positionY + 1, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.addChild(self.labelLevelShadow)
        self.addChild(self.labelLevel)
    }
    
    func loadLabelXP(text:String) {
        let fontName = GameFonts.fontName.museo1000
        let positionX = 114
        let positionY = 35
        let fontSize = CGFloat(9)
        let color = SKColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let shadowColor = SKColor(red: 28/255, green: 112/255, blue: 141/255, alpha: 100/100)
        
        self.labelXP = Label(color: color, text: text, fontSize: fontSize, x: positionX, y: positionY, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.labelXPShadow = Label(color: shadowColor, text: text, fontSize: fontSize, x: positionX, y: positionY +  1, verticalAlignmentMode: .Center, horizontalAlignmentMode: .Center, fontName: fontName)
        
        self.addChild(self.labelXPShadow)
        self.addChild(self.labelXP)
    }
    
    func loadXPBar(xp xp:Int, xpForNextLevel:Int) {
        
        let color = SKColor(red: 45/255, green: 195/255, blue: 245/255, alpha: 1)
        let width:CGFloat = 103 * (CGFloat(xp)/CGFloat(xpForNextLevel))
        let height:CGFloat = 17
        let positionX:CGFloat = 166
        let positionY:CGFloat = -26
        
        self.xpBarCircle = SKShapeNode(circleOfRadius: CGFloat(height/2))
        self.xpBarCircle.fillColor = color
        self.xpBarCircle.strokeColor = SKColor.clearColor()
        self.xpBarCircle.position = CGPoint(x: (positionX - width) + (height/2), y: positionY - (height/2))
        
        if width > height/2 {
            let anchorPoint = CGPoint(x: 1, y: 1)
            self.xpBarSpriteNode = SKSpriteNode(texture: nil, color: color, size: CGSize(width: width - (height/2), height: height))
            self.xpBarSpriteNode!.anchorPoint = anchorPoint
            self.xpBarSpriteNode!.position = CGPoint(x: positionX, y: positionY)
            self.addChild(self.xpBarSpriteNode!)
        } else {
            let anchorPoint = CGPoint(x: 1, y: 1)
            self.xpBarSpriteNode = SKSpriteNode(texture: nil, color: color, size: CGSize(width: 1, height: height))
            self.xpBarSpriteNode!.anchorPoint = anchorPoint
            self.xpBarSpriteNode!.position = CGPoint(x: positionX + 1, y: positionY)
            self.addChild(self.xpBarSpriteNode!)
        }
        
        self.addChild(self.xpBarCircle)
    }
    
    private func updateLevel() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        let text = playerData.motherShip.level.description
        
        self.labelLevel.setText(text)
        self.labelLevelShadow.setText(text)
        
        let duration:Double = 0.125
        var actions = [SKAction]()
        actions.append(SKAction.scaleTo(1.5, duration: duration))
        actions.append(SKAction.scaleTo(1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelLevel.runAction(action)
        self.labelLevelShadow.runAction(action)
    }
    
    func updateXP() {
        
        let playerData = MemoryCard.sharedInstance.playerData
        
        var xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.integerValue)
        
        if playerData.motherShip.xp.integerValue >= xpForNextLevel {
            playerData.motherShip.level = NSNumber(int: playerData.motherShip.level.integerValue + 1)
            self.updateLevel()
            playerData.motherShip.xp = NSNumber(integer: playerData.motherShip.xp.integerValue - xpForNextLevel)
            
            Metrics.levelUp()
            if let vc = Control.gameScene.view?.window?.rootViewController as? GameViewController {
                vc.saveLevel(Int(playerData.motherShip.level))
            }
            
            let scene = Control.gameScene
            
            let alertBox = AlertBox(title: "Level Up!", text: "You are now on level " + playerData.motherShip.level.description + "! " + String.winEmoji(), type: AlertBox.messageType.OK)
            alertBox.buttonOK.addHandler({
                scene.setDefaultState()
            })
            scene.setAlertState()
            scene.addChild(alertBox)
        }
        
        xpForNextLevel = GameMath.xpForNextLevel(level: playerData.motherShip.level.integerValue)
        
        let text = playerData.motherShip.xp.description + "/" + xpForNextLevel.description
        
        self.labelXP.setText(text)
        self.labelXPShadow.setText(text)
        
        let duration:Double = 0.125
        var actions = [SKAction]()
        actions.append(SKAction.scaleTo(1.5, duration: duration))
        actions.append(SKAction.scaleTo(1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelXP.runAction(action)
        self.labelXPShadow.runAction(action)
        
        let positionX:CGFloat = 166
        let positionY:CGFloat = -26
        let width:CGFloat = 103 * (CGFloat(playerData.motherShip.xp.integerValue)/CGFloat(xpForNextLevel))
        let height:CGFloat = 17
        
        self.xpBarCircle.position = CGPoint(x: (positionX - width) + (height/2), y: positionY - (height/2))
        
        if let xpBarSpriteNode = self.xpBarSpriteNode {
            if width > height/2 {
                xpBarSpriteNode.hidden = false
                xpBarSpriteNode.size = CGSize(width: width - (height/2), height: height)
                xpBarSpriteNode.position = CGPoint(x: positionX, y: positionY)
            } else {
                xpBarSpriteNode.hidden = true
            }
        }
    }
    
    func updatePoints() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        let text = playerData.points.description
        
        self.labelPoints.setText(text)
        
        let duration:Double = 0.125
        var actions = [SKAction]()
        actions.append(SKAction.scaleTo(1.5, duration: duration))
        actions.append(SKAction.scaleTo(1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelPoints.runAction(action)
    }
    
    func updatePremiumPoints() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        let text = playerData.premiumPoints.description
        
        self.labelPremiumPoints.setText(text)
        
        let duration:Double = 0.125
        var actions = [SKAction]()
        actions.append(SKAction.scaleTo(1.5, duration: duration))
        actions.append(SKAction.scaleTo(1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelPremiumPoints.runAction(action)
    }
}

class PlayerDataCardStatistics: Control {
    
    let spriteNodeWidth = 435
    
    let playerDataCardBackground2PositionY = 384
    var playerDataCardBackground2Width:CGFloat = 0
    
    var touchIsMooving = false
    
    var isOpen = false
    
    override init() {
        
        let spriteNode = SKSpriteNode(texture: nil, color: SKColor.whiteColor(), size: CGSize(width: 1, height: 1))
        
        super.init(spriteNode: spriteNode, size: CGSize(width: self.spriteNodeWidth, height: self.playerDataCardBackground2PositionY), x: 0, y: 0)
        Control.controlList.remove(self)
        self.zPosition = -50
        self.position = self.getPositionWithScreenPosition(CGPoint(x: 0, y: -self.playerDataCardBackground2PositionY))
        
        let control = Control(textureName: "playerDataCardBackground2", y: self.playerDataCardBackground2PositionY)
        self.playerDataCardBackground2Width = control.size.width
        self.addChild(control)
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
            var y:CGFloat = lastPosition.y + Control.dy
            if y < 0 { y = 0 }
            if Int(y) > self.playerDataCardBackground2PositionY { y = CGFloat(self.playerDataCardBackground2PositionY) }
            self.position = CGPoint(x: lastPosition.x, y: y)
            
            Control.gameScene.blackSpriteNode.alpha = 1 - self.position.y/CGFloat(self.playerDataCardBackground2PositionY)
            Control.gameScene.blackSpriteNode.zPosition = 25
            Control.gameScene.blackSpriteNode.hidden = false
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
    
    private func forceClose() {
        self.runAction(SKAction.moveTo(CGPoint(x:0, y: self.playerDataCardBackground2PositionY), duration: 0.25))
        Control.gameScene.blackSpriteNode.runAction(SKAction.fadeAlphaTo(0, duration: 0.25)) {
            Control.gameScene.blackSpriteNode.hidden = true
            Control.gameScene.blackSpriteNode.alpha = 1
        }
    }
    
    func open() {
        if !self.isOpen {
            self.isOpen = true
            self.forceOpen()
        }
    }
    
    private func forceOpen() {
        self.runAction(SKAction.moveTo(CGPoint(x:0, y: 0), duration: 0.25))
        Control.gameScene.blackSpriteNode.hidden = false
        Control.gameScene.blackSpriteNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.25))
    }
}
