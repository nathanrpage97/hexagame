//
//  GKRandomSource.swift
//  hexagame
//
//  Created by Nathan on 7/17/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import GameplayKit

// MARK: - Add the ability to use bounds for int and uniform
extension GKRandomSource {
    func nextInt(bounds: ClosedRange<Int>) -> Int {
        return self.nextInt(upperBound: bounds.upperBound - bounds.lowerBound + 1) + bounds.lowerBound
    }

    func nextUniform(bounds: ClosedRange<Float>) -> Float {
        return (self.nextUniform() * (bounds.upperBound - bounds.lowerBound)) + bounds.lowerBound
    }
}
