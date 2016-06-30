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
    
    private func load(type:Int, level:Int) {
        
        self.type = Weapon.types[type]
        
        self.level = level
        
        self.damage = GameMath.weaponDamage(level: self.level, type: self.type)
        self.range = self.type.range
        self.fireInterval = self.type.fireRate
        
        self.rangeInPoints = CGFloat(self.type.range)
        
        if let imageName = self.type.shotSkins.first {
            self.weaponShotTexture = SKTexture(imageNamed: imageName)
        } else {
            #if DEBUG
               fatalError("Não conseguiu carregar weaponShotTexture")
            #endif
        }
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
                            let shot = Shot(damage: self.damage, range: self.rangeInPoints + bonusRange, fireRate: self.fireInterval , texture: self.weaponShotTexture, position: parentSpaceship.position, zRotation: parentSpaceship.zRotation, shooterPhysicsBody: parentSpaceshipPhysicsBody)
                            parentSpaceshipParent.addChild(shot)
                        }
                    }
                }
            }
            
            self.lastFire = GameScene.currentTime
        }
        
    }
}


class WeaponType {
    
    var shotSkins = [String]()
    
    var maxLevel:Int
    
    var damage:Int
    var range:Int
    var fireRate:Double
    var name:String!
    var weaponDescription:String!

    

    
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
            let weaponType = WeaponType(maxLevel: 1,
                damage: 2, range: 200, fireRate: 0.25)
            weaponType.shotSkins = [
                "weaponAAShot"
            ]
            weaponType.name = "Mata pombo"
            weaponType.weaponDescription = "Atira de longe, mas eh fraca"
            return weaponType
        }(),
    
        {
            let weaponType = WeaponType(maxLevel: 1,
                damage: 10, range: 100, fireRate: 1)
            weaponType.shotSkins = [
                "weaponBAShot"
            ]
            return weaponType
        }(),
        
        {
            let weaponType = WeaponType(maxLevel: 1,
                damage: 50, range: 50, fireRate: 2)
            weaponType.shotSkins = [
                "weaponCAShot"
            ]
            return weaponType
        }(),
        
        {
            let weaponType = WeaponType(maxLevel: 1,
                damage: 8, range: 400, fireRate: 4)
            weaponType.shotSkins = [
                "weaponCAShot"
            ]
            return weaponType
        }()
    ]
}
