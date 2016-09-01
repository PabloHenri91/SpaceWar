//
//  Weapon.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Weapon: Control {
    
    var type:WeaponType!
    var weaponShotTexture:SKTexture!
    var level:Int!
    
    var damage:Int!
    var range:Int!
    var fireInterval:Double!
    var lastFire:Double = 0
    var rangeInPoints:CGFloat!
    
    var weaponData:WeaponData?
    
    var initShotSoundEffect:SoundEffect!
    
    override var description: String {
        return "\nWeapon\n" +
            "level: " + level.description + "\n" +
            "demage: " + damage.description  + "\n" +
            "fireInterval: " + fireInterval.description  + "\n" +
            "range: " + range.description  + "\n"
    }
    
    init(type:Int, level:Int) {
        super.init()
        self.load(type, level: level)
    }
    
    init(weaponData:WeaponData) {
        super.init()
        self.weaponData = weaponData
        self.load(weaponData.type.integerValue, level: weaponData.level.integerValue)
    }
    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    func loadSoundEffects() {
        self.initShotSoundEffect = SoundEffect(soundFile: self.type.initSoundFileName, node: self)
    }
    
    private func load(type:Int, level:Int) {
        
        self.type = Weapon.types[type]
        
        self.level = level
        
        self.damage = GameMath.weaponDamage(level: self.level, type: self.type)
        self.range = self.type.range
        self.fireInterval = self.type.fireRate
        
        self.rangeInPoints = CGFloat(self.type.range)
        
        let imageName = self.type.shotSkin
        self.weaponShotTexture = SKTexture(imageNamed: imageName)
        
        self.loadSoundEffects()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(bonusRange:CGFloat) {
        
        if GameScene.currentTime - self.lastFire > self.fireInterval {
            
            if let parentSpaceship = self.parent {
                if let parentSpaceshipPhysicsBody = parentSpaceship.physicsBody {
                    if parentSpaceshipPhysicsBody.dynamic {
                        if let parentSpaceshipParent = parentSpaceship.parent {
                            
                            let shot = Shot(shooter: parentSpaceship, damage: self.damage, range: self.rangeInPoints + bonusRange, fireRate: self.fireInterval , texture: self.weaponShotTexture, position: parentSpaceship.position, zRotation: parentSpaceship.zRotation, shooterPhysicsBody: parentSpaceshipPhysicsBody)
                            parentSpaceshipParent.addChild(shot)
                            shot.spriteNode.color = self.type.color
                            shot.spriteNode.colorBlendFactor = 1
                            self.initShotSoundEffect.play()
                        }
                    }
                }
            }
            
            self.lastFire = GameScene.currentTime
        }
        
    }
}


class WeaponType {
    
    var color = SKColor.whiteColor()
    var shotSkin = ""
    
    var maxLevel:Int
    
    var damage:Int
    var range:Int
    var fireRate:Double
    var name:String!
    var weaponDescription:String!

    var index:Int!
    
    var initSoundFileName = ""
    
    init(maxLevel:Int,
         damage:Int, range:Int, fireRate:Double) {
        
        self.maxLevel = maxLevel
        
        self.damage = damage
        self.range = range
        self.fireRate = fireRate

    }
}

extension Weapon {
    
    static var types:[WeaponType] = [
        
        {
            let weaponType = WeaponType(maxLevel: 2,
                damage: 10, range: 100, fireRate: 1)
            weaponType.color = SKColor(red: 100/255, green: 210/255, blue: 63/255, alpha: 1)
            weaponType.shotSkin = "shotBA"
            
            weaponType.name = "Blaster"
            weaponType.initSoundFileName = "laser5.mp3"
            weaponType.weaponDescription = "A normal weapon."
            weaponType.index = 0
            return weaponType
        }(),
        
        {
            let weaponType = WeaponType(maxLevel: 2,
                damage: 2, range: 150, fireRate: 0.25)
            weaponType.color = SKColor(red: 0/255, green: 226/255, blue: 240/255, alpha: 1)
            weaponType.shotSkin = "shotCA"
            
            weaponType.name = "Striker"
            weaponType.initSoundFileName = "laser3.mp3"
            weaponType.weaponDescription = "A thousand shots."
            weaponType.index = 1
            return weaponType
        }(),
        
        {
            let weaponType = WeaponType(maxLevel: 2,
                damage: 40, range: 50, fireRate: 2)
            weaponType.color = SKColor(red: 105/255, green: 85/255, blue: 172/255, alpha: 1)
            weaponType.shotSkin = "shotAA"
            
            weaponType.name = "Destroyer"
            weaponType.initSoundFileName = "laser1.mp3"
            weaponType.weaponDescription = "Close death."
            weaponType.index = 2
            return weaponType
        }(),
        
        {
            let weaponType = WeaponType(maxLevel: 2,
                damage: 15, range: 300, fireRate: 4)
            weaponType.color = SKColor(red: 232/255, green: 161/255, blue: 0/255, alpha: 1)
            weaponType.shotSkin = "shotDA"
            
            weaponType.name = "Sniper"
            weaponType.initSoundFileName = "laser9.mp3"
            weaponType.weaponDescription = "Kill enemies from other side of the universe."
            weaponType.index = 3
            return weaponType
        }()
    ]
}
