//
//  BetteryControl.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 7/21/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class BatteryControl: Control {
    
    var maxCharge = GameMath.batteryMaxCharge
    var charge = 0
    var lastCharge:Date!
    
    var labelTimerLabel:Label!
    var labelTimerValue:Label!
    var chargeIndicator = [Control]()
    
    let timerPositionX:CGFloat = 85
    let timerPositionY:CGFloat = 32
    
    var lastUpdate:TimeInterval = 0
    
    init(x:Int = 0, y:Int = 0, xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up) {
        super.init(textureName: "batteryBackground", x: x, y: y, xAlign: xAlign, yAlign: yAlign)
        
        self.chargeIndicator.append(Control(textureName: "charge0", x: 1, y: 1))
        self.chargeIndicator.append(Control(textureName: "charge1", x: 42, y: 1))
        self.chargeIndicator.append(Control(textureName: "charge1", x: 85, y: 1))
        self.chargeIndicator.append(Control(textureName: "charge2", x: 128, y: 1))
        for control in self.chargeIndicator {
            self.addChild(control)
        }
        
        let color = SKColor(red: 60/255, green: 75/255, blue: 88/255, alpha: 1)
        
        self.labelTimerLabel = Label(color: color, text: "Next charge: ", fontSize:12, x: 0, y: 0, horizontalAlignmentMode: .right, fontName: GameFonts.fontName.museo700)
        self.addChild(self.labelTimerLabel)
        
        self.labelTimerValue = Label(color: color, text: "0m 00s", fontSize:12, x: 0, y: 0, horizontalAlignmentMode: .left, fontName: GameFonts.fontName.museo1000)
        self.addChild(self.labelTimerValue)
        
        self.updateLabels()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func centerLabels() {
        
        let labelTimerLabelWidth = self.labelTimerLabel.calculateAccumulatedFrame().size.width
        let labelTimerValueWidth = self.labelTimerValue.calculateAccumulatedFrame().size.width
        let translateX:CGFloat = (labelTimerLabelWidth - labelTimerValueWidth)/2
        
        self.labelTimerLabel.screenPosition = CGPoint(x: timerPositionX + translateX, y: timerPositionY)
        self.labelTimerLabel.resetPosition()
        
        self.labelTimerValue.screenPosition = CGPoint(x: timerPositionX + translateX, y: timerPositionY)
        self.labelTimerValue.resetPosition()
    }
    
    func useCharge() -> Bool {
        
        if self.charge == -1 {
            return true
        }
        
        if self.charge <= 0 {
            return false
        }
        
        if let battery = MemoryCard.sharedInstance.playerData!.battery {
            if battery.charge.intValue == GameMath.batteryMaxCharge {
                battery.lastCharge = Date()
            }
            battery.charge = ((battery.charge as Int) - 1) as NSNumber
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
        
        if let battery = MemoryCard.sharedInstance.playerData!.battery {
            
            self.charge = battery.charge.intValue
            self.lastCharge = battery.lastCharge as Date!
            
            while self.charge < self.maxCharge {
                
                if self.charge == -1 {
                    
                    if GameMath.batteryBoostTimeLeft(self.lastCharge) <= 0 {
                        self.lastCharge = Date()
                        battery.lastCharge = self.lastCharge
                        
                        self.charge = self.maxCharge
                        battery.charge = self.charge as NSNumber
                    }
                    break
                    
                } else {
                    if GameMath.batteryNextChargeTimeLeft(self.lastCharge) <= 0 {
                        self.lastCharge = Date(timeInterval: GameMath.batteryChargeInterval, since: self.lastCharge)
                        battery.lastCharge = self.lastCharge
                        
                        self.charge += 1
                        battery.charge = self.charge as NSNumber
                    } else {
                        break
                    }
                    
                    if self.charge >= self.maxCharge {
                        break
                    }
                }
            }
            
            var text = ""
            
            if self.charge == -1 {
                labelTimerLabel.setText("Boost time left: ")
                text = GameMath.timeLeftFormatted(timeLeft: GameMath.batteryBoostTimeLeft(self.lastCharge))
                
                for control in chargeIndicator {
                    control.isHidden = false
                }
                
            } else {
                if self.charge < self.maxCharge {
                    text = GameMath.timeLeftFormatted(timeLeft: GameMath.batteryNextChargeTimeLeft(self.lastCharge))
                }
                
                var i = 0
                for control in chargeIndicator {
                    control.isHidden = charge <= i
                    i += 1
                }
            }
            
            self.labelTimerValue.setText(text)
            if text == "" {
                
                if self.charge > self.maxCharge {
                    self.labelTimerLabel.setText((self.charge).description + " charges")
                } else {
                    self.labelTimerLabel.setText("Full")
                }
            }
            
            self.centerLabels()
        }
        
    }
}
