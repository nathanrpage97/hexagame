//
//  LevelGenerator.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//
import GameplayKit


/// Creates a level
class LevelGenerator {
    
    ///
    static var rng = GKLinearCongruentialRandomSource.init(seed: 0)

    static func create(seed: UInt64, dificulty: Int) -> HexagonLevel {
        self.rng = GKLinearCongruentialRandomSource.init(seed: seed)
        
        let meta = LevelConstants.metas[dificulty]
        let description = LevelDescription(rng: self.rng, meta: meta)

        // generates the grid
        let level = generateLevelHexagons(description: description)
        
        populateGridWithConnections(level: level, description: description)
        scrambleLevel(level: level)
        
        for hexagon in level.hexagons.values {
            hexagon.draw(recurse: false)
        }
        return level
    }
    
    static func generateLevelHexagons(description: LevelDescription) -> HexagonLevel {
        var hexagons = [HexagonIndex: Hexagon]()
        
        var availableHexagonIndecies: [HexagonIndex] = []
        
        for _ in 0..<description.startHexagons {
            availableHexagonIndecies.append(HexagonIndex(row: rng.nextInt(upperBound: description.size.height), col: rng.nextInt(upperBound: description.size.width)))
        }
        
        while hexagons.count < description.totalHexagons {
            let newHexagonIndex = availableHexagonIndecies.remove(at: self.rng.nextInt(upperBound: availableHexagonIndecies.count))
            
            // invalid index
            if newHexagonIndex.col > description.size.width || newHexagonIndex.row > description.size.height || newHexagonIndex.row < 0 || newHexagonIndex.col < 0 {
                continue
            }
            // already exists
            if (hexagons.keys.contains(newHexagonIndex)) {
                continue
            }
            
            // add element
            let newHexagon = Hexagon(isMovable: self.rng.nextInt(upperBound: 20) < 17, gridIndex: newHexagonIndex)
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
            minTop = min(hexagonIndex.row, minTop)
            maxTop = max(hexagonIndex.row, maxTop)
            minLeft = min(hexagonIndex.col, minLeft)
            maxLeft = max(hexagonIndex.col, maxLeft)
        }
        print(minTop, maxTop, minLeft, maxLeft)

        var simplifiedHexagons = [HexagonIndex: Hexagon]()
        for (hexagonIndex, hexagon) in hexagons {
            let newIndex = HexagonIndex(row: hexagonIndex.row - minTop, col: hexagonIndex.col - minLeft)
            hexagon.gridIndex = newIndex
            hexagon.resetGridPosition()
            simplifiedHexagons[newIndex] = hexagon
        }

        for hexagon in simplifiedHexagons.values {
            hexagon.sides.forEach({side in
                side.bindNeighbors(parentHexagon: hexagon, otherHexagon: simplifiedHexagons[hexagon.gridIndex.getNeighborIndex(direction: side.direction)])
            })
        }
        
        
        return HexagonLevel(hexagons: simplifiedHexagons, gridSize: (cols: maxLeft - minLeft + 1, rows: maxTop - minTop + 1))
    }
    
    static func populateGridWithConnections(level: HexagonLevel, description: LevelDescription) {
        var colorConnectionsCreated = 0
        let keys = level.hexagons.keys.sorted()
        while colorConnectionsCreated < description.connections {
            guard let hexagon = level.getHexagon(index: keys[self.rng.nextInt(upperBound: keys.count)]) else {
                continue
            }
            let direction = HexagonDirection(rawValue: self.rng.nextInt(upperBound: 6)) ?? HexagonDirection.north
            if hexagon.getSide(direction: direction).createConnection(connectionColor: HexagonSideColor(rawValue: self.rng.nextInt(upperBound: description.colors) + 1) ?? HexagonSideColor.blue) {
                colorConnectionsCreated += 1
            }
            
        }
    }
    // scrambling doesn't use the seed to make it more interesting
    static func scrambleLevel(level: HexagonLevel) {
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
    }
}
