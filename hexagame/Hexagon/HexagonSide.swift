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
    var parent: Hexagon?
    var direction: HexagonDirection
    
    init(direction: HexagonDirection) {
        self.direction = direction
    }
    
    func bind(hexagon: Hexagon) {
        self.parent = hexagon
    }
    var isConnectable: Bool {
        get {
            return connectionColor != .base
        }
    }
    var neighborSide: HexagonSide? {
        get {
            return neighbor?.getSide(direction: HexagonDirection.oppositeDirection(direction: direction))
        }
    }
    
    var neigborColor: HexagonSideColor? {
        get {
            return neighborSide?.connectionColor
        }
    }
    
    var acrossSides: (HexagonSide?, HexagonSide?) {
        get {
            switch direction {
            case .north:
                return (parent?.northWest, parent?.northEast)
            case .northEast:
                return (parent?.north, parent?.southEast)
            case .southEast:
                return (parent?.northEast, parent?.south)
            case .south:
                return (parent?.southEast, parent?.southWest)
            case .southWest:
                return (parent?.south, parent?.northWest)
            case .northWest:
                return (parent?.southWest, parent?.north)
            }
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
    
    var isSameNeighborColor: Bool {
        get {
            return connectionColor == neighborSide?.connectionColor
            
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
