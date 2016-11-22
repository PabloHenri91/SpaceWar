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
    
    init(spaceships: Array<SpaceshipData>) {
        super.init()
        self.spaceshipsSubCells = Array<HangarSpaceshipSubCell>()
        
        var i = 0
        for spaceshipData in spaceships {
            let x = 51 + 90 * i
            let subCell = HangarSpaceshipSubCell(spaceshipData: spaceshipData, x:x)
            self.spaceshipsSubCells.append(subCell)
            
            self.addChild(subCell)
            i += 1
        }
        
        self.size.height = 90
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
