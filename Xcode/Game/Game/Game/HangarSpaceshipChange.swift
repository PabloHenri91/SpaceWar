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
    var buttonChoose: Button?
    var buttonFactory: Button?
    
    var labelLifeValue:Label!
    var labelDamageValue:Label!
    var labelRangeValue:Label!
    var labelFirerateValue:Label!
    var labelSpeedValue:Label!
    var labelRespawnValue:Label!
    
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
    
    var selectedCell:HangarSpaceshipSubCell?
    
    let selectedSpaceships = MemoryCard.sharedInstance.playerData.motherShip.spaceships
    let playerData = MemoryCard.sharedInstance.playerData
    
    init(spaceship:Spaceship) {
        
        
        self.spaceship = spaceship
        
        var imageName = ""
        var rarityColor:SKColor
        
        switch self.spaceship.type.rarity {
        case .common:
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
        self.addChild(spaceshipImage)
        spaceshipImage.screenPosition = CGPoint(x: 46, y: 78)
        spaceshipImage.resetPosition()
        
        let labelLevel = Label(color:SKColor.whiteColor() ,text: "Level ".translation() + self.spaceship.level.description , fontSize: 13, x: 46, y: 113, shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
        self.addChild(labelLevel)
        
        
        let lifeIcon = Control(textureName: "lifeIcon", x: 96, y: 59)
        lifeIcon.zPosition = 10000
        self.addChild(lifeIcon)
        
        let damageIcon = Control(textureName: "damageIcon", x: 190, y: 57)
        damageIcon.zPosition = 10000
        self.addChild(damageIcon)
        
        let respawnIcon = Control(textureName: "respawnIcon", x: 96, y: 83)
        respawnIcon.zPosition = 10000
        self.addChild(respawnIcon)
        
        let fireRateIcon = Control(textureName: "fireRateIcon", x: 190, y: 83)
        fireRateIcon.zPosition = 10000
        self.addChild(fireRateIcon)
        
        let speedIcon = Control(textureName: "speedIcon", x: 95, y: 108)
        speedIcon.zPosition = 10000
        self.addChild(speedIcon)
        
        let rangeIcon = Control(textureName: "rangeIcon", x: 190, y: 108)
        rangeIcon.zPosition = 10000
        self.addChild(rangeIcon)
        
        
        let life = GameMath.spaceshipMaxHealth(level: self.spaceship.level, type: self.spaceship.type)
        self.labelLifeValue = Label(text: life.description , fontSize: 11, x: 116, y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelLifeValue)
        
        self.labelDamageValue = Label(text: self.spaceship.weapon!.damage.description , fontSize: 11, x: 210, y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelDamageValue)
        
        self.labelRespawnValue = Label(text: "5s" , fontSize: 11, x: 116, y: 93, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelRespawnValue)
        
        let fireRate = 1 / self.spaceship.weapon!.fireInterval
        self.labelFirerateValue = Label(text: fireRate.description + "/s" , fontSize: 11, x: 210, y: 93, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelFirerateValue)
        
        self.labelSpeedValue = Label(text: GameMath.spaceshipSpeedAtribute(level: self.spaceship.level, type: self.spaceship.type).description, fontSize: 11, x: 116, y: 119, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelSpeedValue)
        
        self.labelRangeValue = Label(text: self.spaceship.weapon!.type.range.description , fontSize: 11, x: 210, y: 120, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo500)
        self.addChild(self.labelRangeValue)
        
        let x = self.position.x - (self.size.width/2) * 0.1
        let y = self.position.y + (self.size.height/2) * 0.1
        
        self.setScale(0)
        self.position = CGPoint(x: Display.currentSceneSize.width/2, y: -Display.currentSceneSize.height/2)
        
        let duration:Double = 0.10
        
        let action1 = SKAction.group([
            SKAction.scaleTo(1.1, duration: duration),
            SKAction.moveTo(CGPoint(x: x, y: y), duration: duration)
            ])
        
        let action2 = SKAction.group([
            SKAction.scaleTo(1, duration: duration),
            SKAction.moveTo(self.getPositionWithScreenPosition(self.screenPosition), duration: duration)
            ])
        
        self.runAction(SKAction.sequence([action1, action2])) {
            
            let spaceships = self.playerData.spaceships.sort({ (item0, item1) -> Bool in
                if let spaceshipData0 = item0 as? SpaceshipData {
                    if let spaceshipData1 = item1 as? SpaceshipData {
                        return spaceshipData0.level.integerValue > spaceshipData1.level.integerValue
                    }
                }
                return false
            })

            
            if spaceships.count > 4 {
                
                self.cropBox = CropBox(textureName: "hangarChangeSpaceshipCropbox", x: 1, y: 146, xAlign: .left, yAlign: .up)
                self.addChild(self.cropBox.cropNode)
                
                
                var spaceshipList = Array<Spaceship>()
                var controlArray = Array<Control>()
                
                for spaceshipData in spaceships {
                    
                    var canSelect = true
                    
                    for selectedSpaceship in self.selectedSpaceships {
                        if selectedSpaceship as! SpaceshipData == spaceshipData as! SpaceshipData {
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
                
            } else {
                
                let empityLabel = MultiLineLabel(text: "SPACESHIP LIST IS EMPTY, BUY NEW SPACESHIPS AT THE FACTORY", maxWidth: 216, x: 141, y: 251, color: SKColor(red: 47/255, green: 60/255, blue: 73/255, alpha: 1), fontName: GameFonts.fontName.museo1000, fontSize: 12)
                
                self.addChild(empityLabel)
                
                self.buttonFactory = Button(textureName: "buttonGray131x30", text: "FACTORY", fontSize: 13 ,  x: 76, y: 424, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
                self.addChild(self.buttonFactory!)
                
            }
        }
       
        
        
        
        
        


    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func selectSpaceship(cell:HangarSpaceshipSubCell){
        
        
        
        if let oldCell = self.selectedCell {
            oldCell.setScale(1.0)
        }
        
        self.selectedCell = cell
        cell.setScale(1.3)
        
        self.labelLifeDif?.removeFromParent()
        self.labelDamageDif?.removeFromParent()
        self.labelRangeDif?.removeFromParent()
        self.labelFirerateDif?.removeFromParent()
        self.labelSpeedDif?.removeFromParent()
        self.labelRespawnDif?.removeFromParent()
        
        self.backgroundLifeDif?.removeFromParent()
        self.backgroundDamageDif?.removeFromParent()
        self.backgroundRangeDif?.removeFromParent()
        self.backgroundFirerateDif?.removeFromParent()
        self.backgroundSpeedDif?.removeFromParent()
        self.backgroundRespawnDif?.removeFromParent()
        
        let life = GameMath.spaceshipMaxHealth(level: self.spaceship.level, type: self.spaceship.type)
        let newLife = GameMath.spaceshipMaxHealth(level: cell.spaceship.level, type: cell.spaceship.type)
        let lifeDif = newLife - life
        if lifeDif > 0 {
            
            self.labelLifeDif = Label(color: SKColor(red: 104/255, green: 181/255, blue: 59/255, alpha: 100/100), text: "+ " + lifeDif.description , fontSize: 11, x: Int(self.labelLifeValue.position.x + self.labelLifeValue.calculateAccumulatedFrame().width) , y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelLifeDif!)
            
            self.backgroundLifeDif = Control(textureName: "betterAtributeSmall", x: 91, y: 56)
            self.addChild(self.backgroundLifeDif!)
            
            self.labelLifeValue.zPosition = self.backgroundLifeDif!.zPosition + 1
            self.labelLifeDif!.zPosition = self.backgroundLifeDif!.zPosition + 1
            
        } else if lifeDif < 0 {
            
            self.labelLifeDif = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 100/100), text: "- " + abs(lifeDif).description , fontSize: 11, x: Int(self.labelLifeValue.position.x + self.labelLifeValue.calculateAccumulatedFrame().width) , y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelLifeDif!)
            
            self.backgroundLifeDif = Control(textureName: "worseAtributte", x: 91, y: 56)
            self.addChild(self.backgroundLifeDif!)
            
            self.labelLifeValue.zPosition = self.backgroundLifeDif!.zPosition + 1
            self.labelLifeDif!.zPosition = self.backgroundLifeDif!.zPosition + 1
            
        }
        
        
        //Damage
        
        let damage = self.spaceship.weapon!.damage
        let newDamage = cell.spaceship.weapon!.damage
        let damageDif = newDamage - damage
        if damageDif > 0 {
            
            self.labelDamageDif = Label(color: SKColor(red: 104/255, green: 181/255, blue: 59/255, alpha: 100/100), text: "+ " + damageDif.description , fontSize: 11, x: Int(self.labelDamageValue.position.x + self.labelDamageValue.calculateAccumulatedFrame().width) , y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDamageDif!)
            
            self.backgroundDamageDif = Control(textureName: "betterAtributeSmall", x: 190, y: 56)
            self.addChild(self.backgroundDamageDif!)
            
            self.labelDamageValue.zPosition = self.backgroundDamageDif!.zPosition + 1
            self.labelDamageDif!.zPosition = self.backgroundDamageDif!.zPosition + 1
            
        } else if damageDif < 0 {
            
            self.labelDamageDif = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 100/100), text: "- " + abs(damageDif).description , fontSize: 11, x: Int(self.labelDamageValue.position.x + self.labelDamageValue.calculateAccumulatedFrame().width) , y: 70, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelDamageDif!)
            
            self.backgroundDamageDif = Control(textureName: "worseAtributte", x: 190, y: 56)
            self.addChild(self.backgroundDamageDif!)
            
            self.labelDamageValue.zPosition = self.backgroundDamageDif!.zPosition + 1
            self.labelDamageDif!.zPosition = self.backgroundDamageDif!.zPosition + 1
            
        }
        
        
        //respawn nao implementado
        
        
        //firerate
        
        let firerate = 1 / self.spaceship.weapon!.fireInterval
        let newFirerate = 1 / cell.spaceship.weapon!.fireInterval
        let firerateDif = newFirerate - firerate
        if firerateDif < 0 {
            
            self.labelFirerateDif = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 100/100), text: "- " + abs(firerateDif).description , fontSize: 11, x: Int(self.labelFirerateValue.position.x + self.labelFirerateValue.calculateAccumulatedFrame().width) , y: 93, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelFirerateDif!)
            
            self.backgroundFirerateDif = Control(textureName: "worseAtributte", x: 190, y: 79)
            self.addChild(self.backgroundFirerateDif!)
            
            self.labelFirerateValue.zPosition = self.backgroundFirerateDif!.zPosition + 1
            self.labelFirerateDif!.zPosition = self.backgroundFirerateDif!.zPosition + 1
            
        } else if firerateDif > 0 {
            
            self.labelFirerateDif = Label(color: SKColor(red: 104/255, green: 181/255, blue: 59/255, alpha: 100/100), text: "+ " + firerateDif.description , fontSize: 11, x: Int(self.labelFirerateValue.position.x + self.labelFirerateValue.calculateAccumulatedFrame().width) , y: 93, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelFirerateDif!)
            
            self.backgroundFirerateDif = Control(textureName: "betterAtributeSmall", x: 190, y: 79)
            self.addChild(self.backgroundFirerateDif!)
            
            self.labelFirerateValue.zPosition = self.backgroundFirerateDif!.zPosition + 1
            self.labelFirerateDif!.zPosition = self.backgroundFirerateDif!.zPosition + 1
            
        }
        
        
        //speed
        
        let speed = GameMath.spaceshipSpeedAtribute(level: self.spaceship.level, type: self.spaceship.type)
        let newSpeed = GameMath.spaceshipSpeedAtribute(level: cell.spaceship.level, type: cell.spaceship.type)
        let speedDif = newSpeed - speed
        
        if speedDif > 0 {
            
            self.labelSpeedDif = Label(color: SKColor(red: 104/255, green: 181/255, blue: 59/255, alpha: 100/100), text: "+ " + speedDif.description , fontSize: 11, x: Int(self.labelSpeedValue.position.x + self.labelSpeedValue.calculateAccumulatedFrame().width) , y: 119, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelSpeedDif!)
            
            self.backgroundSpeedDif = Control(textureName: "betterAtributeSmall", x: 91, y: 105)
            self.addChild(self.backgroundSpeedDif!)
            
            self.labelSpeedValue.zPosition = self.backgroundSpeedDif!.zPosition + 1
            self.labelSpeedDif!.zPosition = self.backgroundSpeedDif!.zPosition + 1
            
        } else if speedDif < 0 {
            
            self.labelSpeedDif = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 100/100), text: "- " + abs(speedDif).description , fontSize: 11, x: Int(self.labelSpeedValue.position.x + self.labelSpeedValue.calculateAccumulatedFrame().width) , y: 119, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelSpeedDif!)
            
            self.backgroundSpeedDif = Control(textureName: "worseAtributte", x: 91, y: 105)
            self.addChild(self.backgroundSpeedDif!)
            
            self.labelSpeedValue.zPosition = self.backgroundSpeedDif!.zPosition + 1
            self.labelSpeedDif!.zPosition = self.backgroundSpeedDif!.zPosition + 1
        }
        
        
        
        //range
        
        let range = self.spaceship.weapon!.type.range
        let newRange = cell.spaceship.weapon!.type.range
        let rangeDif = newRange - range
        
        if rangeDif > 0 {
            
            self.labelRangeDif = Label(color: SKColor(red: 104/255, green: 181/255, blue: 59/255, alpha: 100/100), text: "+ " + rangeDif.description , fontSize: 11, x: Int(self.labelRangeValue.position.x + self.labelRangeValue.calculateAccumulatedFrame().width) , y: 119, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelRangeDif!)
            
            self.backgroundRangeDif = Control(textureName: "betterAtributeSmall", x: 185, y: 105)
            self.addChild(self.backgroundRangeDif!)
            
            self.labelRangeValue.zPosition = self.backgroundRangeDif!.zPosition + 1
            self.labelRangeDif!.zPosition = self.backgroundRangeDif!.zPosition + 1
            
        } else if rangeDif < 0 {
            
            self.labelRangeDif = Label(color: SKColor(red: 231/255, green: 48/255, blue: 60/255, alpha: 100/100), text: "- " + abs(rangeDif).description , fontSize: 11, x: Int(self.labelRangeValue.position.x + self.labelRangeValue.calculateAccumulatedFrame().width) , y: 119, horizontalAlignmentMode: .Left, verticalAlignmentMode: .Baseline, shadowColor: SKColor(red: 213/255, green: 218/255, blue: 221/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.labelRangeDif!)
            
            self.backgroundRangeDif = Control(textureName: "worseAtributte", x: 185, y: 105)
            self.addChild(self.backgroundRangeDif!)
            
            self.labelRangeValue.zPosition = self.backgroundRangeDif!.zPosition + 1
            self.labelRangeDif!.zPosition = self.backgroundRangeDif!.zPosition + 1
        }

        self.buttonFactory?.removeFromParent()
        
        if self.buttonChoose == nil {

            self.buttonChoose = Button(textureName: "buttonGray131x30", text: "CHOOSE", fontSize: 13 ,  x: 76, y: 424, fontColor: SKColor.whiteColor(), fontShadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 40/100), fontShadowOffset:CGPoint(x: 0, y: -1), fontName: GameFonts.fontName.museo1000)
            self.addChild(self.buttonChoose!)
        }
        
        
    }
    
    func choose() {
        
        var index = 0
        for selectedSpaceship in self.selectedSpaceships {
            if selectedSpaceship as! SpaceshipData == self.spaceship.spaceshipData {
                
                print(selectedSpaceship)
                self.playerData.motherShip.removeSpaceshipData(selectedSpaceship as! SpaceshipData)
                
                self.playerData.motherShip.addSpaceshipData(self.selectedCell!.spaceship.spaceshipData!, index: index)
                return
            }
            index += 1
        }
    }
    
}
