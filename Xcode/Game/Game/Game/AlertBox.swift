//
//  AlertBox.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 20/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import UIKit
import SpriteKit

class AlertBox: Control {
    
    var touchesEndedAtButtonCancel:Event<Void> = Event()
    var touchesEndedAtButtonOK:Event<Void> = Event()
    
    var buttonCancel:Button!
    var buttonOK:Button!
    
    enum messageType {
        case OKCancel
        case OK
    }
    
    static var messageBoxCount = 0
    
    init(title:String, text:String, type:AlertBox.messageType) {
        
  
        let texture = SKTexture(imageNamed: "alertBox")
        let spriteNode = SKSpriteNode(texture: texture, color: UIColor.clearColor(), size: texture.size())
        
        let position = CGPoint(x: Display.sceneSize.width/2 - texture.size().width/2,
                               y: Display.sceneSize.height/2  - texture.size().height/2)
      
        super.init(spriteNode: spriteNode, x: Int(position.x), y: Int(position.y), xAlign:.center, yAlign:.center)
        
        self.zPosition = 1000000
        
        self.addChild(Label(text:title, x:141, y:24))
        self.addChild(Label(text:text, x:141, y:71))
        
        switch (type) {
        case messageType.OK:
            self.buttonOK = Button(textureName: "buttonSmall", text: "Ok", x:93, y:102)
            self.addChild(self.buttonOK)
            break
        case messageType.OKCancel:
            self.buttonOK = Button(textureName: "buttonSmall", text: "Ok", x:262, y:162)
            self.addChild(self.buttonOK)
            self.buttonCancel = Button(textureName: "buttonSmall", text: "Cancel", x:14, y:162)
            self.addChild(self.buttonCancel)
            break
        }
        
        self.hidden = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Button.touchesEnded(touches )
        for touch in (touches ) {
            let location = touch.locationInNode(self)
            
            if let _ = self.buttonCancel {
                if (self.buttonCancel.containsPoint(location) == true) {
                    self.hidden = true
                    self.touchesEndedAtButtonCancel.raise()
                    self.removeFromParent()
                    return
                }
            }
            
            if let _ = self.buttonOK {
                if (self.buttonOK.containsPoint(location) == true) {
                    self.hidden = true
                    self.touchesEndedAtButtonOK.raise()
                    self.removeFromParent()
                    return
                }
            }
        }
    }
    
    override var hidden: Bool {
        didSet {
            self.userInteractionEnabled = !hidden
        }
    }
}
