//
//  Weapon.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/20/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Weapon: Control {
    
    var type: WeaponType!
    var weaponShotTexture:SKTexture!
    var level:Int!
    
    var damage:Int!
    var range:Int!
    var fireInterval:Double!
    var lastFire:Double = 0
    var rangeInPoints:CGFloat!
    
    var initShotSoundEffect:SoundEffect!
    
    override var description: String {
        return "\nWeapon\n" +
            "level: " + level.description + "\n" +
            "demage: " + damage.description  + "\n" +
            "fireInterval: " + fireInterval.description  + "\n" +
            "range: " + range.description  + "\n"
    }
    
    init(weaponType: WeaponType, level:Int, loadSoundEffects: Bool) {
        super.init()
        self.load(weaponType, level: level, loadSoundEffects: loadSoundEffects)
    }
    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    func loadSoundEffects() {
        self.initShotSoundEffect = SoundEffect(soundFile: self.type.initSoundFileName, node: self)
    }
    
    private func load(weaponType: WeaponType, level: Int, loadSoundEffects: Bool) {
        
        self.type = weaponType
        
        self.level = level
        
        self.damage = GameMath.weaponDamage(level: self.level, type: self.type)
        self.range = self.type.range
        self.fireInterval = self.type.fireRate
        
        self.rangeInPoints = CGFloat(self.type.range)
        
        let imageName = self.type.shotSkin
        self.weaponShotTexture = SKTexture(imageNamed: imageName)
        
        if loadSoundEffects {
            self.loadSoundEffects()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func fire(bonusRange:CGFloat) {
        
        if GameScene.currentTime - self.lastFire >= self.fireInterval {
            
            if let parentSpaceship = self.parent {
                if let parentSpaceshipPhysicsBody = parentSpaceship.physicsBody {
                    if parentSpaceshipPhysicsBody.dynamic {
                        if let parentSpaceshipParent = parentSpaceship.parent {
                            
                            let shot = Shot(shooter: parentSpaceship, damage: self.damage, range: self.rangeInPoints + bonusRange, fireRate: self.fireInterval , texture: self.weaponShotTexture, position: parentSpaceship.position, zRotation: parentSpaceship.zRotation, shooterPhysicsBody: parentSpaceshipPhysicsBody, color: self.type.color)
                            parentSpaceshipParent.addChild(shot)
                            self.initShotSoundEffect.play()
                        }
                    }
                }
            }
            
            self.lastFire = GameScene.currentTime
        }
        
    }
}
