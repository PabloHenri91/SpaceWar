//
//  GameFonts.swift
//  SpaceGame
//
//  Created by Pablo Henrique Bertaco on 10/29/15.
//  Copyright © 2015 Pablo Henrique Bertaco. All rights reserved.
//

import SpriteKit

class GameFonts {
    
    /*
    No problem to use custom fonts, I did it. Follow these steps:
    
    Register the font in your info.plist adding the "Fonts provided by application" entry. Put the font file name, not the font name. Like font.ttf (I think you already did that)
    
    Go to your project on the project navigator, click on the project name and go to "build phases" then look down in "Copy Bundle Resources" go to the bottom, there are a lot of files and search for the "+" sign. A popup window will open with your project files. Search for your font file and add it to the bundle.
    
    Finally check the font name. When you use it in your code, you have to use the font name, not the file name. To know the font name, double click on the font file in Finder and a window will open showing the font. Check that window title, that's the name of the font that you have to use.
    */
    
    static var minFontSize = CGFloat(11)
    
    struct fontName {
        static var museo1000 = "Museo Sans Rounded 1000 Regular"
        static var museo500 = "Museo Sans Rounded 500 Regular"
    }

}
