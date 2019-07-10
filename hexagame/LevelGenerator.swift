//
//  LevelGenerator.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//
import GameplayKit

struct MetaLevel {
    var dificulty: Int
    var sizes: (width:ClosedRange<Int>, height: ClosedRange<Int>)
    var hexagonDensity: ClosedRange<Double>
    var colors: ClosedRange<Int>
    var colorDensity: ClosedRange<Double>
    var startHexagons: ClosedRange<Int>
}

struct LevelDescription {
    var size: (width: Int, height: Int)
    var totalHexagons: Int
    var colors: Int
    var connections: Int
    var startHexagons: Int
}

let metas = [
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
        sizes: (width: 5...7, height: 5...7),
        hexagonDensity: 0.4...0.5,
        colors: 2...4,
        colorDensity: 0.7...0.9,
        startHexagons: 1...2
    ),
    MetaLevel(
        dificulty: 4,
        sizes: (width: 5...7, height: 5...7),
        hexagonDensity: 0.5...0.6,
        colors: 3...4,
        colorDensity: 0.9...1.1,
        startHexagons: 1...3
    ),
    MetaLevel(
        dificulty: 5,
        sizes: (width: 6...7, height: 6...7),
        hexagonDensity: 0.5...0.6,
        colors: 4...5,
        colorDensity: 1.1...1.3,
        startHexagons: 1...3
    ),
    MetaLevel(
        dificulty: 6,
        sizes: (width: 7...8, height: 7...8),
        hexagonDensity: 0.6...0.6,
        colors: 4...5,
        colorDensity: 1.1...1.3,
        startHexagons: 1...3
    ),
    MetaLevel(
        dificulty: 7,
        sizes: (width: 7...8, height: 7...8),
        hexagonDensity: 0.7...0.8,
        colors: 4...6,
        colorDensity: 1.1...1.3,
        startHexagons: 1...3
    ),
    MetaLevel(
        dificulty: 8,
        sizes: (width: 8...9, height: 8...9),
        hexagonDensity: 0.7...0.8,
        colors: 4...6,
        colorDensity: 1.1...1.3,
        startHexagons: 1...4
    ),
    MetaLevel(
        dificulty: 9,
        sizes: (width: 12...15, height: 12...15),
        hexagonDensity: 0.4...0.6,
        colors: 4...6,
        colorDensity: 1.1...1.3,
        startHexagons: 1...4
    ),
]

class LevelGenerator {
    static var rand = GKLinearCongruentialRandomSource.init(seed: 0)
    static func create(seed: UInt64, dificulty: Int) -> HexagonLevel {
        self.rand = GKLinearCongruentialRandomSource.init(seed: seed)
        
        let meta = metas[dificulty]
        
        //let startIndecies = self.rand.nextInt(upperBound: max(1, dificulty - 2)) + 1
        let gridWidth = rand.nextInt(upperBound: meta.sizes.width.upperBound - meta.sizes.width.lowerBound + 1) + meta.sizes.width.lowerBound
        let gridHeight = rand.nextInt(upperBound: meta.sizes.height.upperBound - meta.sizes.height.lowerBound + 1) + meta.sizes.height.lowerBound
        let hexagonDensity = Double(rand.nextUniform()) * (meta.hexagonDensity.upperBound - meta.hexagonDensity.lowerBound) + meta.hexagonDensity.lowerBound
        let totalHexagons = Int(Double(gridWidth * gridHeight) * hexagonDensity)
        let connectionDensity = Double(rand.nextUniform()) * (meta.colorDensity.upperBound - meta.colorDensity.lowerBound) + meta.colorDensity.lowerBound
        let description = LevelDescription(
            size: (width: gridWidth, height: gridHeight),
            totalHexagons: totalHexagons,
            colors: rand.nextInt(upperBound: meta.colors.upperBound - meta.colors.lowerBound + 1) + meta.colors.lowerBound,
            connections: Int(connectionDensity * Double(totalHexagons)),
            startHexagons: rand.nextInt(upperBound: meta.startHexagons.upperBound - meta.startHexagons.lowerBound + 1) + meta.startHexagons.lowerBound
        )

        // generates the grid
        var level = generateLevelHexagons(description: description)
        
        populateGridWithConnections(level: level, description: description)
        // level = self.scrambleLevel(level: level)
        
        for hexagon in level.hexagons.values {
            hexagon.draw(recurse: false)
        }
        return level
    }
    
    static func generateLevelHexagons(description: LevelDescription) -> HexagonLevel {
        var hexagons = [HexagonIndex: Hexagon]()
        
        var availableHexagonIndecies: [HexagonIndex] = []
        
        for _ in 0..<description.startHexagons {
            availableHexagonIndecies.append(HexagonIndex(top: rand.nextInt(upperBound: description.size.height), left: rand.nextInt(upperBound: description.size.width)))
        }
        
        while hexagons.count < description.totalHexagons {
            let newHexagonIndex = availableHexagonIndecies.remove(at: self.rand.nextInt(upperBound: availableHexagonIndecies.count))
            
            // invalid index
            if newHexagonIndex.left > description.size.width || newHexagonIndex.top > description.size.height || newHexagonIndex.top < 0 || newHexagonIndex.left < 0 {
                continue
            }
            // already exists
            if (hexagons.keys.contains(newHexagonIndex)) {
                continue
            }
            
            // add element
            let newHexagon = Hexagon(isMovable: self.rand.nextInt(upperBound: 20) < 17, gridIndex: newHexagonIndex)
            hexagons[newHexagonIndex] = newHexagon
            
            // add neighbors to search space if not already added
            for direction in HexagonDirection.allCases {
                let newNeighbor = newHexagon.gridIndex.getNeighborIndex(direction: direction)
                if !availableHexagonIndecies.contains(newNeighbor) {
                    availableHexagonIndecies.append(newNeighbor)
                }
            }
            
        }
        
        var minTop = Int.max, maxTop = Int.min, minLeft = Int.max, maxLeft = Int.min

        for hexagonIndex in hexagons.keys {
            minTop = min(hexagonIndex.top, minTop)
            maxTop = max(hexagonIndex.top, maxTop)
            minLeft = min(hexagonIndex.left, minLeft)
            maxLeft = max(hexagonIndex.left, maxLeft)
        }

        var simplifiedHexagons = [HexagonIndex: Hexagon]()
        for (hexagonIndex, hexagon) in hexagons {
            let newIndex = HexagonIndex(top: hexagonIndex.top - minTop, left: hexagonIndex.left - minLeft)
            hexagon.gridIndex = newIndex
            hexagon.resetGridPosition()
            simplifiedHexagons[newIndex] = hexagon
        }

        for hexagon in simplifiedHexagons.values {
            hexagon.sides.forEach({side in
                side.bindNeighbors(parentHexagon: hexagon, otherHexagon: simplifiedHexagons[hexagon.gridIndex.getNeighborIndex(direction: side.direction)])
            })
        }
        return HexagonLevel(hexagons: simplifiedHexagons, gridSize: CGSize(width: maxLeft - minLeft + 1, height: maxTop - minTop + 1))
        //return HexagonLevel(hexagons: hexagons, gridSize: CGSize(width: description.size.width, height: description.size.height))
    }
    
    static func populateGridWithConnections(level: HexagonLevel, description: LevelDescription) {
        var colorConnectionsCreated = 0
        while colorConnectionsCreated < description.connections {
            if let hexagon = level.getHexagon(index: HexagonIndex(top: self.rand.nextInt(upperBound: Int(level.gridSize.height)), left: self.rand.nextInt(upperBound: Int(level.gridSize.width)))) {
                let direction = HexagonDirection(rawValue: self.rand.nextInt(upperBound: 6)) ?? HexagonDirection.north
                if hexagon.getSide(direction: direction).createConnection(connectionColor: HexagonSideColor(rawValue: self.rand.nextInt(upperBound: description.colors) + 1) ?? HexagonSideColor.blue) {
                    colorConnectionsCreated += 1
                }
            }
            
        }
    }
    // scrambling doesn't use the seed to make it more interesting
    static func scrambleLevel(level: HexagonLevel) -> HexagonLevel {
        // get hexagons in order of index
        for hexagon in level.hexagons.values.sorted(by: {(hexagon1, hexagon2) in hexagon1.gridIndex < hexagon2.gridIndex}) {
            if !hexagon.isMovable {
                continue
            }
            if let (newHexagonIndex, newHexagon) = level.hexagons.randomElement() {
                if newHexagonIndex == hexagon.gridIndex {
                    continue
                }
                if !newHexagon.isMovable {
                    continue
                }
                hexagon.switchColors(hexagon: newHexagon, redraw: false)
            }
        }
        
        return level
    }
}
