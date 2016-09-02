//
//  GameStore.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 9/1/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class GameStore: Box {
    
    var buttonClose:Button!
    var initTime: Double = 0
    
    var box:CropBox!
    
    var scrollNode:SKNode = SKNode()
    
    var storeItens = [StoreItem]()

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
        
        self.box = CropBox(textureName: "mask282x370", x: 1, y: 126, xAlign: .left, yAlign: .up)
        self.addChild(self.box.cropNode)
        self.box.addChild(self.scrollNode)
        
        
        self.storeItens.append(StoreItem(iconImageNamed: "iconPointsPack0", type: StoreItem.types.points, x: 13, y: 37, price: 1, amount: Int(10000 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconPointsPack1", type: StoreItem.types.points, x: 100, y: 37, price: 10, amount: Int(100000 * 1.1)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconPointsPack2", type: StoreItem.types.points, x: 188, y: 37, price: 100, amount: Int(1000000 * 1.2)))
        
        self.storeItens.append(StoreItem(iconImageNamed: "iconPremiumPointsPack0", type: StoreItem.types.premiumPoints, x: 13, y: 144, price: 0.99, amount: Int(100 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconPremiumPointsPack1", type: StoreItem.types.premiumPoints, x: 100, y: 144, price: 4.99, amount: Int(500 * 1.1)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconPremiumPointsPack2", type: StoreItem.types.premiumPoints, x: 188, y: 144, price: 9.99, amount: Int(1000 * 1.2)))
        
        self.storeItens.append(StoreItem(iconImageNamed: "iconXPBoost", type: StoreItem.types.xPBoost, x: 13, y: 301, price: 10, amount: Int(1 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconXPBoost", type: StoreItem.types.xPBoost, x: 100, y: 301, price: 15, amount: Int(3 * 1.0)))
        self.storeItens.append(StoreItem(iconImageNamed: "iconXPBoost", type: StoreItem.types.xPBoost, x: 188, y: 301, price: 25, amount: Int(7 * 1.0)))
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func touchEnded(touch: UITouch) {
        let point = touch.locationInNode(self)
        
        if self.buttonClose.containsPoint(point) {
            if GameScene.currentTime - self.initTime > 0.5 {
                self.removeFromParent()
                Control.gameScene.setDefaultState()
            }
            return
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
}


class StoreItem: Control {
    
    enum types {
        case points
        case premiumPoints
        case xPBoost
        case energy
    }
    
    override init() {
        fatalError()
    }
    
    init(iconImageNamed: String, type: types, x: Int, y: Int, price: Double, amount: Int) {
        
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
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    
    
    
    
}
