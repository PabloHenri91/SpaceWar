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
    
    var spaceships = [Spaceship]()
    
    var spriteNode:SKSpriteNode!
    
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
        
        for item in mothershipData.spaceships {
            if let spaceshipData  = item as? SpaceshipData {
                self.spaceships.append(Spaceship(spaceshipData: spaceshipData))
            }
        }
    }
    
    private func load(level level:Int) {
        self.level = level
        
        self.health = GameMath.mothershipMaxHealth(level: self.level)
        self.maxHealth = health
        
        //Gráfico
        self.spriteNode = SKSpriteNode(imageNamed: "mothership")
        self.spriteNode.texture?.filteringMode = .Nearest
        self.addChild(self.spriteNode)
        
        self.loadPhysics(rectangleOfSize: self.spriteNode.size)
    }
    
    func loadPhysics(rectangleOfSize size:CGSize) {
        self.physicsBody = SKPhysicsBody(rectangleOfSize: size)
        self.physicsBody?.dynamic = false
        
        self.physicsBody?.categoryBitMask = GameWorld.categoryBitMask.mothership.rawValue
        self.physicsBody?.collisionBitMask = GameWorld.collisionBitMask.mothership
        self.physicsBody?.contactTestBitMask = GameWorld.contactTestBitMask.mothership
    }
    
    func loadSpaceships(gameWorld:GameWorld) {
        
        var i = 0
        for spaceship in self.spaceships {
            
            gameWorld.addChild(spaceship)
            
            switch i {
            case 0:
                spaceship.position = self.convertPoint(CGPoint(x: -103, y: 78), toNode: gameWorld)
                break
            case 1:
                spaceship.position = self.convertPoint(CGPoint(x: -34, y: 78), toNode: gameWorld)
                break
            case 2:
                spaceship.position = self.convertPoint(CGPoint(x: 34, y: 78), toNode: gameWorld)
                break
            case 3:
                spaceship.position = self.convertPoint(CGPoint(x: 103, y: 78), toNode: gameWorld)
                break
            default:
                break
            }
            spaceship.startingPosition = spaceship.position
            i += 1
        }
    }
    
    func update(enemySpaceships enemySpaceships:[Spaceship]) {
        for spaceship in self.spaceships {
            spaceship.update(enemySpaceships: enemySpaceships)
        }
    }
}
