//
//  GameScene.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit
import GameplayKit

extension SKScene {
    var vw: CGFloat {
        return self.size.width / 100.0
    }
    var vh: CGFloat {
        return self.size.height / 100.0
    }
    var vmin: CGFloat {
        return min(vw, vh)
    }
    var vmax: CGFloat {
        return max(vw, vh)
    }
}

class HomeScene: SKScene {
    var dificulty = Int.random(in: 3...4)
    var level: UInt64 = UInt64.random(in: 1...1234)
    let tap = UITapGestureRecognizer()
    var dificultyText: SKLabelNode
    var dificultyNumber: SKLabelNode
    var levelText: SKLabelNode
    var levelNumber: SKLabelNode

    let playButton: SKLabelNode

    override init(size: CGSize) {
        dificultyText = SKLabelNode(text: "Dificulty")
        dificultyNumber = SKLabelNode(text: String(dificulty))
        levelText = SKLabelNode(text: "Level")
        levelNumber = SKLabelNode(text: String(level))

        playButton = SKLabelNode(text: "Play")
        super.init(size: size)

        self.backgroundColor = UIColor(red: 223/255.0, green: 227/255.0, blue: 224/255.0, alpha: 1)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        dificultyText.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        dificultyText.fontSize = 4 * vh
        dificultyText.fontName = "AvenirNext-Regular"
        dificultyText.position = CGPoint(x: -25 * vw, y: 20*vh)
        dificultyText.verticalAlignmentMode = .top
        self.addChild(dificultyText)

        dificultyNumber.verticalAlignmentMode = .center
        dificultyNumber.fontSize = 20 * vh
        dificultyNumber.position = CGPoint(x: -25 * vw, y: 0)
        dificultyNumber.fontColor = .black
        dificultyNumber.fontName = "AvenirNext-UltraLight"
        self.addChild(dificultyNumber)

        levelText.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        levelText.fontSize = 4 * vh
        levelText.fontName = "AvenirNext-Regular"
        levelText.position = CGPoint(x: 25 * vw, y: 20*vh)
        levelText.verticalAlignmentMode = .top
        self.addChild(levelText)

        levelNumber.verticalAlignmentMode = .center
        levelNumber.fontSize = 20 * vh
        levelNumber.position = CGPoint(x: 25 * vw, y: 0)
        levelNumber.fontColor = .black
        levelNumber.fontName = "AvenirNext-UltraLight"
        self.addChild(levelNumber)

        playButton.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        playButton.fontSize = 4 * vh
        playButton.fontName = "AvenirNext-Regular"
        playButton.position = CGPoint(x: 0 * vw, y: -37.5*vh)
        playButton.verticalAlignmentMode = .center
        self.addChild(playButton)

        let divider = SKSpriteNode(
            color: UIColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1), size: CGSize(width: 0.1*vw + 1, height: 50*vh)
        )
        divider.position = .zero
        self.addChild(divider)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func didMove(to view: SKView) {

        // add tap gesture handler
        tap.addTarget(self, action: #selector(tapAction(_:)))
        tap.numberOfTouchesRequired = 1
        self.view?.addGestureRecognizer(tap)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    @IBAction func tapAction(_ recognizer: UIPanGestureRecognizer) {
        print(recognizer.location(in: self.view))

        startGame()

    }

    func updateScene() {

    }

    func startGame() {
        let reveal = SKTransition.fade(with: self.backgroundColor, duration: 0.5)
        let scene = LoadingScene(size: self.size, dificulty: self.dificulty, level: self.level)
        self.view?.presentScene(scene, transition: reveal)
    }
}
