//
//  BetteryControl.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/21/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BatteryControl: Control {
    
    var maxCharge = GameMath.maxCharge
    var charge = 0
    var lastCharge:NSDate!
    
    var labelTimer:Label!
    var chargeIndicator = [Control]()
    
    
    var lastUpdate:NSTimeInterval = 0
    
    init(x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init(textureName: "batteryBackground", x: x, y: y, xAlign: xAlign, yAlign: yAlign)
        
        self.chargeIndicator.append(Control(textureName: "charge0", x: 1, y: 1))
        self.chargeIndicator.append(Control(textureName: "charge1", x: 42, y: 1))
        self.chargeIndicator.append(Control(textureName: "charge1", x: 85, y: 1))
        self.chargeIndicator.append(Control(textureName: "charge2", x: 128, y: 1))
        for control in self.chargeIndicator {
            self.addChild(control)
        }
        
        self.labelTimer = Label(color: GameColors.white, text: "?", x: 67, y: 43)
        self.addChild(self.labelTimer)
        
        self.updateLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func useCharge() -> Bool {
        if self.charge <= 0 {
            return false
        }
        
        if let battery = MemoryCard.sharedInstance.playerData.battery {
            if battery.charge.integerValue == GameMath.maxCharge {
                battery.lastCharge = NSDate()
            }
            battery.charge = battery.charge.integerValue - 1
        }
        
        return true
    }
    
    func update() {
        if GameScene.currentTime - self.lastUpdate > 1 {
            self.lastUpdate = GameScene.currentTime
            self.updateLabels()
        }
    }
    
    func updateLabels() {
        
        if self.charge < self.maxCharge {
            if let battery = MemoryCard.sharedInstance.playerData.battery {
                
                self.charge = battery.charge.integerValue
                self.lastCharge = battery.lastCharge
                
                while self.charge < self.maxCharge {
                    
                    if GameMath.batteryChargeTime(self.lastCharge) <= 0 {
                        self.lastCharge = NSDate(timeInterval: GameMath.batteryChargeInterval, sinceDate: self.lastCharge)
                        battery.lastCharge = self.lastCharge
                        
                        self.charge += 1
                        battery.charge = self.charge
                    } else {
                        break
                    }
                    
                    if self.charge >= self.maxCharge {
                        break
                    }
                }
                
                
                
                var text = "Full"
                if self.charge < self.maxCharge {
                    text = GameMath.timeFormated(GameMath.batteryChargeTime(self.lastCharge))
                }
                
                var i = 0
                for control in chargeIndicator {
                    control.hidden = charge <= i
                    i += 1
                }
                
                self.labelTimer.setText(text)
            }
        }
    }
}
