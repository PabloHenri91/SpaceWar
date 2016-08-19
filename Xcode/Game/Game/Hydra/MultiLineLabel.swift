//
//  MultiLineLabel.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 06/07/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit

class MultiLineLabel: Control {

    var words: [String] = []
    var labels: [Label] = []
    var labelMaxWidth: Int = 200
    var labelHeight = 0
    var text: String!
    var maxHeight: Int?
    
    init( text:String , maxWidth: Int = 200, x:Int = 0, y:Int = 0, color:SKColor = GameColors.black, fontName:String = GameFonts.fontName.museo500, fontSize:CGFloat = 16 , xAlign:Control.xAlignments = .left, yAlign:Control.yAlignments = .up, verticalAlignmentMode:SKLabelVerticalAlignmentMode = .Center, horizontalAlignmentMode:SKLabelHorizontalAlignmentMode  = .Center ) {
        
        super.init()
        self.text = text.translation()
        self.labelMaxWidth = maxWidth
        
        self.words = text.componentsSeparatedByString(" ")
        var labelIndex = 0
        
        for item in words {
            if labels.count == 0 {
                let label = Label(color: color, text: item, fontSize: fontSize, x: x, y: y, xAlign: xAlign, yAlign: yAlign, verticalAlignmentMode: verticalAlignmentMode, horizontalAlignmentMode: horizontalAlignmentMode)
                self.labelHeight = Int(label.calculateAccumulatedFrame().size.height)
                self.labels.append(label)
            } else {
                
                let label = self.labels[labelIndex]
                let oldText = label.getText()
                label.setText(oldText + " " + item)
                let newSize = label.calculateAccumulatedFrame().size.width
                
                if Int(newSize) > labelMaxWidth {
                    
                    labelIndex += 1
                    label.setText(oldText)
                    
                    let newLabel = Label(color: color, text: item, fontSize: fontSize, x: x, y: Int(y + ( labelHeight  * labelIndex)), xAlign: xAlign, yAlign: yAlign, verticalAlignmentMode: verticalAlignmentMode, horizontalAlignmentMode: horizontalAlignmentMode)

                    self.labels.append(newLabel)
                    
                    
                }
                
            }
        }
        
        for label in labels {
            self.addChild(label)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



