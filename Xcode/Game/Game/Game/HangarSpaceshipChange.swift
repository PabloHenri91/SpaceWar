//
//  HangarSpaceshipChange.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 22/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class HangarSpaceshipChange:Box {
    
    var spaceship:Spaceship
    var cropBox:CropBox!
    
    var buttonCancel: Button!
    var buttonChoose: Button!
    
    var labelLifeDif:Label?
    var labelDamageDif:Label?
    var labelRangeDif:Label?
    var labelFirerateDif:Label?
    var labelSpeedDif:Label?
    var labelRespawnDif:Label?
    
    var backgroundLifeDif:Control?
    var backgroundDamageDif:Control?
    var backgroundRangeDif:Control?
    var backgroundFirerateDif:Control?
    var backgroundSpeedDif:Control?
    var backgroundRespawnDif:Control?
    
    var scrollNode: ScrollNode?
    
    
    init(spaceship:Spaceship) {
        
        
        self.spaceship = spaceship
        
        var imageName = ""
        var rarityColor:SKColor
        
        switch self.spaceship.type.rarity {
        case .commom:
            imageName = "hangarCommomSpaceshipCardChange"
            rarityColor = SKColor(red: 63/255, green: 119/255, blue: 73/255, alpha: 1)
            break
        case .rare:
            imageName = "hangarRareSpaceshipCardChange"
            rarityColor = SKColor(red: 164/255, green: 69/255, blue: 48/255, alpha: 1)
            break
        case .epic:
            imageName = "hangarEpicSpaceshipCardChange"
            rarityColor = SKColor(red: 65/255, green: 70/255, blue: 123/255, alpha: 1)
            break
        case .legendary:
            imageName = "hangarLegendarySpaceshipCardChange"
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
        
        
        let labelRarity = Label(color:rarityColor ,text: self.spaceship.type.rarity.rawValue.uppercaseString , fontSize: 11, x: 47, y: 22, horizontalAlignmentMode: .Center, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 20/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelRarity)
        
        let spaceshipImage = Spaceship(spaceshipData: spaceship.spaceshipData!)
        spaceshipImage.loadAllyDetails()
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 46, y: 78)
        spaceshipImage.resetPosition()
        
        let labelLevel = Label(color:SKColor.whiteColor() ,text: "Level " + self.spaceship.level.description , fontSize: 13, x: 46, y: 113, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelLevel)
        
        
        let lifeIcon = Control(textureName: "lifeIcon", x: 96, y: 59)
        self.addChild(lifeIcon)
        
        let damageIcon = Control(textureName: "damageIcon", x: 190, y: 57)
        self.addChild(damageIcon)
        
        let respawnIcon = Control(textureName: "respawnIcon", x: 96, y: 83)
        self.addChild(respawnIcon)
        
        let fireRateIcon = Control(textureName: "fireRateIcon", x: 190, y: 83)
        self.addChild(fireRateIcon)
        
        let speedIcon = Control(textureName: "speedIcon", x: 95, y: 108)
        self.addChild(speedIcon)
        
        let rangeIcon = Control(textureName: "rangeIcon", x: 190, y: 108)
        self.addChild(rangeIcon)
        
        
        let life = GameMath.spaceshipMaxHealth(level: self.spaceship.level, type: self.spaceship.type)
        let labelLifeValue = Label(text: life.description , fontSize: 11, x: 116, y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelLifeValue)
        
        let labelDamageValue = Label(text: self.spaceship.weapon!.damage.description , fontSize: 11, x: 210, y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelDamageValue)
        
        let labelRespawnValue = Label(text: "5s" , fontSize: 11, x: 116, y: 93, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelRespawnValue)
        
        let fireRate = 1 / self.spaceship.weapon!.fireInterval
        let labelFireRateValue = Label(text: fireRate.description + "/S" , fontSize: 11, x: 210, y: 93, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelFireRateValue)
        
        let labelSpeedValue = Label(text: GameMath.spaceshipSpeedAtribute(level: self.spaceship.level, type: self.spaceship.type).description, fontSize: 11, x: 116, y: 119, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelSpeedValue)
        
        let labelRangeValue = Label(text: self.spaceship.weaponRangeBonus.description , fontSize: 11, x: 210, y: 120, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(labelRangeValue)
        
        self.cropBox = CropBox(textureName: "hangarChangeSpaceshipCropbox", x: 1, y: 146, xAlign: .left, yAlign: .up)
        self.addChild(self.cropBox.cropNode)
        
        let spaceships = MemoryCard.sharedInstance.playerData.spaceships
        let selectedSpaceships = MemoryCard.sharedInstance.playerData.motherShip.spaceships
        var spaceshipList = Array<Spaceship>()
        var controlArray = Array<Control>()
        
        for spaceshipData in spaceships {
            
            var canSelect = true
            
            for selectedSpaceship in selectedSpaceships {
                if selectedSpaceship as! SpaceshipData == spaceshipData as! SpaceshipData {
                    print("selected")
                    canSelect = false
                }
            }
            
            if canSelect {
                spaceshipList.append(Spaceship(spaceshipData: spaceshipData as! SpaceshipData))
                if spaceshipList.count == 3 {
                    let cell = HangarSpaceshipsCell(spaceships: spaceshipList)
                    controlArray.append(cell)
                    spaceshipList.removeAll()
                }
            }
            
            
        }
        
        if spaceshipList.count > 0 {
            let cell = HangarSpaceshipsCell(spaceships: spaceshipList)
            controlArray.append(cell)
            spaceshipList.removeAll()
        }
        
        self.scrollNode = ScrollNode(cells: controlArray, x: 0, y: 50,  spacing: 13, scrollDirection: .vertical)
        self.cropBox.addChild(self.scrollNode!)
        


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
