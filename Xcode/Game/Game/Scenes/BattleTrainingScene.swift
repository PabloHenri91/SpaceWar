//
//  BattleTrainingScene.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/1/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BattleTrainingScene: GameScene {
    
    enum states : String {
        
        case loading
        
        //Estados de saida da scene
        case mothership
        
        case askToStart
        case askToSelect
        case askToMove
        case move
        case askToSelectOther
        case askWeaponRange
        case battleWithOneMeteor
        case endBattleWithOneMeteor
        case askNearestTarget
        case battleWithTwoMeteor
        case endBattleWithTwoMeteor
        case hotTip
        case askBattleWithFourSpaceships
        case battleWithFourSpaceships
        case endBattleWithFourSpaceships
        case askDestroyEnemyMothership
        case destroyEnemyMothership
        case endBattle
        case battleEndInterval
        case showBattleResult
    }
    
    //Estados iniciais
    var state = states.loading
    var nextState = states.loading
    
    var gameWorld:GameWorld!
    var gameCamera:GameCamera!
    var mothership:Mothership!
    var botMothership:Mothership?
    
    var battleEndTime: Double = 0
    
    var tutorialControl:Control?
    var touchImage:Control?
    var dangerAlert:TutorialDangerAlert?
    
    var enemySpaceships = [Spaceship]()
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        
        self.backgroundColor = SKColor(red: 50/255, green: 61/255, blue: 74/255, alpha: 1)
        
        Music.sharedInstance.playMusicWithType(Music.musicTypes.battle)
        
        // GameWorld
        self.gameWorld = GameWorld(physicsWorld: self.physicsWorld)
        self.gameWorld.zPosition = -1000
        self.gameWorld.setScreenBox(Display.defaultSceneSize)
        self.addChild(self.gameWorld)
        self.physicsWorld.contactDelegate = self.gameWorld
        
        // GameCamera
        self.gameCamera = GameCamera()
        self.gameWorld.addChild(self.gameCamera)
        self.gameWorld.addChild(self.gameCamera.node)
        self.gameCamera.node.position = CGPoint.zero
        self.gameCamera.update()
        
        // Mothership
        self.mothership = Mothership(level: 10, blueTeam: true)
        self.mothership.health = 500
        self.mothership.maxHealth = 500
        
        
        self.gameWorld.addChild(self.mothership)
        self.mothership.position = CGPoint(x: 0, y: -243)
        
        self.mothership.loadHealthBar()
        
        // Spaceships
        let spaceship = Spaceship(type: 0, level: 1, loadPhysics: true)
        self.mothership.spaceships.append(spaceship)
        spaceship.addWeapon(Weapon(type: 0, level: 1, loadSoundEffects: true))
        
        self.mothership.loadSpaceships(self.gameWorld)
        
        self.nextState = .askToStart
    }
    
    override func update(currentTime: NSTimeInterval) {
        super.update(currentTime)
        
        //Estado atual
        if(self.state == self.nextState) {
            switch (self.state) {
                
            case .askToStart:
                self.mothership.update()
                break
                
            case .askToSelect:
                self.mothership.update()
                break
                
            case .askToMove:
                self.mothership.update()
                break
                
            case .move:
                self.mothership.update()
                break
                
            case .askToSelectOther:
                self.mothership.update()
                break

                
            case .askWeaponRange:
                self.mothership.update()
                for spaceship in self.mothership.spaceships {
                    spaceship.showWeaponRangeSprite()
                }
                break
                

                
            case .battleWithOneMeteor:
                self.mothership.update(enemySpaceships: self.enemySpaceships)
                for spaceship in self.mothership.spaceships {
                    spaceship.showWeaponRangeSprite()
                }
                var meteorHealth = 0
                for meteor in self.enemySpaceships {
                    meteor.updateHealthBarPosition()
                    meteorHealth += meteor.health
                }
                if meteorHealth <= 0 {
                    self.nextState = .endBattleWithOneMeteor
                }
                break
                
            case .endBattleWithOneMeteor:
                self.mothership.update()
                if currentTime - self.battleEndTime > 1 {
                    self.nextState = .askNearestTarget
                }
                break
                
            case .askNearestTarget:
                self.mothership.update()
                break
                
            case .battleWithTwoMeteor:
                self.mothership.update(enemySpaceships: self.enemySpaceships)
                var meteorHealth = 0
                for meteor in self.enemySpaceships {
                    meteor.updateHealthBarPosition()
                    meteorHealth += meteor.health
                }
                if meteorHealth <= 0 {
                    self.nextState = .endBattleWithTwoMeteor
                }
                break
                
            case .endBattleWithTwoMeteor:
                self.mothership.update()
                if currentTime - self.battleEndTime > 1 {
                    self.nextState = .hotTip
                }
                break
                
            case .hotTip:
                self.mothership.update()
                break
                
                
            case .askBattleWithFourSpaceships:
                self.mothership.update()
                break
                
            case .battleWithFourSpaceships:
                self.mothership.update(enemySpaceships: (self.botMothership?.spaceships)!)
                self.botMothership?.update(enemySpaceships: self.mothership.spaceships)
                
                var enemyHealth = 0
                for enemy in (self.botMothership?.spaceships)! {
                    enemyHealth += enemy.health
                }
                if enemyHealth <= 0 {
                    self.nextState = .endBattleWithFourSpaceships
                }
                
                break
                
            case .endBattleWithFourSpaceships:
                self.mothership.update()
                if currentTime - self.battleEndTime > 1 {
                    self.nextState = .askDestroyEnemyMothership
                }
                break
                
            case .askDestroyEnemyMothership:
                self.mothership.update()
                break
                
            case .destroyEnemyMothership:
                self.mothership.update(enemyMothership: self.botMothership)
                
                var enemyHealth = 0
                enemyHealth = (self.botMothership?.health)!
                if enemyHealth <= 0 {
                    self.nextState = .endBattle
                }
                
                break
                
            case .endBattle:
                self.mothership.update()
                break
                
            case .battleEndInterval:
                self.mothership.update()
                if currentTime - battleEndTime > 2 {
                    self.nextState = states.showBattleResult
                }
                break
                
            case .showBattleResult:
                self.mothership.update()
                break
                
            default:
                #if DEBUG
                    //print(self.state)
                    fatalError()
                #endif
                break
            }
        } else {
            
            self.state = self.nextState
            //Próximo estado
            switch (self.nextState) {
                
            case .askToStart:
                let alert = TutorialAlertBox(text: "We will teach you how to play. Pay close attention! " , buttonText: "OK, LET'S GO")
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .askToSelect
                })

                
                break
                
            case .askToSelect:
                
                self.tutorialControl = Control(textureName: "darkBlueBox281x92", x:20, y:238, xAlign: .center, yAlign: .center)
                self.addChild(self.tutorialControl!)
                
                let labelTitle = Label(color:SKColor.whiteColor() ,text: "TUTORIAL" , fontSize: 14, x: 141, y: 26, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
                self.tutorialControl!.addChild(labelTitle)
                
                let labelDescription = Label(text: "Touch a ship to select it" , fontSize: 12, x: 141, y: 68 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
                self.tutorialControl!.addChild(labelDescription)
                
                self.touchImage = Control(textureName: "touchImage", x:18, y:442, xAlign: .center, yAlign: .center)
                self.addChild(self.touchImage!)
                
                
                
                
                break
                
            case .askToMove:
                
                let alert = TutorialAlertBox(text: "Touch any location on the screen and you ship will moves up to this place" , buttonText: "I GOT IT")
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .move
                })
                
                break
                
            case .move:
                self.tutorialControl = Control(textureName: "tutorialAim", x:110, y:228, xAlign: .center, yAlign: .center)
                
                if let tutorialControl = self.tutorialControl {
                    
                    let finalPosition = tutorialControl.position
                    let startScreenPosition = CGPoint(x: 7, y: 479)
                    
                    tutorialControl.screenPosition = startScreenPosition
                    tutorialControl.resetPosition()
                    let startPosition = tutorialControl.position
                    
                    let action = SKAction.sequence([
                        SKAction.moveTo(finalPosition, duration: 1),
                        {let a = SKAction(); a.duration = 1; return a}(),
                        SKAction.moveTo(startPosition, duration: 0),
                        {let a = SKAction(); a.duration = 1; return a}()
                        ])
                    
                    tutorialControl.runAction(SKAction.repeatActionForever(action))
                    
                    self.addChild(tutorialControl)
                }
                break
                
            case .askToSelectOther:
                
                //TODO: definir tempo. duration = ?
                self.runAction({let a = SKAction(); a.duration = 1; return a}(), completion: { [weak self] in
                    
                    guard let scene = self else { return }
                    
                    let spaceship = Spaceship(type: 0, level: 1, loadPhysics: true)
                    spaceship.addWeapon(Weapon(type: 0, level: 1, loadSoundEffects: true))
                    scene.mothership.spaceships.append(spaceship)
                    scene.mothership.loadSpaceship(spaceship, gameWorld: scene.gameWorld, i: 1)
                    
                    scene.tutorialControl = Control(textureName: "darkBlueBox281x92", x:20, y:238, xAlign: .center, yAlign: .center)
                    scene.addChild(scene.tutorialControl!)
                    
                    let labelTitle = Label(color:SKColor.whiteColor() ,text: "TUTORIAL" , fontSize: 14, x: 141, y: 26, shadowColor: SKColor(red: 33/255, green: 41/255, blue: 48/255, alpha: 100/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
                    scene.tutorialControl!.addChild(labelTitle)
                    
                    let labelDescription = Label(text: "Touch a battleship to select it" , fontSize: 12, x: 141, y: 68 , shadowColor: SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 11/100), shadowOffset:CGPoint(x: 0, y: -2), fontName: GameFonts.fontName.museo1000)
                    scene.tutorialControl!.addChild(labelDescription)
                    
                    scene.touchImage = Control(textureName: "touchImage", x:85, y:442, xAlign: .center, yAlign: .center)
                    scene.addChild(scene.touchImage!)
                })
                
                break
                
                
            case .askWeaponRange:
              
                
                let alert = TutorialBigAlertBox(text: "This white circle around your ship is the range of the shot. The ship only shot on enemys after stops moving.", buttonText: "LETS SHOOT!", imageName: "rangeImage")
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .battleWithOneMeteor
                })
            
                
                
                let meteor = Spaceship(extraType: 0, level: 1, loadPhysics: true)
                meteor.setBitMasksToSpaceship()
                meteor.loadHealthBar(self.gameWorld, blueTeam: false)
                meteor.position = CGPoint(x: 0, y: 200)
                meteor.updateHealthBarPosition()
                meteor.physicsBody?.dynamic = true
                meteor.isInsideAMothership = false
                
                self.gameWorld.addChild(meteor)
                self.enemySpaceships.append(meteor)
                break
              
                
            case .battleWithOneMeteor:
                self.tutorialControl = Control(textureName: "tutorialAim", x:110, y:106, xAlign: .center, yAlign: .center)
                
                if let tutorialControl = self.tutorialControl {
                    self.addChild(tutorialControl)
                }
                break
                
            case .endBattleWithOneMeteor:
                self.battleEndTime = currentTime
                break
                
            case .askNearestTarget:
                
                let alert = TutorialBigAlertBox(text: "Your spaceship will always shoot the nearest enemy. The ship only shot on enemys after stops moving.", buttonText: "EASY, LETS TRY!", imageName: "rangeImage2")
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .battleWithTwoMeteor
                })
                
                let meteor = Spaceship(extraType: 0, level: 1, loadPhysics: true)
                meteor.setBitMasksToSpaceship()
                meteor.loadHealthBar(self.gameWorld, blueTeam: false)
                meteor.position = CGPoint(x: -100, y: -116)
                meteor.updateHealthBarPosition()
                meteor.physicsBody?.dynamic = true
                meteor.isInsideAMothership = false
                self.gameWorld.addChild(meteor)
                self.enemySpaceships.append(meteor)
                
                let meteor2 = Spaceship(extraType: 1, level: 1, loadPhysics: true)
                meteor2.setBitMasksToSpaceship()
                meteor2.loadHealthBar(self.gameWorld, blueTeam: false)
                meteor2.position = CGPoint(x: 100, y: -116)
                meteor2.updateHealthBarPosition()
                meteor2.physicsBody?.dynamic = true
                meteor2.isInsideAMothership = false
                self.gameWorld.addChild(meteor2)
                self.enemySpaceships.append(meteor2)
            
                
                break
                
            case .battleWithTwoMeteor:
                self.tutorialControl = Control(textureName: "tutorialAim", x:110, y:286, xAlign: .center, yAlign: .center)
                
                if let tutorialControl = self.tutorialControl {
                    self.addChild(tutorialControl)
                }
                break
                
            case .endBattleWithTwoMeteor:
                self.battleEndTime = currentTime
                break
                
            case .hotTip:
                let alert = TutorialHotTip()
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .askBattleWithFourSpaceships
                })
                
            case .askBattleWithFourSpaceships:
                
                let alert = TutorialAlertBox(text: "Now that you already learned how to play, go to a real challenge. There is another mothership approaching yours." , buttonText: "BEAT IT!")
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .battleWithFourSpaceships
                })
    
                for enemySpaceship in self.enemySpaceships {
                    enemySpaceship.removeFromParent()
                }
                self.enemySpaceships = [Spaceship]()
                
                Spaceship.retreatSelectedSpaceship()
                for spaceship in self.mothership.spaceships {
                    spaceship.retreat()
                }
                
                var spaceship = Spaceship(type: Int.random(Spaceship.types.count), level: 1, loadPhysics: true)
                spaceship.addWeapon(Weapon(type: Int.random(Weapon.types.count), level: 1, loadSoundEffects: true))
                self.mothership.spaceships.append(spaceship)
                self.mothership.loadSpaceship(spaceship, gameWorld: self.gameWorld, i: 2)
                
                spaceship = Spaceship(type: Int.random(Spaceship.types.count), level: 1, loadPhysics: true)
                spaceship.addWeapon(Weapon(type: Int.random(Weapon.types.count), level: 1, loadSoundEffects: true))
                self.mothership.spaceships.append(spaceship)
                self.mothership.loadSpaceship(spaceship, gameWorld: self.gameWorld, i: 3)
                
                
                self.botMothership = Mothership(level: 1)
                self.botMothership!.health = 150
                self.botMothership!.maxHealth = 150
                if let botMothership = self.botMothership {
                    botMothership.zRotation = CGFloat(M_PI)
                    botMothership.position = CGPoint(x: 0, y: 243)
                    
                    botMothership.loadHealthBar(blueTeam: false)
                    
                    for _ in 0 ..< 4 {
                        botMothership.spaceships.append(Spaceship(type: Int.random(Spaceship.types.count), level: 1, loadPhysics: true))
                    }
                    
                    self.gameWorld.addChild(botMothership)
                    
                    var i = 1
                    for botSpaceship in botMothership.spaceships {
                        
                        botSpaceship.canRespawn = false
                        
                        let weaponTypeIndex = Int.random(Weapon.types.count)
                        botSpaceship.weapon = Weapon(type: weaponTypeIndex, level: 1, loadSoundEffects: true)
                        botSpaceship.weapon?.damage = 1
                        botSpaceship.addChild(botSpaceship.weapon!)
                        
                        botSpaceship.runAction( { let a = SKAction(); a.duration = Double(i*3); return a }(), completion:
                            { [weak botSpaceship] in
                                
                                guard let someBotSpaceship = botSpaceship else { return }
                                
                                someBotSpaceship.destination = CGPoint(x: someBotSpaceship.startingPosition.x,
                                    y: someBotSpaceship.startingPosition.y - 200)
                                someBotSpaceship.needToMove = true
                                someBotSpaceship.physicsBody?.dynamic = true
                            })
                        i += 1
                    }
                    
                    botMothership.loadSpaceships(self.gameWorld, isAlly: false)
                }
                
                
                
                break
                
            case .battleWithFourSpaceships:
                break
                
            case .endBattleWithFourSpaceships:
                self.battleEndTime = currentTime
                break
                
            case .askDestroyEnemyMothership:
                
                let alert = TutorialAlertBox(text: "You destroyed all enemy battleships! Atack the mothership to explode everything now!" , buttonText: "DEATH TIME!")
                self.addChild(alert)
                
                alert.buttonOk.addHandler({
                    self.nextState = .destroyEnemyMothership
                })
                
                
                break
                
            case .destroyEnemyMothership:
                self.tutorialControl = Control(textureName: "tutorialAim", x:110, y:106, xAlign: .center, yAlign: .center)
                
                if let tutorialControl = self.tutorialControl {
                    self.addChild(tutorialControl)
                }
                break
                
            case .mothership:
                MemoryCard.sharedInstance.playerData.needBattleTraining = NSNumber(bool: false)
                self.view?.presentScene(MothershipScene())
                break
                
            case .endBattle:
                self.battleEndTime = currentTime
                self.nextState = .battleEndInterval
                break
                
            case .battleEndInterval:
                break
                
            case .showBattleResult:
                let alertBox = AlertBox(title: "The Battle Ended", text: "You Win! ".translation() + String.winEmoji(), type: AlertBox.messageType.OK)
                alertBox.buttonOK.addHandler({
                    self.nextState = states.mothership
                })
                self.addChild(alertBox)
                
                break
                
            default:
                #if DEBUG
                    //print(self.state)
                    fatalError()
                #endif
                break
            }
        }
        
        Shot.update()
    }
    
    override func didFinishUpdate() {
        super.didFinishUpdate()
        
        self.gameCamera.update()
    }
    
    override func touchesBegan(touches: Set<UITouch>) {
        super.touchesBegan(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                    
                case .askToStart:
                    break
                    
                case .askToSelect:
                    
                    for spaceship in self.mothership.spaceships {
                        if let parent = spaceship.parent {
                            if spaceship.containsPoint(touch.locationInNode(parent)) {
                                spaceship.touchEnded()
                                self.tutorialControl?.removeFromParent()
                                self.touchImage?.removeFromParent()
                                self.nextState = .askToMove
                            }
                        }
                    }
                    
                    break
                    
                case .askToMove:
                    break
                    
                case .move:
                    self.tutorialControl?.removeFromParent()
                    self.tutorialControl = Control(textureName: "tutorialMoveDestination", x:110, y:234, xAlign: .center, yAlign: .center)
                    
                    if let tutorialControl = self.tutorialControl {
                        self.addChild(tutorialControl)
                    }
                    
                    Spaceship.touchEnded(touch)
                    break
                    
                case .askToSelectOther:
                    break
                    
                    
                case .askWeaponRange:
                    break
                    
                    
                case .battleWithOneMeteor:
                    self.tutorialControl?.removeFromParent()
                    self.battleTouchesBegan(touch)
                    break
                    
                case .endBattleWithOneMeteor:
                    break
                    
                case .askNearestTarget:
                    break
                    
                case .battleWithTwoMeteor:
                    self.tutorialControl?.removeFromParent()
                    self.battleTouchesBegan(touch)
                    break
                    
                case .endBattleWithTwoMeteor:
                    break
                    
                case .hotTip:
                    break
                    
                case .askBattleWithFourSpaceships:
                    break
                    
                case .battleWithFourSpaceships:
                    self.battleTouchesBegan(touch)
                    break
                    
                case .endBattleWithFourSpaceships:
                    break
                    
                case .askDestroyEnemyMothership:
                    break
                    
                case .destroyEnemyMothership:
                    self.tutorialControl?.removeFromParent()
                    self.battleTouchesBegan(touch)
                    break
                    
                case .endBattle:
                    break
                    
                case .battleEndInterval:
                    break
                    
                case .showBattleResult:
                    break
                    
                default:
                    #if DEBUG
                        //print(self.state)
                        fatalError()
                    #endif
                    break
                }
            }
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>) {
        super.touchesMoved(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                    
                case .askToStart:
                    break
                    
                case .askToSelect:
                    break
                    
                case .askToMove:
                    break
                    
                case .move:
                    Spaceship.touchEnded(touch)
                    break
                    
                case .askToSelectOther:
                    break

                    
                case .askWeaponRange:
                    break

                    
                case .battleWithOneMeteor:
                    self.battleTouchesMoved(touch)
                    break
                    
                case .endBattleWithOneMeteor:
                    break
                    
                case .askNearestTarget:
                    break
                    
                case .battleWithTwoMeteor:
                    self.battleTouchesMoved(touch)
                    break
                    
                case .endBattleWithTwoMeteor:
                    break
                    
                case .hotTip:
                    break
                    
                case .askBattleWithFourSpaceships:
                    break
                    
                case .battleWithFourSpaceships:
                    self.battleTouchesMoved(touch)
                    break
                    
                case .endBattleWithFourSpaceships:
                    break
                    
                case .askDestroyEnemyMothership:
                    break
                    
                case .destroyEnemyMothership:
                    self.battleTouchesMoved(touch)
                    break
                    
                case .endBattle:
                    break
                    
                case .battleEndInterval:
                    break
                    
                case .showBattleResult:
                    break
                    
                default:
                    #if DEBUG
                        //print(self.state)
                        fatalError()
                    #endif
                    break
                }
            }
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>) {
        super.touchesEnded(touches)
        
        //Estado atual
        if(self.state == self.nextState) {
            for touch in touches {
                switch (self.state) {
                    
                case .askToStart:
                    break
                    
                case .askToSelect:
                    break
                    
                case .askToMove:
                    break
                    
                case .move:
                    if let tutorialControl = self.tutorialControl {
                        if let parent = tutorialControl.parent {
                            if tutorialControl.containsPoint(touch.locationInNode(parent)) {
                                tutorialControl.removeFromParent()
                                self.nextState = .askToSelectOther
                            }
                        }
                    }
                    Spaceship.touchEnded(touch)
                    break
                    
                case .askToSelectOther:
                    if let spaceship = self.mothership.spaceships.last {
                        if let parent = spaceship.parent {
                            if spaceship.containsPoint(touch.locationInNode(parent)) {
                                spaceship.touchEnded()
                                self.tutorialControl!.removeFromParent()
                                self.touchImage?.removeFromParent()
                                self.nextState = .askWeaponRange
                            }
                        }
                    }
                    break
                    
                case .askWeaponRange:
                    break
                    
                case .battleWithOneMeteor:
                    self.battleTouchesEnded(touch)
                    break
                    
                case .endBattleWithOneMeteor:
                    break
                    
                case .askNearestTarget:
                    break
                    
                case .battleWithTwoMeteor:
                    self.battleTouchesEnded(touch)
                    break
                    
                case .endBattleWithTwoMeteor:
                    break
                
                case .hotTip:
                    break
                    
                case .askBattleWithFourSpaceships:
                    break
                    
                case .battleWithFourSpaceships:
                    self.battleTouchesEnded(touch)
                    break
                    
                case .endBattleWithFourSpaceships:
                    break
                    
                case .askDestroyEnemyMothership:
                    break
                    
                case .destroyEnemyMothership:
                    self.battleTouchesEnded(touch)
                    break
                    
                case .endBattle:
                    break
                    
                case .battleEndInterval:
                    break
                    
                case .showBattleResult:
                    break
                    
                default:
                    #if DEBUG
                        //print(self.state)
                        fatalError()
                    #endif
                    break
                }
            }
        }
    }
    
    func battleTouchesBegan(touch:UITouch) {
        
        if self.dangerAlert?.parent != nil {
            return
        }

        
        for asteroid in self.enemySpaceships {
            if let parent = asteroid.parent {
                if asteroid.containsPoint(touch.locationInNode(parent)) {                    
                    return
                }
            }
        }
        
        
        if let botMothership = self.botMothership {
            for enemyShip in botMothership.spaceships {
                if let parent = enemyShip.parent {
                    if enemyShip.containsPoint(touch.locationInNode(parent)) {
                        return
                    }
                }
            }
        }
        
        for spaceship in self.mothership.spaceships {
            if let parent = spaceship.parent {
                if spaceship.containsPoint(touch.locationInNode(parent)) {
                    spaceship.touchEnded()
                    return
                }
            }
        }
        
        if let botMothership = self.botMothership {
            if let parent = botMothership.parent {
                if botMothership.containsPoint(touch.locationInNode(parent)) {
                    return
                }
            }
        }
        
        if let parent = self.mothership.parent {
            if self.mothership.containsPoint(touch.locationInNode(parent)) {
                Spaceship.retreatSelectedSpaceship()
                return
            }
        }
        
        Spaceship.touchEnded(touch)
    }
    
    func battleTouchesMoved(touch:UITouch) {
        
        if self.dangerAlert?.parent != nil {
            return
        }
        
        if let botMothership = self.botMothership {
            if let parent = botMothership.parent {
                if botMothership.containsPoint(touch.locationInNode(parent)) {
                    return
                }
            }
        }
        
        if let parent = self.mothership.parent {
            if self.mothership.containsPoint(touch.locationInNode(parent)) {
                return
            }
        }
        
        Spaceship.touchEnded(touch)
    }
    
    func battleTouchesEnded(touch:UITouch) {
        
        if self.dangerAlert?.parent != nil {
            return
        }
        
        for asteroid in self.enemySpaceships {
            if let parent = asteroid.parent {
                if asteroid.containsPoint(touch.locationInNode(parent)) {
                    self.dangerAlert = TutorialDangerAlert()
                    self.addChild(self.dangerAlert!)
                    
                    return
                }
            }
        }
        
        
        if let botMothership = self.botMothership {
            for enemyShip in botMothership.spaceships {
                if let parent = enemyShip.parent {
                    if enemyShip.containsPoint(touch.locationInNode(parent)) {
                        self.dangerAlert = TutorialDangerAlert()
                        self.addChild(self.dangerAlert!)
                        
                        return
                    }
                }
            }
        }
        
        for spaceship in self.mothership.spaceships {
            if let parent = spaceship.parent {
                if spaceship.containsPoint(touch.locationInNode(parent)) {
                    spaceship.touchEnded()
                    return
                }
            }
        }
        
        
        if let botMothership = self.botMothership {
            if let parent = botMothership.parent {
                if botMothership.containsPoint(touch.locationInNode(parent)) {
                    return
                }
            }
        }
        
        if let parent = self.mothership.parent {
            if self.mothership.containsPoint(touch.locationInNode(parent)) {
                Spaceship.retreatSelectedSpaceship()
                return
            }
        }
        
        Spaceship.touchEnded(touch)
    }
}
