//
//  GameStore.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/1/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameStore: Box {
    
    static var sharedInstance: GameStore?
    
    var explosionSoundEffect:SoundEffect!
    
    var buttonClose:Button!
    var initTime: Double = 0
    
    var box:CropBox!
    
    var scrollNode:SKNode = SKNode()
    
    var storeItens = [StoreItem]()
    
    var labelPoints:Label!
    var labelPremiumPoints:Label!

    init() {
        super.init(textureName: "gameStoreBackground")
        
        let gameScene = Control.gameScene
        gameScene.blackSpriteNode.hidden = false
        gameScene.blackSpriteNode.alpha = 1
        gameScene.blackSpriteNode.zPosition = 100000
        self.zPosition = 1000000
        gameScene.setAlertState()
        
        
        self.buttonClose = Button(textureName: "buttonStoreClose", x: 250, y: 10, touchArea:CGSize(width: 64,height: 64))
        self.addChild(self.buttonClose)
        
        self.addChild(Label(color: SKColor.whiteColor(), text: "SPACE SHOP" , fontSize: 12, x: 16, y: 23, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left))
        
        self.addChild(Label(color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), text: "Welcome to the SPACE SHOP!" , fontSize: 12, x: 73, y: 65, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left))
        
        self.addChild(MultiLineLabel(text: "This is the best market in the galaxy. Use your resources wisely and strategically.", color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), fontSize: 12, x: 73, y: 82, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo500, horizontalAlignmentMode: .Left))
        
        self.box = CropBox(textureName: "mask282x370", x: 1, y: 166, xAlign: .left, yAlign: .up)
        self.addChild(self.box.cropNode)
        self.box.addChild(self.scrollNode)
        
        
        self.storeItens.append(StoreItem(iconImageNamed: "iconPointsPack0", type: StoreItem.types.points, x: 13, y: 37, price: 1, amount: Int(10000 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconPointsPack1", type: StoreItem.types.points, x: 100, y: 37, price: 10, amount: Int(100000 * 1.1)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconPointsPack2", type: StoreItem.types.points, x: 188, y: 37, price: 100, amount: Int(1000000 * 1.2)))
        
        self.storeItens.append(StoreItem(productIdentifier: "com.PabloHenri91.GameIV.premiumPointsPack0", iconImageNamed: "iconPremiumPointsPack0", type: StoreItem.types.premiumPoints, x: 13, y: 144, price: 0.99, amount: Int(100 * 1.0)))
        self.storeItens.append(StoreItem(productIdentifier: "com.PabloHenri91.GameIV.premiumPointsPack1", iconImageNamed: "iconPremiumPointsPack1", type: StoreItem.types.premiumPoints, x: 100, y: 144, price: 4.99, amount: Int(500 * 1.1)))
        self.storeItens.append(StoreItem(productIdentifier: "com.PabloHenri91.GameIV.premiumPointsPack2", iconImageNamed: "iconPremiumPointsPack2", type: StoreItem.types.premiumPoints, x: 188, y: 144, price: 9.99, amount: Int(1000 * 1.2)))
        
        self.storeItens.append(StoreItem(iconImageNamed: "iconXPBoost", type: StoreItem.types.xPBoost, x: 13, y: 301, price: 10, amount: Int(1 * 1.0), typeIndex: 0))
        self.storeItens.append(StoreItem(iconImageNamed: "iconXPBoost", type: StoreItem.types.xPBoost, x: 100, y: 301, price: 15, amount: Int(3 * 1.0), typeIndex: 1))
        self.storeItens.append(StoreItem(iconImageNamed: "iconXPBoost", type: StoreItem.types.xPBoost, x: 188, y: 301, price: 25, amount: Int(7 * 1.0), typeIndex: 2))
        
        self.storeItens.append(StoreItem(iconImageNamed: "iconEnergyPack0", type: StoreItem.types.energy, x: 13, y: 409, price: 1, amount: Int(2 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconEnergyPack1", type: StoreItem.types.energy, x: 100, y: 409, price: 2, amount: Int(4 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconEnergyPack2", type: StoreItem.types.energy, x: 188, y: 409, price: 25, amount: Int(-1 * 1.0)))
        
        self.scrollNode.addChild(Label(color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), text: "FRAGMENTS AND DIAMONDS" , fontSize: 12, x: 13, y: 17, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left))
        
        self.scrollNode.addChild(Control(spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 236/255, green: 236/255, blue: 236/255,
            alpha: 100/100), size: CGSize(width: 1, height: 1)),
            y: 259, size: CGSize(width: self.size.width,
                height: 1)))
        
        self.scrollNode.addChild(Label(color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), text: "BOOSTS AND ENERGY" , fontSize: 12, x: 13, y: 282, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000, horizontalAlignmentMode: .Left))
        
        for storeItem in self.storeItens {
            self.scrollNode.addChild(storeItem)
        }
        
        self.initTime = GameScene.currentTime
        
        self.loadSoundEffects()
        
        self.storeItensUpdateAvailable()
        
        let control = Control(spriteNode: SKSpriteNode(texture: nil, color: SKColor(red: 0/255, green: 0/255, blue: 0/255,
            alpha: 11/100), size: CGSize(width: 1, height: 1)),
                        y: 166, size: CGSize(width: self.size.width - 2,
                            height: 2))
        control.position.x = 1
        self.addChild(control)
        
        let playerData = MemoryCard.sharedInstance.playerData
        self.loadResourcesLabels(playerData.points.integerValue, premiumPoints: playerData.premiumPoints.integerValue)
        
        self.jump()
        
        GameStore.sharedInstance = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updatePoints() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        let text = playerData.points.description
        
        self.labelPoints.setText(text)
        
        let duration:Double = 0.10
        var actions = [SKAction]()
        actions.append(SKAction.scaleTo(1.5, duration: duration))
        actions.append(SKAction.scaleTo(1.0, duration: duration))
        let action = SKAction.sequence(actions)
        
        self.labelPoints.runAction(action)
    }
    
    func updatePremiumPoints() {
        let playerData = MemoryCard.sharedInstance.playerData
        
        let text = playerData.premiumPoints.description
        
        if playerData.premiumPoints.integerValue > Int(self.labelPremiumPoints.getText()) {
            let duration:Double = 0.10
            var actions = [SKAction]()
            actions.append(SKAction.scaleTo(1.5, duration: duration))
            actions.append(SKAction.scaleTo(1.0, duration: duration))
            let action = SKAction.sequence(actions)
            
            self.labelPremiumPoints.runAction(action)
        }
        
        self.labelPremiumPoints.setText(text)
    }
    
    func loadResourcesLabels(points:Int, premiumPoints:Int) {
        let valueFontName = GameFonts.fontName.museo1000
        let fontSize = CGFloat(12)
        let pointsColor = SKColor(red: 255/255, green: 162/255, blue: 87/255, alpha: 1)
        let premiumPointsColor = SKColor(red: 119/255, green: 97/255, blue: 174/255, alpha: 1)
        let shadowOffset = CGPoint(x: 0, y: -2)
        let shadowColor = SKColor(red: 0, green: 0, blue: 0, alpha: 11/100)
        
        let labelPointsValuePosition = CGPoint(x: 43, y: 147)
        
        let labelPremiumPointsValuePosition = CGPoint(x: 166, y: 147)
        
        self.labelPoints = Label(color: pointsColor, text: points.description, fontSize: fontSize, x: Int(labelPointsValuePosition.x), y: Int(labelPointsValuePosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Left, fontName: valueFontName, shadowOffset: shadowOffset, shadowColor: shadowColor)
        self.addChild(self.labelPoints)
        
        self.labelPremiumPoints = Label(color: premiumPointsColor, text: premiumPoints.description, fontSize: fontSize, x: Int(labelPremiumPointsValuePosition.x), y: Int(labelPremiumPointsValuePosition.y), verticalAlignmentMode: .Center, horizontalAlignmentMode: .Left, fontName: valueFontName, shadowOffset: shadowOffset, shadowColor: shadowColor)
        self.addChild(self.labelPremiumPoints)
    }
    
    func loadSoundEffects() {
        self.explosionSoundEffect = SoundEffect(soundType: SoundEffect.effectTypes.explosion, node: self)
    }
    
    func close() {
        self.removeFromParent()
        Control.gameScene.setDefaultState()
    }
    
    func touchEnded(touch: UITouch) {
        var point = touch.locationInNode(self)
        
        if self.buttonClose.containsPoint(point) {
            if GameScene.currentTime - self.initTime > 0.5 {
                self.close()
            }
            return
        }
        
        point = touch.locationInNode(self.scrollNode)
        for storeItem in self.storeItens {
            if storeItem.containsPoint(point) {
                
                storeItem.jump()
                
                let playerData = MemoryCard.sharedInstance.playerData
                
                switch storeItem.type {
                case .points:
                    
                    if playerData.premiumPoints.doubleValue >= storeItem.price {
                        playerData.premiumPoints = playerData.premiumPoints.doubleValue - storeItem.price
                        Control.gameScene.updatePremiumPoints()
                        self.updatePremiumPoints()
                        
                        playerData.points = playerData.points.integerValue + storeItem.amount
                        Control.gameScene.updatePoints()
                        self.updatePoints()
                        self.feedback(storeItem)
                    } else {
                        //TODO: não tem diamantes para comprar
                        print("não tem diamantes para comprar")
                    }
                    
                    break
                case .premiumPoints:
                    if storeItem.productIdentifier != "" {
                        //if Metrics.canSendEvents() {
                            #if os(iOS)
                                IAPHelper.sharedInstance.requestProduct(storeItem.productIdentifier)
                            #endif
                        //}
                        
                    }
                    break
                case .xPBoost:
                    
                    Boost.reloadBoosts()
                    
                    if Boost.activeBoosts.count <= 0 {
                        playerData.addBoostData(MemoryCard.sharedInstance.newBoostData(storeItem.typeIndex))
                        Boost.reloadBoosts()
                        self.feedback(storeItem)
                    }
                    
                    break
                case .energy:
                    if playerData.premiumPoints.doubleValue >= storeItem.price {
                        
                        if let battery = playerData.battery {
                            
                            if battery.charge != -1 {
                                if storeItem.amount > 0 {
                                    playerData.premiumPoints = playerData.premiumPoints.doubleValue - storeItem.price
                                    Control.gameScene.updatePremiumPoints()
                                    self.updatePremiumPoints()
                                    
                                    battery.charge = battery.charge.integerValue + storeItem.amount
                                    self.feedback(storeItem)
                                } else {
                                    playerData.premiumPoints = playerData.premiumPoints.doubleValue - storeItem.price
                                    Control.gameScene.updatePremiumPoints()
                                    self.updatePremiumPoints()
                                    
                                    battery.charge = -1
                                    battery.lastCharge = NSDate()
                                    
                                    self.feedback(storeItem)
                                }
                            } else {
                                print("ja estava com o boost ativo")
                            }
                        }
                    } else {
                        //TODO: não tem diamantes para comprar
                        print("não tem diamantes para comprar")
                    }
                    break
                }
                return
            }
        }
    }
    
    func update() {
        
        var dy = Control.dy
        
        if dy < 0 {
            if self.scrollNode.position.y + dy < 0 {
                dy = 0 - self.scrollNode.position.y
            }
        } else {
            if self.scrollNode.position.y + dy > 142 {
                dy = 142 - self.scrollNode.position.y
            }
        }
        self.scrollNode.position.y = self.scrollNode.position.y + dy
    }
    
    func storeItensUpdateAvailable() {
        for storeItem in self.storeItens {
            storeItem.updateAvailable()
        }
    }
    
    func purchasedItem(productIdentifier: String) {
        
        for storeItem in self.storeItens {
            
            if productIdentifier == storeItem.productIdentifier {
                
                let playerData = MemoryCard.sharedInstance.playerData
                
                switch storeItem.type {
                    
                case .premiumPoints:
                    playerData.premiumPoints = playerData.premiumPoints.integerValue + storeItem.amount
                    Control.gameScene.updatePremiumPoints()
                    self.updatePremiumPoints()
                    
                    Metrics.purchasedPremiumPointsAtGameStore(storeItem)
                    
                    self.runAction({let a = SKAction(); a.duration = 1; return a}(), completion: { [weak self] in
                        self?.feedback(storeItem)
                    })
                    
                    break
                default:
                    #if DEBUG
                        //fatalError()
                    #endif
                    break
                }
                return // encontrou o productIdentifier
            }
        }
        
        #if DEBUG
            fatalError()
        #endif
    }
    
    func feedback(storeItem: StoreItem) {
        self.explosionSoundEffect.play()
        let particles = SKEmitterNode(fileNamed: "explosion.sks")!
        
        particles.particleTexture = SKTexture(imageNamed: storeItem.iconImageNamed)
        
        particles.zPosition = self.zPosition + 1000000
        
        particles.particleBlendMode = .Alpha
        
        switch storeItem.type {
        case .points:
            particles.numParticlesToEmit = min(storeItem.amount/1000, 1000)
            break
        case .premiumPoints:
            particles.numParticlesToEmit = min(storeItem.amount, 1000)
            break
        case .xPBoost:
            particles.numParticlesToEmit = min(storeItem.amount*100, 1000)
            break
        case .energy:
            particles.numParticlesToEmit = min(storeItem.amount, 1000)
            if particles.numParticlesToEmit <= 0 {
                particles.numParticlesToEmit = 1000
            }
            break
        }
        
        particles.particleSpeedRange = 1000
        
        particles.particlePositionRange = CGVector(dx: storeItem.size.width, dy: storeItem.size.height)
        
        if let parent = self.parent {
            
            particles.position = parent.convertPoint(storeItem.position, fromNode: storeItem.parent!)
            particles.position.x = particles.position.x + storeItem.size.width/2
            particles.position.y = particles.position.y - storeItem.size.height/2
            
            parent.addChild(particles)
            
            let action = SKAction()
            action.duration = 1
            
            particles.runAction(action, completion: { [weak particles] in
                particles?.removeFromParent()
                })
            
            
            switch storeItem.type {
                
            case .points, .premiumPoints, .energy:
                
                let label = Label(color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), text: "+"+storeItem.amount.description, fontSize: 12, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 11/100), shadowOffset: CGPoint(x: 0, y: -2))
                label.position = particles.position
                label.zPosition = particles.zPosition + 1
                parent.addChild(label)
                
                let duration:Double = 1
                
                label.runAction(SKAction.group([
                    SKAction.moveBy(CGVector(dx: Int.random(min: -100, max: 100), dy: 100), duration: duration),
                    SKAction.fadeAlphaTo(0, duration: duration),
                    SKAction.rotateByAngle(CGFloat.random(min: CGFloat(-M_PI), max: CGFloat(M_PI)), duration: duration)
                    ])) {
                    label.removeFromParent()
                }
                
                break
                
            default:
                break
            }
        }
    }
}


class StoreItem: Control {
    
    enum types {
        case points
        case premiumPoints
        case xPBoost
        case energy
    }
    
    var type: types
    
    var amount: Int
    var price: Double
    
    var unavailableEffect:SKSpriteNode!
    
    var iconImageNamed:String = ""
    
    var typeIndex = 0
    
    override init() {
        fatalError()
    }
    
    var productIdentifier = ""
    
    init(productIdentifier: String = "", iconImageNamed: String, type: types, x: Int, y: Int, price: Double, amount: Int, typeIndex: Int = 0) {
        
        self.amount = amount
        self.price = price
        self.type = type
        self.productIdentifier = productIdentifier
        self.iconImageNamed = iconImageNamed
        
        var borderColor = SKColor.blackColor()
        var priceText = ""
        var amountText = ""
        let labelPriceX = 40
        
        switch type {
        case .points:
            borderColor = SKColor(red: 255/255, green: 162/255, blue: 87/255, alpha: 1)
            priceText = Int(price).description + "  "
            amountText = amount.description
            break
        case .premiumPoints:
            borderColor = SKColor(red: 119/255, green: 97/255, blue: 174/255, alpha: 1)
            priceText = "$" + price.description
            amountText = amount.description
            break
        case .xPBoost:
            borderColor = SKColor(red: 45/255, green: 195/255, blue: 245/255, alpha: 1)
            priceText = Int(price).description + "  "
            amountText = amount.description + (amount > 1 ? " DAYS".translation() : " DAY".translation())
            break
        case .energy:
            borderColor = SKColor(red: 238/255, green: 172/255, blue: 52/255, alpha: 1)
            priceText = Int(price).description + "  "
            if amount > 0 {
                amountText = amount.description + (amount > 1 ? " CHARGES".translation() : " CHARGE".translation())
            } else {
                if amount == -1 {
                    amountText = "24 HOURS"
                }
            }
            
            break
        }
        super.init(textureName: "storeItemBackground", x: x, y: y)
        
        let spriteNode = SKSpriteNode(texture: SKTexture(imageNamed: "storeItemBorder"))
        spriteNode.color = borderColor
        spriteNode.colorBlendFactor = 1
        self.addChild(Control(spriteNode: spriteNode))
        
        let labelPrice = Label(color: SKColor.whiteColor(), text: priceText, fontSize: 12, x: labelPriceX, y: 86, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 11/100), shadowOffset: CGPoint(x: 0, y: -2))
        self.addChild(labelPrice)
        
        self.addChild(Label(color: SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1), text: amountText, fontSize: 12, x: labelPriceX, y: 62, fontName: GameFonts.fontName.museo1000, shadowColor: SKColor(red: 0, green: 0, blue: 0, alpha: 11/100), shadowOffset: CGPoint(x: 0, y: -2)))
        
        let iconSpriteNode = SKSpriteNode(imageNamed: iconImageNamed)
        iconSpriteNode.position = CGPoint(x: 40, y: -29)
        self.addChild(iconSpriteNode)
        
        switch type {
        case .points, .xPBoost, .energy:
            let spriteNode = SKSpriteNode(imageNamed: "iconPremiumPoitsForGameStore")
            spriteNode.position = CGPoint(x: labelPrice.calculateAccumulatedFrame().size.width/2 + spriteNode.size.width/2 + 1, y: -1)
            labelPrice.addChild(spriteNode)
            labelPrice.position.x = labelPrice.position.x - spriteNode.size.width/2
            break
        case .premiumPoints:
            break
        }
        
        self.unavailableEffect = SKSpriteNode(texture: SKTexture(imageNamed: "storeItemBackground"))
        self.unavailableEffect.hidden = true
        self.unavailableEffect.color = SKColor.blackColor()
        self.unavailableEffect.alpha = 0.5
        self.unavailableEffect.colorBlendFactor = 1
        self.addChild(Control(spriteNode: self.unavailableEffect))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateAvailable() {
        if self.productIdentifier != "" {
            //if Metrics.canSendEvents() {
                #if os(iOS)
                    self.unavailableEffect.hidden = !IAPHelper.sharedInstance.isPurchasing
                #endif
            //}
        }
    }
    
    override func removeFromParent() {
        self.unavailableEffect = nil
        super.removeFromParent()
    }
}
