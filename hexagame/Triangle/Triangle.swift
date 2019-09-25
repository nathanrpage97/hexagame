//
//  Triangle.swift
//  HexagonGame
//
//  Created by Nathan on 9/24/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

class Triangle {
    /// The color of the triangle
    var color: TriangleColor = .base
    /// the direction the triangle is in the hexagon
    var direction: TriangleDirection

    /// the neighboring hexagon relative to the triangle direction
    var neighbor: Hexagon?

    /**
     Initializes a new base triangle in the given direction
     - Parameter direction: The direction of the triangle in the hexagon
     */
    init(direction: TriangleDirection) {
        self.direction = direction
    }

    /// Indicates if the triangle is connectable
    var isConnectable: Bool {
        return color != .base
    }

    /// Get the neighboring triangle
    var neighborTriangle: Triangle? {
        return neighbor?.getTriangle(direction: direction.opposite)
    }

    /// Determines if the triangle is truly connected to its neighbor
    var isConnected: Bool {
        return isConnectable && color == neighborTriangle?.color
    }

    /**
     Bind the neighboring hexagon to the triangle
     - Parameter neighbor: Neighboring hexagon of this triangle
     */
    func bindNeighbor(with neighbor: Hexagon?) {
        self.neighbor = neighbor
    }

    /**
     Create a connection between the triangle and its neighboring triangle
     - Parameter color: The color of the connection to create
     - Returns: Connection was successfully made
     */
    func createConnection(color: TriangleColor) -> Bool {
        guard let neighborTriangle = neighborTriangle else {
            return false
        }
        // only if it isn't currently connectable can you create a connection
        if isConnectable {
            return false
        }
        // pair up the connection colors
        neighborTriangle.color = color
        self.color = color
        return true
    }
}
