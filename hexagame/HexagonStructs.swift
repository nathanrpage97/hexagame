//
//  HexagonStructs.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

enum HexagonDirection: Int, CaseIterable {
    case north
    case northEast
    case southEast
    case south
    case southWest
    case northWest
    
    static func oppositeDirection(direction: HexagonDirection) -> HexagonDirection {
        switch direction {
        case .north:
            return .south
        case .northEast:
            return .southWest
        case .southEast:
            return .northWest
        case .south:
            return .north
        case .southWest:
            return .northEast
        case .northWest:
            return .southEast
        }
    }
}

enum HexagonSideColor: Int {
    case base = 0
    case red
    case blue
    case green
    case orange
    case purple
    case yellow
    
    static func uiColor(color: HexagonSideColor) -> UIColor {
        switch color {
        case .base:
            return UIColor(red: 200/255.0, green: 200/255.0, blue: 200/255.0, alpha: 1)
        case .red:
            return UIColor(red: 240/255.0, green: 120/255.0, blue: 90/255.0, alpha: 1)
        case .blue:
            return UIColor(red: 90/255.0, green: 140/255.0, blue: 240/255.0, alpha: 1)
        case .green:
            return UIColor(red: 20/255.0, green: 240/255.0, blue: 175/255.0, alpha: 1)
        case .orange:
            return UIColor(red: 240/255.0, green: 150/255.0, blue: 20/255.0, alpha: 1)
        case .purple:
            return UIColor(red: 220/255.0, green: 20/255.0, blue: 240/255.0, alpha: 1)
        case .yellow:
            return UIColor(red: 240/255.0, green: 230/255.0, blue: 20/255.0, alpha: 1)
        }
    }
}

struct HexagonIndex: Hashable, Comparable {
    var top: Int
    var left: Int
    
    func getNeighborIndex(direction: HexagonDirection) -> HexagonIndex {
        switch direction {
        case .north:
            return HexagonIndex(top: self.top + 2, left: self.left)
        case .northEast:
            return HexagonIndex(top: self.top + 1, left: self.left + (self.top % 2 == 0 ? 0 : 1))
        case .southEast:
            return HexagonIndex(top: self.top - 1, left: self.left + (self.top % 2 == 0 ? 0 : 1))
        case .south:
            return HexagonIndex(top: self.top - 2, left: self.left)
        case .southWest:
            return HexagonIndex(top: self.top - 1, left: self.left + (self.top % 2 == 0 ? -1 : 0))
        case .northWest:
            return HexagonIndex(top: self.top + 1, left: self.left + (self.top % 2 == 0 ? -1 : 0))
        }
    }
    
    static func == (lhs: HexagonIndex, rhs: HexagonIndex) -> Bool {
        return lhs.top == rhs.top && lhs.left == rhs.left
    }
    
    static func < (lhs: HexagonIndex, rhs: HexagonIndex) -> Bool {
        return lhs.top < rhs.top || (lhs.top == rhs.top && lhs.left < rhs.left)
    }
}
