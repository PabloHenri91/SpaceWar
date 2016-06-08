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
    
    var demage:Int!
    var range:Int!
    var reloadTime:Double!
    var fireInterval:Double!
    var lastFire:Double = 0
    var magazineSize:Int!
    
    var weaponData:WeaponData?
    
    override var description: String {
        return "\nWeapon\n" +
            "level: " + level.description + "\n" +
            "demage: " + demage.description  + "\n" +
            "fireInterval: " + fireInterval.description  + "\n" +
            "range: " + range.description  + "\n" +
            "reloadTime: " + reloadTime.description  + "\n" +
            "magazineSize: " + magazineSize.description  + "\n"
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
        
        self.demage = GameMath.weaponDemage(level: self.level, type: self.type)
        self.range = GameMath.weaponRange(level: self.level, type: self.type)
        self.fireInterval = GameMath.weaponFireInterval(level: self.level, type: self.type)
        self.reloadTime = GameMath.weaponReloadTime(level: self.level, type: self.type)
        self.magazineSize = GameMath.weaponMagazineSize(level: self.level, type: self.type)
        
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
    
    func fire() {
        
        if GameScene.currentTime - self.lastFire > self.fireInterval {
            
            if let parentSpaceship = self.parent {
                if let parentSpaceshipPhysicsBody = parentSpaceship.physicsBody {
                    if parentSpaceshipPhysicsBody.dynamic {
                        if let parentSpaceshipParent = parentSpaceship.parent {
                            let shot = Shot(texture: self.weaponShotTexture, position: parentSpaceship.position, zRotation: parentSpaceship.zRotation, shooterPhysicsBody: parentSpaceshipPhysicsBody)
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
    
    var demage:Int
    var range:Int
    var fireRate:Int
    var reloadTime:Double
    var magazineSize:Int
    
    var demagePerLevel:Int
    var rangePerLevel:Int
    var fireRatePerLevel:Int
    var reloadTimePerLevel:Double
    var magazineSizePerLevel:Int
    
    init(maxLevel:Int,
         demage:Int, range:Int, fireRate:Int, reloadTime:Double, magazineSize:Int,
         demagePerLevel:Int, fireRatePerLevel:Int, rangePerLevel:Int, reloadTimePerLevel:Double, magazineSizePerLevel:Int) {
        
        self.maxLevel = maxLevel
        
        self.demage = demage
        self.range = range
        self.fireRate = fireRate
        self.reloadTime = reloadTime
        self.magazineSize = magazineSize
        
        self.demagePerLevel = demagePerLevel
        self.fireRatePerLevel = fireRatePerLevel
        self.rangePerLevel = rangePerLevel
        self.reloadTimePerLevel = reloadTimePerLevel
        self.magazineSizePerLevel = magazineSizePerLevel
    }
}

extension Weapon {
    
    static var types:[WeaponType] = [
        {
            let weaponType = WeaponType(maxLevel: 1,
                demage: 1, range: 1, fireRate: 1, reloadTime: 1, magazineSize: 1,
                demagePerLevel: 1, fireRatePerLevel:1, rangePerLevel: 1, reloadTimePerLevel: 1, magazineSizePerLevel: 1)
            weaponType.shotSkins = [
                "weaponAAShot"
            ]
            return weaponType
        }(),
    
        {
            let weaponType = WeaponType(maxLevel: 1,
                demage: 1, range: 1, fireRate: 1, reloadTime: 1, magazineSize: 1,
                demagePerLevel: 1, fireRatePerLevel:1, rangePerLevel: 1, reloadTimePerLevel: 1, magazineSizePerLevel: 1)
            weaponType.shotSkins = [
                "weaponBAShot"
            ]
            return weaponType
        }(),
        
        {
            let weaponType = WeaponType(maxLevel: 1,
                demage: 1, range: 1, fireRate: 1, reloadTime: 1, magazineSize: 1,
                demagePerLevel: 1, fireRatePerLevel:1, rangePerLevel: 1, reloadTimePerLevel: 1, magazineSizePerLevel: 1)
            weaponType.shotSkins = [
                "weaponCAShot"
            ]
            return weaponType
        }()
    ]
}
