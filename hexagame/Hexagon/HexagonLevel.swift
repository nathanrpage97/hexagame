//
//  HexagonLevel.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

/// A hexagon level contains the map of all hexagons
class HexagonLevel: SKSpriteNode {
    /// map of all hexagons
    var hexagons: [HexagonIndex: Hexagon]

    /// size of hexagon grid (bounds rowMax, colMax)
    var gridSize: (rows: Int, cols: Int)
    
    /// element used when dragging a hexagon to indicate where it came from
    let placeHolderHexagon = HexagonPlaceHolder()
    
    
    /// Initialize a hexagon level with hexagons
    ///
    /// - Parameters:
    ///   - hexagons: map of hexagons to use
    ///   - gridSize: size of hexagon grid (bounds rowMax, colMax)
    init(hexagons: [HexagonIndex: Hexagon], gridSize: (rows: Int, cols: Int)) {
        self.hexagons = hexagons
        let levelWidth = CGFloat(gridSize.cols) * Hexagon.innerSize.width * 2 + Hexagon.hexagonSize.width/4 + 4
        let levelHeight = CGFloat(gridSize.rows + 1) * Hexagon.innerSize.height/2 + 4
        self.gridSize = gridSize
        super.init(texture: nil, color: .clear, size: CGSize(width: levelWidth, height: levelHeight) )
        self.anchorPoint = CGPoint(x: 0, y: 0)
        
        self.position = CGPoint(x: -self.size.width/2, y:-self.size.height/2)
        self.addChild(placeHolderHexagon)
        for hexagon in hexagons.values {
            self.addChild(hexagon)
        }
        
    }
    /// Indicates if the level is completed
    var isFinished: Bool {
        for hexagon in hexagons.values {
            if !hexagon.isFullyConnected {
                return false
            }
        }
        return true
    }
    ///  Required by SpriteKit, should not call
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
