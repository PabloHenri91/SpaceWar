//
//  HangarSpaceshipsCell.swift
//  Game
//
//  Created by Paulo Henrique dos Santos on 22/08/16.
//  Copyright © 2016 PabloHenri91. All rights reserved.
//

import SpriteKit


class HangarSpaceshipsCell: Control {
    
    var spaceshipsSubCells: Array<HangarSpaceshipSubCell>!
    
    init(spaceships: Array<Spaceship>) {
        super.init()
        self.spaceshipsSubCells = Array<HangarSpaceshipSubCell>()
        
        for i in 0 ..< spaceships.count{
            
            let x = 51 + 90 * i
            let subCell = HangarSpaceshipSubCell(spaceship: spaceships[i], x:x)
            self.spaceshipsSubCells.append(subCell)
            
            self.addChild(subCell)
            
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
