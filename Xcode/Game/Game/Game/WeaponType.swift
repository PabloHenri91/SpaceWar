//
//  WeaponType.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 10/21/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class WeaponType {
    
    var color = SKColor.whiteColor()
    var shotSkin = ""
    
    var damage: Int = 1
    var range: Int = 100
    var fireRate: Double = 1
    
    var initSoundFileName = "laser5.mp3"
    
    init(damage:Int, range:Int, fireRate:Double) {
        
        self.damage = damage
        self.range = range
        self.fireRate = fireRate
    }
}
