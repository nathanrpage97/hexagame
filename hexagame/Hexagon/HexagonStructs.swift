//
//  HexagonStructs.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

/// Provides a means to show the six directions of a hexagon
enum HexagonDirection: Int, CaseIterable {
    case north
    case northEast
    case southEast
    case south
    case southWest
    case northWest

    /// gets the opposite direction of the hexagon
    var oppositeDirection: HexagonDirection {
        switch self {
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

    /// gets the direction to the left (facing out from center of hexagon)
    var left: HexagonDirection {
        switch self {
        case .north:
            return .northWest
        case .northEast:
            return .north
        case .southEast:
            return .northEast
        case .south:
            return .southEast
        case .southWest:
            return .south
        case .northWest:
            return .southWest
        }
    }

    /// gets the direction to the right (facing out from center of hexagon)
    var right: HexagonDirection {
        switch self {
        case .north:
            return .northEast
        case .northEast:
            return .southEast
        case .southEast:
            return .south
        case .south:
            return .southWest
        case .southWest:
            return .northWest
        case .northWest:
            return .north
        }
    }
}

/// Provide all the possbile colors of a hexagon
enum HexagonSideColor: Int {
    case base = 0 // the default one which isn't connectable
    case red
    case blue
    case green
    case orange
    case purple
    case yellow

    /// give the uiColor for a given enum
    var uiColor: UIColor {
        switch self {
        case .base:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
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

/// Provides indexing for a hexagon. Allows hashable for use in map and comparable for ordering
struct HexagonIndex: Hashable, Comparable {
    /// row position of the hexagon
    var row: Int
    /// column position of the hexagon
    var col: Int

    /// Get the index of neighbor given a direction
    ///
    /// - Parameter direction: which direction to get neighbor
    /// - Returns: neighbor indexx in the direction specified
    func getNeighborIndex(direction: HexagonDirection) -> HexagonIndex {
        switch direction {
        case .north:
            return HexagonIndex(row: self.row + 2, col: self.col)
        case .northEast:
            return HexagonIndex(row: self.row + 1, col: self.col + (self.row % 2 == 0 ? 0 : 1))
        case .southEast:
            return HexagonIndex(row: self.row - 1, col: self.col + (self.row % 2 == 0 ? 0 : 1))
        case .south:
            return HexagonIndex(row: self.row - 2, col: self.col)
        case .southWest:
            return HexagonIndex(row: self.row - 1, col: self.col + (self.row % 2 == 0 ? -1 : 0))
        case .northWest:
            return HexagonIndex(row: self.row + 1, col: self.col + (self.row % 2 == 0 ? -1 : 0))
        }
    }

    /// Implementation for comparable
    static func == (lhs: HexagonIndex, rhs: HexagonIndex) -> Bool {
        return lhs.row == rhs.row && lhs.col == rhs.col
    }

    /// Implementation for comparable. Row is more important than column
    static func < (lhs: HexagonIndex, rhs: HexagonIndex) -> Bool {
        return lhs.row < rhs.row || (lhs.row == rhs.row && lhs.col < rhs.col)
    }

    static func - (lhs: HexagonIndex, rhs: HexagonIndex) -> HexagonIndex {
        return HexagonIndex(row: lhs.row - rhs.row, col: lhs.col - rhs.col)
    }
}
