//
//  HexagonStructures.swift
//  HexagonGame
//
//  Created by Nathan on 9/24/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

/// Provides indexing for a hexagon. Allows hashable for use in map and comparable for ordering
struct HexagonIndex: Hashable, Comparable {
    /// row position of the hexagon
    var row: Int
    /// column position of the hexagon
    var col: Int

    /**
     Get the index of neighbor given a direction
     - Parameter direction: which direction to get neighbor
     - Returns: neighbor indexx in the direction specified
    */
    func getNeighborIndex(direction: TriangleDirection) -> HexagonIndex {
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

    /// Position of the hexagon based upon its grid index
    var position: CGPoint {
        var gridX = (2 * CGFloat(col) * Hexagon.tilingSize.width) + (0.5 * Hexagon.tilingSize.width)
        // every odd row gets shifted
        if row % 2 == 1 {
            gridX += Hexagon.tilingSize.width
        }

        let gridY = (0.5 * CGFloat(row) * Hexagon.tilingSize.height) + (0.5 * Hexagon.tilingSize.height)

        return CGPoint(x: gridX, y: gridY)
    }
}
