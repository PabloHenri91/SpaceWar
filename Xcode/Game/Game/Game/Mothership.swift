//
//  Mothership.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/24/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Mothership: Control {

    var level:Int!
    
    //Vida
    var health:Int!
    var maxHealth:Int!
    
    var mothershipData:MothershipData?
    
    override var description: String {
        return "\nMothership\n" +
            "level: " + level.description + "\n" +
            "health: " + health.description  + "\n" +
            "maxHealth: " + maxHealth.description  + "\n"
    }
    
    override init() {
        fatalError("NÃO IMPLEMENTADO")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(level:Int) {
        super.init()
        self.load(level: level)
    }
    
    init(mothershipData:MothershipData) {
        super.init()
        self.mothershipData = mothershipData
        self.load(level: mothershipData.level.integerValue)
    }
    
    private func load(level level:Int) {
        self.level = level
        
        self.health = GameMath.mothershipMaxHealth(level: self.level)
        self.maxHealth = health
        
        //Gráfico
        let spriteNode = SKSpriteNode(imageNamed: "mothership")
        spriteNode.texture?.filteringMode = .Nearest
        self.addChild(spriteNode)
    }
}
