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
    var level:Int!
    
    var demage:Int!
    var range:Int!
    var reloadTime:Double!
    var ammoPerMag:Int!
    
    var weaponData:WeaponData?
    
    override var description: String {
        return "\nWeapon\n" +
            "level: " + level.description + "\n" +
            "demage: " + demage.description  + "\n" +
            "range: " + range.description  + "\n" +
            "reloadTime: " + reloadTime.description  + "\n" +
            "ammoPerMag: " + ammoPerMag.description  + "\n"
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
        self.reloadTime = GameMath.weaponReloadTime(level: self.level, type: self.type)
        self.ammoPerMag = GameMath.weaponAmmoPerMag(level: self.level, type: self.type)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class WeaponType {
    
    var maxLevel:Int
    
    var demage:Int
    var range:Int
    var reloadTime:Double
    var ammoPerMag:Int
    
    var demagePerLevel:Int
    var rangePerLevel:Int
    var reloadTimePerLevel:Double
    var ammoPerMagPerLevel:Int
    
    init(maxLevel:Int, demage:Int, range:Int, reloadTime:Double, ammoPerMag:Int, demagePerLevel:Int, rangePerLevel:Int, reloadTimePerLevel:Double, ammoPerMagPerLevel:Int) {
        
        self.maxLevel = maxLevel
        
        self.demage = demage
        self.range = range
        self.reloadTime = reloadTime
        self.ammoPerMag = ammoPerMag
        
        self.demagePerLevel = demagePerLevel
        self.rangePerLevel = rangePerLevel
        self.reloadTimePerLevel = reloadTimePerLevel
        self.ammoPerMagPerLevel = ammoPerMagPerLevel
    }
}

extension Weapon {
    
    static var types = [
        WeaponType(maxLevel: 1,
            demage: 1, range: 1, reloadTime: 1, ammoPerMag: 1,
            demagePerLevel: 1, rangePerLevel: 1, reloadTimePerLevel: 1, ammoPerMagPerLevel: 1),
        
        WeaponType(maxLevel: 1,
            demage: 1, range: 1, reloadTime: 1, ammoPerMag: 1,
            demagePerLevel: 1, rangePerLevel: 1, reloadTimePerLevel: 1, ammoPerMagPerLevel: 1),
        
        WeaponType(maxLevel: 1,
            demage: 1, range: 1, reloadTime: 1, ammoPerMag: 1,
            demagePerLevel: 1, rangePerLevel: 1, reloadTimePerLevel: 1, ammoPerMagPerLevel: 1)
        
    ]
}
