//
//  HexagonPlaceHolder.swift
//  hexagame
//
//  Created by Nathan on 7/11/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit
/// A Simple Sprite that is used to show where the dragged hexagon used to be placed
class HexagonPlaceHolder: SKSpriteNode {
    /// Create the hexagon placeholder
    init() {
        super.init(texture: SKTexture(imageNamed: "hexagonBase"), color: UIColor.clear, size: Hexagon.hexagonSize)
        self.zPosition = 0
        self.isHidden = true
        self.alpha = 0.6
        self.zPosition = -1
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Show the hexagon at a specific location
    ///
    /// - Parameter position: The position to show the placeholder
    func show(position: CGPoint) {
        self.position = position
        self.isHidden = false
    }

    /// Hide the hexagon placeholder
    func hide() {
        self.isHidden = true
    }
}
