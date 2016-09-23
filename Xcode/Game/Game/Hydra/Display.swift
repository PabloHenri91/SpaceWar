//
//  Display.swift
//  Game
//
//  Created by Pablo Henrique Bertaco on 5/14/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class Display {
    
    static var filteringMode = SKTextureFilteringMode.Linear
    
    static var viewBoundsSize:CGSize!
    
    static var translate:CGPoint!
    static var translateInView:CGPoint!
    static var currentSceneSize:CGSize!
    
    static let screenScale:CGFloat = 1 // 1x, 2x, 3x
    
    static let defaultSceneSize = CGSize(width: 320/screenScale, height: 568/screenScale)
    static var sceneSize:CGSize = defaultSceneSize
    
    static var scale:CGFloat!
    
    static func updateSceneSize() -> CGSize {
        
        let xScale = viewBoundsSize.width / sceneSize.width
        let yScale = viewBoundsSize.height / sceneSize.height
        Display.scale = min(xScale, yScale)
        
        Display.translate = CGPoint(
            x: Int(((viewBoundsSize.width - (sceneSize.width * scale))/2)/scale),
            y: Int(((viewBoundsSize.height - (sceneSize.height * scale))/2)/scale))
        
        Display.translateInView = CGPoint(
            x: ((viewBoundsSize.width - (sceneSize.width * scale))/2)/scale,
            y: ((viewBoundsSize.height - (sceneSize.height * scale))/2))
        
        Display.currentSceneSize = CGSize(
            width: Int(viewBoundsSize.width / scale),
            height: Int(viewBoundsSize.height / scale))
        
        return Display.currentSceneSize
    }}
