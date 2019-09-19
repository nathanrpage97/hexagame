//
//  LevelStructs.swift
//  hexagame
//
//  Created by Nathan on 7/17/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import GameplayKit

struct MetaLevel {
    var dificulty: Int
    var sizes: (width: ClosedRange<Int>, height: ClosedRange<Int>)
    var hexagonDensity: ClosedRange<Float>
    var colors: ClosedRange<Int>
    var colorDensity: ClosedRange<Float>
    var startHexagons: ClosedRange<Int>
}

struct LevelDescription {
    var size: (width: Int, height: Int)
    var totalHexagons: Int
    var colors: Int
    var connections: Int
    var startHexagons: Int

    init(rng: GKRandomSource, meta: MetaLevel) {
        // helper variables from rng
        let gridWidth = rng.nextInt(bounds: meta.sizes.width)
        let gridHeight = rng.nextInt(bounds: meta.sizes.height)
        let hexagonDensity = rng.nextUniform(bounds: meta.hexagonDensity)
        let connectionDensity = rng.nextUniform(bounds: meta.colorDensity)

        self.size = (width: gridWidth, height: gridHeight)
        self.totalHexagons = Int(Float(gridWidth * gridHeight) * hexagonDensity)
        self.colors = rng.nextInt(bounds: meta.colors)
        self.connections = Int(connectionDensity * Float(totalHexagons))
        self.startHexagons = rng.nextInt(bounds: meta.startHexagons)
    }
}
