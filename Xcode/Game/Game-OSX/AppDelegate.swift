//
//  AppDelegate.swift
//  Game-OSX
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright (c) 2016 PabloHenri91. All rights reserved.
//


import Cocoa
import SpriteKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate, NSWindowDelegate {
    
    @IBOutlet weak var window: NSWindow!
    @IBOutlet weak var skView: SKView!
    
    func applicationDidFinishLaunching(aNotification: NSNotification) {
        
        self.window.delegate = self
        
        Display.viewBoundsSize = self.skView.bounds.size
        
        let scene = LoadScene()
        
        self.skView!.presentScene(scene)
        
        /* Sprite Kit applies additional optimizations to improve rendering performance */
        self.skView!.ignoresSiblingOrder = true
        
        #if DEBUG
            skView.showsFPS = true
            skView.showsDrawCount = true
            skView.showsNodeCount = true
            skView.showsQuadCount = true
            skView.showsPhysics = true
        #endif
    }
    
    func windowDidResize(notification: NSNotification) {
        Display.viewBoundsSize = skView.bounds.size
        Display.updateSceneSize()
        self.skView.scene?.size = Display.currentSceneSize
        Control.resetControls()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(sender: NSApplication) -> Bool {
        return true
    }
    
    func applicationShouldTerminate(sender: NSApplication) -> NSApplicationTerminateReply {
        MemoryCard.sharedInstance.saveGame()
        return .TerminateNow
    }
}
