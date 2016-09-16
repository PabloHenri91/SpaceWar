//
//  NextEvents.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 8/12/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class NextEvents: Control {
    
    var lastUpdate:Double = 0
    
    var upcomingEvents = [EventCard]()
    
    override init() {
        let spriteNode = SKSpriteNode(color: SKColor.clear, size: CGSize(width: 10, height: 10))
        
        super.init(spriteNode: spriteNode, x: 31, y: 369, xAlign: .center, yAlign: .center)
        
        let color = SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1)
        let shadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 10/100)
        
        var allEvents = [EventCard]()
        
        let playerData = MemoryCard.sharedInstance.playerData!
        
        for item in playerData.researches {
            if let researchData = item as? ResearchData {
                if researchData.done.boolValue == false && researchData.startDate != nil {
                    allEvents.append(EventCard(researchData: researchData))
                }
            }
        }
        
        for item in playerData.missionSpaceships {
            if let missionSpaceshipData = item as? MissionSpaceshipData {
                if missionSpaceshipData.missionType.intValue > -1 {
                    allEvents.append(EventCard(missionSpaceshipData: missionSpaceshipData))
                }
            }
        }
        
        allEvents.sort { (eventCard0, eventCard1) -> Bool in
            return eventCard0.timeLeft() < eventCard1.timeLeft()
        }
        
        var allEventsIndex = 0
        for event in allEvents {
            upcomingEvents.append(event)
            allEventsIndex += 1
            if !(allEventsIndex < 3) {
                break
            }
        }
        
        var eventIndex = 0
        for event in upcomingEvents {
            event.load(eventIndex, upcomingEventsCount: upcomingEvents.count)
            self.addChild(event)
            eventIndex += 1
        }
        
        var titleText = ""
        
        switch true {
        case upcomingEvents.count < 1:
            break
        case upcomingEvents.count == 1:
            titleText = "NEXT EVENT"
            break
            
        case upcomingEvents.count > 1:
            titleText = "UPCOMING EVENTS"
            break
            
        default:
            break
        }
        
        self.addChild(Label(color: color, text: titleText, fontSize: 14, x: 128, y: 11, verticalAlignmentMode: .baseline, fontName: GameFonts.fontName.museo1000, shadowColor: shadowColor, shadowOffset: CGPoint(x: 0, y: -2)))
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update() {
        if GameScene.currentTime - self.lastUpdate > 1 {
            self.lastUpdate = GameScene.currentTime
            
            for event in self.upcomingEvents {
                event.update()
            }
        }
    }
    
}

class EventCard: Control {
    
    enum types: String {
        case none
        case missionSpaceshipEvent
        case researchEvent
    }
    
    static let backgroundTextureName = "eventCardBackground"
    
    var missionSpaceshipData: MissionSpaceshipData?
    var researchData: ResearchData?
    
    var type = types.none
    
    var labelTime:Label!
    
    var timeBar:TimeBar!
    
    var duration = 1
    
    override init() {
        super.init(textureName: EventCard.backgroundTextureName)
    }
    
    init(missionSpaceshipData: MissionSpaceshipData) {
        super.init(textureName: EventCard.backgroundTextureName)
        self.missionSpaceshipData = missionSpaceshipData
        self.type = .missionSpaceshipEvent
        self.duration = MissionSpaceship.types[self.missionSpaceshipData!.missionType.intValue].duration
    }
    
    init(researchData: ResearchData) {
        super.init(textureName: EventCard.backgroundTextureName)
        self.researchData = researchData
        self.type = .researchEvent
        self.duration = Research.types[self.researchData!.type.intValue].duration
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func load(_ index: Int, upcomingEventsCount: Int) {
        
        var x = 0
        let y = 30
        
        switch upcomingEventsCount {
        case 1:
            switch index {
            case 0:
                x = 96
                break
            default:
                break
            }
            break
        case 2:
            switch index {
            case 0:
                x = 48
                break
            case 1:
                x = 144
                break
            default:
                break
            }
            break
        case 3:
            switch index {
            case 1:
                x = 96
                break
            case 2:
                x = 192
                break
            default:
                break
            }
            break
        default:
            break
        }
        
        self.screenPosition = CGPoint(x: x, y: y)
        self.resetPosition()
        
        var timerType = TimeBar.types.missionSpaceshipTimer
        switch self.type {
        case .missionSpaceshipEvent:
            timerType = TimeBar.types.missionSpaceshipTimer
            break
        case .researchEvent:
            timerType = TimeBar.types.researchTimer
            if let researchData = self.researchData {
                if let spaceshipUnlocked = Research.types[researchData.type.intValue].spaceshipUnlocked {
                    if let weaponUnlocked = Research.types[researchData.type.intValue].weaponUnlocked {
                        let spaceship = Spaceship(type: spaceshipUnlocked, level: 0)
                        spaceship.addWeapon(Weapon(type: weaponUnlocked, level: 1, loadSoundEffects: false))
                        spaceship.position = CGPoint(x: Int(self.size.width/2), y: -Int(self.size.height/2))
                        self.addChild(spaceship)
                    }
                }
            }
            break
        default:
            break
        }
        
        let timeLeft = self.timeLeft()
        var text = "Finished"
        if timeLeft > 0 {
            text = GameMath.timeFormated(timeLeft)
        }
        
        let color = SKColor(red: 48/255, green: 60/255, blue: 70/255, alpha: 1)
        let shadowColor = SKColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 10/100)
        
        
        self.labelTime = Label(color: color, text: text, fontSize: 11, x: 33, y: 92, verticalAlignmentMode: .baseline, fontName: GameFonts.fontName.museo1000, shadowColor: shadowColor, shadowOffset: CGPoint(x: 0, y: -2))
        self.labelTime.zPosition = 25
        self.addChild(self.labelTime)
        
        
        self.timeBar = TimeBar(textureName: "timeBarVerySmall", x: 0, y: 78, loadLabel: false, type: timerType, loadBorder: false)
        self.addChild(self.timeBar.cropNode)
        self.addChild(Control(textureName: "timeBarVerySmallBorder", x: -2, y: 76))
    }
    
    func update() {
        let timeLeft = self.timeLeft()
        var text = "Finished"
        if timeLeft > 0 {
            text = GameMath.timeFormated(timeLeft)
        }
        
        self.timeBar.update(startDate: self.startDate()!, duration: self.duration)
        self.labelTime.setText(text)
    }
    
    func startDate() -> Date? {
        switch self.type {
            
        case .missionSpaceshipEvent:
            return self.missionSpaceshipData?.startMissionDate as Date?
            
        case .researchEvent:
            return self.researchData?.startDate as Date?
            
        default:
            return nil
            
        }
    }
    
    func timeLeft() -> Int {
        
        switch self.type {
            
        case .missionSpaceshipEvent, .researchEvent:
            return GameMath.timeLeft(startDate: self.startDate()!, duration: self.duration)
            
        default:
            return 0
        }
    }
    
}
