//
//  Hexagon.swift
//  HexagonGame
//
//  Created by Nathan on 9/24/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

class Hexagon: SKSpriteNode {
    /// Complete size of the Hexagon
    static let outerSize = CGSize(width: 120, height: 104)
    /// Useful size for tiling the hexagons and overlapping the border (Note: Some magic numbers are used)
    static let tilingSize = CGSize(width: 90 - sqrt(9), height: 101)

    /// Is it possible to move this hexagon
    var isMovable = true
    /// Is the user currently dragging this hexagon
    var isDragging = false
    /// Is the user currently selecting this hexagon to tap switch
    var isSelected = false

    /// The grid index of the
    var gridIndex: HexagonIndex

    /// All the triangles of the hexagon in their given direction
    let north = Triangle(direction: .north)
    let northEast = Triangle(direction: .northEast)
    let southEast = Triangle(direction: .southEast)
    let south = Triangle(direction: .south)
    let southWest = Triangle(direction: .southWest)
    let northWest = Triangle(direction: .northWest)

    /**
     Initializes a hexagon with a location and if it is movable
     */
    init(isMovable: Bool, gridIndex: HexagonIndex) {
        self.isMovable = isMovable
        self.gridIndex = gridIndex
        super.init(texture: SKTexture(imageNamed: "hexagonBase"), color: UIColor.clear, size: Hexagon.outerSize)
        self.position = gridIndex.position
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// **Ordered** Array of all the triangles in the hexagon
    var triangles: [Triangle] {
        return [north, northEast, southEast, south, southWest, northWest]
    }

    /// How many of the triangles are connectable
    var connectableCount: Int {
        return self.triangles.reduce(0, {total, triangle in total + (triangle.isConnectable ? 1 : 0)})
    }

    /// How many of the triangles are connected
    var connectedCount: Int {
        if self.isDragging {
            return 0
        }
        return self.triangles.reduce(0, {total, triangle in total + (triangle.isConnected ? 1 : 0)})
    }

    /// Is the hexagon have all its connectable triangles connected
    var isFullyConnected: Bool {
        return connectableCount == connectedCount
    }
    /**
     Get the hexagons triangle, given a side
     - Parameter direction: Direction of the triangle to select
     - Returns: Triangle in the given direction
     */
    func getTriangle(direction: TriangleDirection) -> Triangle {
        return triangles[direction.rawValue]
    }

    /**
     Determines if a  location is inside the hexagon
     - Parameter location: Point to check
     - Returns: If the location is inside the hexagon
     */
    func isTouching(location: CGPoint) -> Bool {
        return pow(location.x, 2) + pow(location.y, 2) < pow(Hexagon.tilingSize.height/2, 2)
    }
    /**
     Draw the hexagon texture using internal state
     - Parameters:
         - neighbors: should all the neighbors be drawn (only happens once)
         - lazy: if redrawing neighbors, should it draw only the neighbors truly connected (default: true)
     */
    func draw(neighbors: Bool) {
        self.texture = SKTexture(cgImage: HexagonDrawer.draw(hexagon: self))
        if neighbors {
            for triangle in self.triangles {
                triangle.neighbor?.draw(neighbors: false)
            }
        }
    }

    /**
     When the user starts dragging the hexagon, redraw and adjust zPosition
     */
    func startDragging() {
        isDragging = true
        zPosition = 100
        draw(neighbors: true)
    }

    /**
     When the user stops dragging the hexagon, redaw and adjust zPosition
     */
    func stopDragging() {
        isDragging = false
        zPosition = 0
        draw(neighbors: true)
    }

    /**
     When the user selects the hexagon, redaw itself and adjust zPosition
     */
    func select() {
        isSelected = true
        zPosition = 10
        draw(neighbors: false)
    }

    /**
     When the user deselects the hexagon, redaw itself and adjust zPosition
     */
    func deselect() {
        isSelected = false
        zPosition = 0
        draw(neighbors: false)
    }

    /**
     Reset the hexagon's position back to its grid location
     */
    func resetPosition() {
        self.position = gridIndex.position
    }

    /**
    Switch the colors with another hexagon
     - Parameters:
         - other: Hexagon to switch colors with
         - redraw: Whether to redaw the hexagons after switching the colors
     */
    func switchColors(other: Hexagon, redraw: Bool = true) {
        if !isMovable || !other.isMovable {
            return
        }

        for (triangleA, triangleB) in zip(triangles, other.triangles) {
            swap(&triangleA.color, &triangleB.color)
        }

        if redraw {
            self.draw(neighbors: true)
            other.draw(neighbors: true)
        }
    }
}
