//
//  AlertBox.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 20/06/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class AlertBox: Box {
    
    var buttonCancel:Button!
    var buttonOK:Button!
    
    enum messageType {
        case okCancel
        case ok
    }
    
    init(title:String, text:String, type:AlertBox.messageType) {
        super.init(textureName: "alertBox")
        
        let scene = Control.gameScene!
        scene.blackSpriteNode.isHidden = false
        scene.blackSpriteNode.zPosition = 100000
        
        self.zPosition = 1000000
        
        self.addChild(Label(text:title, x:141, y:24))
        self.addChild(Label(text:text, x:141, y:71))
        
        switch (type) {
        case messageType.ok:
            self.buttonOK = Button(textureName: "buttonSmall", text: "Ok", x:93, y:102)
            self.addChild(self.buttonOK)
            self.buttonOK.addHandler({ [weak self] in
                scene.blackSpriteNode.isHidden = true
                self?.removeFromParent()
            })
            break
        case messageType.okCancel:
            
            self.buttonOK = Button(textureName: "buttonSmall", text: "Ok", x:43, y:102)
            self.addChild(self.buttonOK)
            self.buttonOK.addHandler({ [weak self] in
                scene.blackSpriteNode.isHidden = true
                self?.removeFromParent()
                })
            
            self.buttonCancel = Button(textureName: "buttonSmall", text: "Cancel", x:163, y:102)
            self.addChild(self.buttonCancel)
            self.buttonCancel.addHandler({ [weak self] in
                scene.blackSpriteNode.isHidden = true
                self?.removeFromParent()
                })
            break
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
