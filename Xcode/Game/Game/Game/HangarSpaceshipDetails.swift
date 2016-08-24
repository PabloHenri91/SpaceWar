//
//  HangarSpaceshipDetails.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 16/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarSpaceshipDetails: Box {
    
    var spaceship: Spaceship
    var buttonCancel: Button!
    var buttonUpgrade: Button!
    
    var labelLifeValue:Label!
    var labelDamageValue:Label!
    var labelLifeUpgrade:Label!
    var labelDamageUpgrade:Label!
    
    var labelLevel:Label!
    
    var buttonGoToFactory:Button!
    
    init(spaceship:Spaceship, showUpgrade: Bool = true) {
        
        self.spaceship = spaceship
        
        var imageName = ""
        var rarityColor:SKColor
        
        switch self.spaceship.type.rarity {
        case .common:
            imageName = "hangarCommomSpaceshipCardUpgrade"
            rarityColor = SKColor(red: 63/255, green: 119/255, blue: 73/255, alpha: 1)
            break
        case .rare:
            imageName = "hangarRareSpaceshipCardUpgrade"
            rarityColor = SKColor(red: 164/255, green: 69/255, blue: 48/255, alpha: 1)
            break
        case .epic:
            imageName = "hangarEpicSpaceshipCardUpgrade"
            rarityColor = SKColor(red: 65/255, green: 70/255, blue: 123/255, alpha: 1)
            break
        case .legendary:
            imageName = "hangarLegendarySpaceshipCardUpgrade"
            rarityColor = SKColor(red: 76/255, green: 60/255, blue: 77/255, alpha: 1)
            break
        }
        
        super.init(textureName: imageName)
        
        self.buttonCancel = Button(textureName: "cancelButtonGray", x: 246, y: 10,  top: 10, bottom: 10, left: 10, right: 10)
        self.addChild(self.buttonCancel)
        
        self.buttonCancel.addHandler({ [weak self] in
            self?.removeFromParent()
            })
        
        let labelTitle = Label(color:SKColor.whiteColor() ,text: self.spaceship.type.name.uppercaseString + " + " + self.spaceship.weapon!.type.name.uppercaseString , fontSize: 11, x: 93, y: 22, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelTitle)
        
        
        let labelRarity = Label(color:rarityColor ,text: self.spaceship.type.rarity.rawValue.uppercaseString , fontSize: 11, x: 50, y: 22, horizontalAlignmentMode: .Center, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelRarity)
        
        let hangarSpaceshipBackground = Control(textureName: "hangarSpaceshipBackground", x: 14, y: 52)
        self.addChild(hangarSpaceshipBackground)
        
        if showUpgrade {
            let lifeUpgradeBackground = Control(textureName: "betterAttribute", x: 11, y: 192)
            self.addChild(lifeUpgradeBackground)
            
            let damageUpgradeBackground = Control(textureName: "betterAttribute", x: 136, y: 192)
            self.addChild(damageUpgradeBackground)
        }
        
        var spaceshipImage:Spaceship!
        
        if let spaceshipData = spaceship.spaceshipData {
            spaceshipImage = Spaceship(spaceshipData: spaceshipData, loadPhysics: false)
        } else {
            spaceshipImage = Spaceship(type: spaceship.type.index, level: spaceship.level)
            if let weapon = spaceship.weapon {
                spaceshipImage.addWeapon(Weapon(type: weapon.type.index, level: spaceship.level))
            }
        }
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 49, y: 78)
        spaceshipImage.resetPosition()
        
        self.labelLevel = Label(color:SKColor.whiteColor() ,text: "Level " + self.spaceship.level.description , fontSize: 13, x: 49, y: 113, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelLevel)
        
        let labelDescription = MultiLineLabel(text: "This is a battleship. Do upgrades to makes it stronger and defeat your enemies.", maxWidth: 168, x: 180, y: 73, fontSize: 11)
        self.addChild(labelDescription)
        
        let labelAtributte = Label(text: "ATTRIBUTES" , fontSize: 14, x: 14, y: 169, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelAtributte)
        
        
        let lifeIcon = Control(textureName: "lifeIcon", x: 14, y: 196)
        self.addChild(lifeIcon)
        
        let damageIcon = Control(textureName: "damageIcon", x: 139, y: 194)
        self.addChild(damageIcon)
        
        let respawnIcon = Control(textureName: "respawnIcon", x: 14, y: 228)
        self.addChild(respawnIcon)
        
        let fireRateIcon = Control(textureName: "fireRateIcon", x: 139, y: 228)
        self.addChild(fireRateIcon)
        
        let speedIcon = Control(textureName: "speedIcon", x: 13, y: 261)
        self.addChild(speedIcon)
        
        let rangeIcon = Control(textureName: "rangeIcon", x: 139, y: 260)
        self.addChild(rangeIcon)
        

        
        let labelLife = Label(text: "LIFE: " , fontSize: 11, x: 35, y: 202, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelLife)
        
        let labelDamage = Label(text: "DAMAGE: " , fontSize: 11, x: 160, y: 202, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelDamage)
        
        let labelRespawn = Label(text: "RESPAWN: " , fontSize: 11, x: 35, y: 235, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelRespawn)
        
        let labelFireRate = Label(text: "FIRE RATE: " , fontSize: 11, x: 160, y: 235, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelFireRate)
        
        let labelSpeed = Label(text: "SPEED: " , fontSize: 11, x: 35, y: 268, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelSpeed)
        
        let labelRange = Label(text: "RANGE: " , fontSize: 11, x: 160, y: 268, horizontalAlignmentMode: .Left, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelRange)
        
        
        let life = GameMath.spaceshipMaxHealth(level: self.spaceship.level, type: self.spaceship.type)
        self.labelLifeValue = Label(text: life.description , fontSize: 11, x: Int(labelLife.position.x + labelLife.calculateAccumulatedFrame().width), y: 207, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelLifeValue)
        
        self.labelDamageValue = Label(text: self.spaceship.weapon!.damage.description , fontSize: 11, x: Int(labelDamage.position.x + labelDamage.calculateAccumulatedFrame().width), y: 207, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelDamageValue)
        
        let labelRespawnValue = Label(text: "5s" , fontSize: 11, x: Int(labelRespawn.position.x + labelRespawn.calculateAccumulatedFrame().width), y: 240, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelRespawnValue)
        
        let fireRate = 1 / self.spaceship.weapon!.fireInterval
        let labelFireRateValue = Label(text: fireRate.description + "/S" , fontSize: 11, x: Int(labelFireRate.position.x + labelFireRate.calculateAccumulatedFrame().width), y: 240, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelFireRateValue)
        
        let labelSpeedValue = Label(text: GameMath.spaceshipSpeedAtribute(level: self.spaceship.level, type: self.spaceship.type).description, fontSize: 11, x: Int(labelSpeed.position.x + labelSpeed.calculateAccumulatedFrame().width), y: 273, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelSpeedValue)
        
        let labelRangeValue = Label(text: self.spaceship.weapon!.type.range.description , fontSize: 11, x: Int(labelRange.position.x + labelRange.calculateAccumulatedFrame().width), y: 273, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelRangeValue)
        
        if showUpgrade {
            let lifeUpgrade = GameMath.spaceshipMaxHealth(level: self.spaceship.level + 1, type: self.spaceship.type) - life
            self.labelLifeUpgrade = Label(text: "+ " + lifeUpgrade.description , fontSize: 11, x: Int(labelLifeValue.position.x + labelLifeValue.calculateAccumulatedFrame().width), y: 207, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelLifeUpgrade)
            
            let damageUpgrade = GameMath.weaponDamage(level: self.spaceship.level + 1, type: self.spaceship.weapon!.type) - self.spaceship.weapon!.damage
            self.labelDamageUpgrade = Label(text: "+ " + damageUpgrade.description , fontSize: 11, x: Int(labelDamageValue.position.x + labelDamageValue.calculateAccumulatedFrame().width), y: 207, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDamageUpgrade)
        }
        
        
        let labelUpgrade = Label(text: "UPGRADE" , fontSize: 14, x: 141, y: 315, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelUpgrade)
        
        
        let fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        let textOffset = CGPoint(x: 8, y: 0)
        self.buttonUpgrade = Button(textureName: "buttonGray82x23", text: GameMath.spaceshipUpgradeCost(level: self.spaceship.level, type: self.spaceship.type).description, fontSize: 13, x: 100, y: 337, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName, textOffset: textOffset)
        self.addChild(self.buttonUpgrade)
        
        self.buttonUpgrade.addChild(Control(textureName: "fragIconForButton", x: 6, y: 5))
        
        
        self.setScale(0)
        self.position = CGPoint(x: Display.sceneSize.width/2, y: -Display.sceneSize.height/2)
        
        let x = Display.sceneSize.width/2 - (self.size.width/2) * 1.1
        let y = Display.sceneSize.height/2  - (self.size.height/2) * 1.1
        
        
        
        let duration = 0.1
        let action1 = SKAction.group([
            SKAction.scaleTo(1.1, duration: duration),
            SKAction.moveTo(self.getPositionWithScreenPosition(CGPoint(x: x, y: y)), duration: duration)
            ])
        
        let action2 = SKAction.group([
            SKAction.scaleTo(1, duration: duration),
            SKAction.moveTo(self.getPositionWithScreenPosition(self.screenPosition), duration: duration)
            ])
        
        self.runAction(SKAction.sequence([action1, action2]))
        
    }
    
    func loadButtonGoToFactory() {
        
        let fontShadowColor = SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 1)
        let fontShadowOffset = CGPoint(x: 0, y: -2)
        let fontName = GameFonts.fontName.museo1000
        
        self.buttonGoToFactory = Button(textureName: "buttonDarkBlue131x30", text: "GO TO FACTORY", fontSize: 11, x: 77, y: 316, fontColor: SKColor.whiteColor(), fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName)
        self.addChild(self.buttonGoToFactory)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func reload() {
        self.labelLevel.setText("Level " + self.spaceship.level.description)
        
        let life = GameMath.spaceshipMaxHealth(level: self.spaceship.level, type: self.spaceship.type)
        self.labelLifeValue.setText(life.description)
        
        let damage = GameMath.weaponDamage(level: self.spaceship.level, type: self.spaceship.weapon!.type)
        self.labelDamageValue.setText(damage.description)
        
        let lifeUpgrade = GameMath.spaceshipMaxHealth(level: self.spaceship.level + 1, type: self.spaceship.type) - life
        self.labelLifeUpgrade.setText("+ " + lifeUpgrade.description)
        self.labelLifeUpgrade.position.x = labelLifeValue.position.x + labelLifeValue.calculateAccumulatedFrame().width
        
        let damageUpgrade = GameMath.weaponDamage(level: self.spaceship.level + 1, type: self.spaceship.weapon!.type) - damage
        self.labelDamageUpgrade.setText("+ " + damageUpgrade.description)
        self.labelDamageUpgrade.position.x = labelDamageValue.position.x + labelDamageValue.calculateAccumulatedFrame().width
        
        self.buttonUpgrade.removeFromParent()
        
        let fontColor = SKColor.whiteColor()
        let fontShadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100)
        let fontShadowOffset = CGPoint(x: 0, y: -1)
        let fontName = GameFonts.fontName.museo1000
        let textOffset = CGPoint(x: 8, y: 0)
        self.buttonUpgrade = Button(textureName: "buttonGray82x23", text: GameMath.spaceshipUpgradeCost(level: self.spaceship.level, type: self.spaceship.type).description, fontSize: 13, x: 100, y: 337, fontColor: fontColor, fontShadowColor: fontShadowColor, fontShadowOffset: fontShadowOffset, fontName: fontName, textOffset: textOffset)
        self.addChild(self.buttonUpgrade)
        
        self.buttonUpgrade.addChild(Control(textureName: "fragIconForButton", x: 6, y: 5))
        
    }

}
