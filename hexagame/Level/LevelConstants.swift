//
//  LevelConstants.swift
//  hexagame
//
//  Created by Nathan on 7/17/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import Foundation

/// Provide helpful constants to use for levels
struct LevelConstants {
    static let metas = [
        MetaLevel(
            dificulty: 0,
            sizes: (width: 3...4, height: 3...4),
            hexagonDensity: 0.4...0.5,
            colors: 1...2,
            colorDensity: 0.3...0.4,
            startHexagons: 1...1
        ),
        MetaLevel(
            dificulty: 1,
            sizes: (width: 4...5, height: 4...5),
            hexagonDensity: 0.4...0.5,
            colors: 2...2,
            colorDensity: 0.5...0.7,
            startHexagons: 1...1
        ),
        MetaLevel(
            dificulty: 2,
            sizes: (width: 4...6, height: 4...6),
            hexagonDensity: 0.5...0.6,
            colors: 2...3,
            colorDensity: 0.5...0.7,
            startHexagons: 1...2
        ),
        MetaLevel(
            dificulty: 3,
            sizes: (width: 4...6, height: 6...8),
            hexagonDensity: 0.4...0.5,
            colors: 2...4,
            colorDensity: 0.7...0.9,
            startHexagons: 1...2
        ),
        MetaLevel(
            dificulty: 4,
            sizes: (width: 5...7, height: 7...9),
            hexagonDensity: 0.5...0.6,
            colors: 3...4,
            colorDensity: 0.9...1.1,
            startHexagons: 1...3
        ),
        MetaLevel(
            dificulty: 5,
            sizes: (width: 6...7, height: 8...10),
            hexagonDensity: 0.5...0.6,
            colors: 4...5,
            colorDensity: 1.1...1.3,
            startHexagons: 1...3
        ),
        MetaLevel(
            dificulty: 6,
            sizes: (width: 7...8, height: 8...10),
            hexagonDensity: 0.6...0.6,
            colors: 4...5,
            colorDensity: 1.1...1.3,
            startHexagons: 1...3
        ),
        MetaLevel(
            dificulty: 7,
            sizes: (width: 7...8, height: 8...10),
            hexagonDensity: 0.7...0.8,
            colors: 4...6,
            colorDensity: 1.1...1.3,
            startHexagons: 1...3
        ),
        MetaLevel(
            dificulty: 8,
            sizes: (width: 8...9, height: 10...12),
            hexagonDensity: 0.7...0.8,
            colors: 4...6,
            colorDensity: 1.1...1.3,
            startHexagons: 1...4
        ),
        MetaLevel(
            dificulty: 9,
            sizes: (width: 8...9, height: 12...14),
            hexagonDensity: 0.5...0.8,
            colors: 4...6,
            colorDensity: 0.9...1.1,
            startHexagons: 2...4
        )
    ]
}
