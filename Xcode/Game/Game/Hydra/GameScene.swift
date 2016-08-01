//
//  GameScene.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/29/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

#if os(OSX)
public typealias UITouch = NSEvent
import Foundation
#endif

class GameScene: SKScene {
    
    static var lastChildren = [SKNode]()
    
    static var selectedButton:Button? {
        willSet(newValue) {
            #if os(tvOS)
                selectedButton?.buttonRelease()
                newValue?.buttonPress()
            #endif
        }
    }
    
    static var nextButton:Button?
    
    static var currentTime:NSTimeInterval = 0
    
    static var transition = SKTransition.crossFadeWithDuration(0)
    
    var blackSpriteNode:BlackSpriteNode!
    
    override init(size:CGSize = Display.defaultSceneSize) {
        
        Display.sceneSize = size
        Display.updateSceneSize()
        
        super.init(size: Display.currentSceneSize)
        self.backgroundColor = SKColor(red: 201/255, green: 207/255, blue: 213/255, alpha: 1)
        
        Control.controlList = Set<Control>()
        Button.buttonList = Set<Button>()
        ScrollNode.scrollNodeList = Set<ScrollNode>()
        
        for textField in GameTextField.textFieldList {
            textField.removeFromParent()
        }
        
        GameTextField.textFieldList = Set<GameTextField>()
        
        #if os(iOS) || os(tvOS)
            Control.touchesArray = [UITouch: Double]()
        #endif
        
        #if os(OSX)
            Control.touchesArray = [NSEvent: Double]()
            
            Control.location = NSPoint.zero
            Control.previousLocation = NSPoint.zero
        #endif
        
        GameScene.selectedButton = nil
        
        self.blackSpriteNode = BlackSpriteNode()
        self.addChild(self.blackSpriteNode)
        
        Spaceship.selectedSpaceship = nil
        
        Mothership.mothershipList = Set<Mothership>()
        Spaceship.spaceshipList = Set<Spaceship>()
        //TODO: Class.classSet = Set<Class>()
    }
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        self.scaleMode = SKSceneScaleMode.AspectFit
        self.anchorPoint = CGPoint(x: 0, y: 1)
        Control.gameScene = self
        
        self.physicsWorld.gravity = CGVector(dx: 0, dy: 0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(currentTime: NSTimeInterval) {
        GameScene.currentTime = currentTime
        ScrollNode.update()
    }
    
    func setAlertState() {
        fatalError()
    }
    
    func setDefaultState() {
        fatalError()
    }
    
    override func didFinishUpdate() {
        //print("dX: " + Control.dx.description + " dY: " + Control.dy.description)
        Control.dx = 0
        Control.dy = 0
    }
    
     #if os(iOS) || os(tvOS)
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesBegan(touches, self)
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesMoved(touches, self)
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        Control.touchesEnded(touches, self)
    }
    
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        Control.touchesCancelled(self)
    }
    #endif
    
    #if os(tvOS)
    
    //sobreescrever e retornar true caso queira executar lógica normal de UIResponder.
    
    func pressBegan(press: UIPress) -> Bool {
        return false
    }
    
    func pressChanged(press: UIPress) -> Bool {
        return false
    }
    
    func pressEnded(press: UIPress) -> Bool {
        return false
    }
    
    #endif
    
    #if os(OSX)
    override func mouseDown(theEvent: NSEvent) {
        Control.mouseDown(theEvent, self)
    }
    
    override func mouseDragged(theEvent: NSEvent) {
        Control.mouseDragged(theEvent, self)
    }
    
    override func mouseUp(theEvent: NSEvent) {
        Control.mouseUp(theEvent, self)
    }
    
    override func keyUp(theEvent: NSEvent) {
        switch theEvent.keyCode {
        default:
            break
        }
    }
   #endif
}

#if os(iOS) || os(tvOS)
    public extension UIResponder {
        func touchesBegan(touches: Set<UITouch>) {
            
        }
        func touchesMoved(touches: Set<UITouch>) {
            
        }
        func touchesEnded(touches: Set<UITouch>) {
            
        }
        func touchesCancelled() {
            
        }
        func touchesEnded(taps touches: Set<UITouch>) {
            
        }
    }
#endif

#if os(OSX)
    public extension NSResponder {
        func touchesBegan(touches: Set<UITouch>) {
            
        }
        func touchesMoved(touches: Set<UITouch>) {
            
        }
        func touchesEnded(touches: Set<UITouch>) {
            
        }
        func touchesCancelled() {
            
        }
        func touchesEnded(taps touches: Set<UITouch>) {
            
        }
    }
    
    public func ==(left: NSEvent, right: NSEvent) -> Bool {
        return true
    }
    
    public extension SKNode {
        func printTree(name:String = "root") {
            for node in self.children {
                let nodeName = node.className.componentsSeparatedByString(".").last!
                print(name + " " + nodeName + " " + node.zPosition.description)
                node.printTree(name + " " + nodeName)
            }
        }
    }
    
#endif



