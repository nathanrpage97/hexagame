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
        return connectionColor != .base
    }
    var neighborSide: HexagonSide? {
        get {
            return neighbor?.getSide(direction: direction.oppositeDirection)
        }
    }
    
    var neigborColor: HexagonSideColor? {
        return neighborSide?.connectionColor
    }
    
    var isConnected: Bool {
        return isConnectable && connectionColor == neighborSide?.connectionColor
    }
    
    var isSameNeighborColor: Bool {
        return connectionColor == neighborSide?.connectionColor
    }
    
    func bindNeighbors(parentHexagon: Hexagon, otherHexagon: Hexagon?) {
        self.neighbor = otherHexagon
        otherHexagon?.getSide(direction: direction.oppositeDirection).neighbor = parentHexagon
    }
    
    
    func createConnection(connectionColor: HexagonSideColor) -> Bool {
        if self.connectionColor != .base {
            return false
        }
        guard let neighborSide = neighborSide else {
            return false
        }
        neighborSide.connectionColor = connectionColor
        self.connectionColor = connectionColor
        return true
    }
}
