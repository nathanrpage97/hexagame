//
//  HexagonSide.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//
import SpriteKit

class HexagonSide {
    var connectionColor: HexagonSideColor = .base
    var neighbor: Hexagon?
    var direction: HexagonDirection
    
    init(direction: HexagonDirection) {
        self.direction = direction
    }
    
    var isConnectable: Bool {
        get {
            return connectionColor != .base
        }
    }
    
    var isConnected: Bool {
        get {
            if let neighbor = neighbor {
                if neighbor.isDragging {
                    return false
                }
                let neighborSide = neighbor.getSide(direction: HexagonDirection.oppositeDirection(direction: direction))
                return isConnectable && connectionColor == neighborSide.connectionColor
            }
            return false
            
        }
    }
    
    func bindNeighbors(parentHexagon: Hexagon, otherHexagon: Hexagon?) {
        self.neighbor = otherHexagon
        otherHexagon?.getSide(direction: HexagonDirection.oppositeDirection(direction: direction)).neighbor = parentHexagon
    }
    
    
    func createConnection(connectionColor: HexagonSideColor) -> Bool {
        if let neighbor = neighbor {
            neighbor.getSide(direction: HexagonDirection.oppositeDirection(direction: direction)).connectionColor = connectionColor
            self.connectionColor = connectionColor
            return true
        }
        return false
    }
}
