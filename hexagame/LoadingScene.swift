//
//  GameScene.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit
import GameplayKit

class LoadingScene: SKScene {
    var dificulty: Int
    var level: UInt64
    init(size: CGSize, dificulty: Int, level: UInt64) {
        self.dificulty = dificulty
        self.level = level
        super.init(size: size)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {

        self.backgroundColor = UIColor(red: 223/255.0, green: 227/255.0, blue: 224/255.0, alpha: 1)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let test = SKSpriteNode(color: .blue, size: CGSize(width: 100, height: 100))
        test.zPosition = 100
        test.position = .zero
        self.addChild(test)

        DispatchQueue.global(qos: .utility).asyncAfter(deadline: .now() + .seconds(1)) { [weak self] in
            print("Hello")
            guard let `self` = self else { return }
            let reveal = SKTransition.fade(with: self.backgroundColor, duration: 0.5)
            let scene = GameScene(size: self.size, dificulty: self.dificulty, seed: self.level)

            DispatchQueue.main.async {
                self.view?.presentScene(scene, transition: reveal)
            }
        }
    }
}
