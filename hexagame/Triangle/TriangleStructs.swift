//
//  HexagonStructures.swift
//  HexagonGame
//
//  Created by Nathan on 9/24/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

/// The six directions a triangle can be in a hexagon
enum TriangleDirection: Int, CaseIterable {
    case north = 0
    case northEast
    case southEast
    case south
    case southWest
    case northWest

    /// Direction oppsite of the current triange direction
    var opposite: TriangleDirection {
        return TriangleDirection.init(rawValue: (self.rawValue + 3) % 6) ?? .north
    }

    /// Direction to the left (facing out from center of hexagon)
    var left: TriangleDirection {
        return TriangleDirection.init(rawValue: (self.rawValue - 1) % 6) ?? .north
    }

    /// Direction to the right (facing out from center of hexagon)
    var right: TriangleDirection {
        return TriangleDirection.init(rawValue: (self.rawValue + 1) % 6) ?? .north
    }
}

/// Provides all the possible colors of a hexagon triangle
enum TriangleColor: Int {
    case base = 0 // the default one which isn't connectable
    case red
    case blue
    case green
    case orange
    case purple
    case yellow

    /// give the corresponding color as a UIColor
    var uiColor: UIColor {
        switch self {
        case .base:
            return UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        case .red:
            return UIColor(red: 255/255.0, green: 90/255.0, blue: 90/255.0, alpha: 1)
        case .blue:
            return UIColor(red: 90/255.0, green: 140/255.0, blue: 240/255.0, alpha: 1)
        case .green:
            return UIColor(red: 20/255.0, green: 240/255.0, blue: 155/255.0, alpha: 1)
        case .orange:
            return UIColor(red: 240/255.0, green: 150/255.0, blue: 20/255.0, alpha: 1)
        case .purple:
            return UIColor(red: 220/255.0, green: 20/255.0, blue: 240/255.0, alpha: 1)
        case .yellow:
            return UIColor(red: 240/255.0, green: 230/255.0, blue: 20/255.0, alpha: 1)
        }
    }
}
