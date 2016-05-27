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
        
        var spaceships = [Spaceship]()
        for item in mothershipData.spaceships {
            if let spaceshipData  = item as? SpaceshipData {
                spaceships.append(Spaceship(spaceshipData: spaceshipData))
            }
        }
        self.loadSpaceships(spaceships)
    }
    
    private func load(level level:Int) {
        self.level = level
        
        self.health = GameMath.mothershipMaxHealth(level: self.level)
        self.maxHealth = health
        
        //Gráfico
        let spriteNode = SKSpriteNode(imageNamed: "mothership")
        spriteNode.texture?.filteringMode = .Nearest
        self.addChild(spriteNode)
        
        self.loadPhysics(rectangleOfSize: spriteNode.size)
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.mothership.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.mothership
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.mothership
    }
    
    func loadSpaceships(spaceships:[Spaceship]) {
        
        var i = 0
        for spaceship in spaceships {
            
            self.addChild(spaceship)
            
            switch i {
            case 0:
                spaceship.position = CGPoint(x: -103, y: 78)
                break
            case 1:
                spaceship.position = CGPoint(x: -34, y: 78)
                break
            case 2:
                spaceship.position = CGPoint(x: 34, y: 78)
                break
            case 3:
                spaceship.position = CGPoint(x: 103, y: 78)
                break
            default:
                break
            }
            i += 1
        }
    }
}
