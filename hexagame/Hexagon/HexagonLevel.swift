//
//  HexagonLevel.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

class HexagonLevel: SKSpriteNode {
    var hexagons: [HexagonIndex: Hexagon]
    var gridSize: CGSize
    var isFinished: Bool {
        for hexagon in hexagons.values {
            if !hexagon.isFullyConnected {
                return false
            }
        }
        return true
    }
    let placeHolderHexagon = HexagonPlaceHolder()

    
    init(hexagons: [HexagonIndex: Hexagon], gridSize: CGSize) {
        self.hexagons = hexagons
        let levelWidth = gridSize.width * Hexagon.innerSize.width * 2 + Hexagon.hexagonSize.width/4 + 4
        let levelHeight = (gridSize.height + 1) * Hexagon.innerSize.height/2 + 4
        self.gridSize = gridSize
        super.init(texture: nil, color: UIColor.clear, size: CGSize(width: levelWidth, height: levelHeight) )
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.position = CGPoint(x: -self.size.width/2, y:-self.size.height/2)
        self.addChild(placeHolderHexagon)
        for hexagon in hexagons.values {
            self.addChild(hexagon)
        }
        
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getHexagon(index: HexagonIndex) -> Hexagon? {
        return hexagons[index]
    }
    
    func switchHexagons(srcHexagon: Hexagon, destinationHexagon: Hexagon) {
        srcHexagon.switchColors(hexagon: destinationHexagon)
    }
}
