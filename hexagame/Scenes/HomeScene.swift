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
    var dificulty: Int = 1
    var level: UInt64 = 1
    let tap = UITapGestureRecognizer()
    let swipeUp = UISwipeGestureRecognizer()
    let swipeDown = UISwipeGestureRecognizer()
    var dificultyText: SKLabelNode
    var dificultyNumber: SKLabelNode
    var difficultyRegion = SKSpriteNode()
    var levelText: SKLabelNode
    var levelNumber: SKLabelNode
    let levelIncrement = SKSpriteNode()
    let levelDecrement = SKSpriteNode()
    var levelRegion = SKSpriteNode()
    let playButton = SKSpriteNode()
    

    override init(size: CGSize) {
        dificultyText = SKLabelNode(text: "Dificulty")
        dificultyNumber = SKLabelNode(text: String(dificulty))
        levelText = SKLabelNode(text: "Level")
        levelNumber = SKLabelNode(text: String(level))
        super.init(size: size)

        self.backgroundColor = UIColor(red: 223/255.0, green: 227/255.0, blue: 224/255.0, alpha: 1)

        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        difficultyRegion.size = CGSize(width: 48*vw, height: 90*vh)
        difficultyRegion.position = CGPoint(x: -25*vw, y: 0)
        self.addChild(difficultyRegion)
        dificultyText.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        dificultyText.fontSize = 4 * vh
        dificultyText.fontName = "AvenirNext-Regular"
        dificultyText.position = CGPoint(x: 0, y: 20*vh)
        dificultyText.verticalAlignmentMode = .top
        difficultyRegion.addChild(dificultyText)

        dificultyNumber.verticalAlignmentMode = .center
        dificultyNumber.fontSize = 20 * vh
        dificultyNumber.position = CGPoint(x: 0, y: 0)
        dificultyNumber.fontColor = .black
        dificultyNumber.fontName = "AvenirNext-UltraLight"
        difficultyRegion.addChild(dificultyNumber)

        levelRegion.size = CGSize(width: 48*vw, height: 90*vh)
        levelRegion.position = CGPoint(x: 25*vw, y: 0)
        self.addChild(levelRegion)
        levelText.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        levelText.fontSize = 4 * vh
        levelText.fontName = "AvenirNext-Regular"
        levelText.position = CGPoint(x: 0, y: 20*vh)
        levelText.verticalAlignmentMode = .top
        levelRegion.addChild(levelText)

        levelNumber.verticalAlignmentMode = .center
        levelNumber.fontSize = 20 * vh
        levelNumber.position = CGPoint(x: 0, y: 0)
        levelNumber.fontColor = .black
        levelNumber.fontName = "AvenirNext-UltraLight"
        levelRegion.addChild(levelNumber)

        playButton.position = CGPoint(x: 0 * vw, y: -37.5*vh)
        playButton.size = CGSize(width: 40*vh, height: 20*vh)
        self.addChild(playButton)

        let playButtonText = SKLabelNode(text: "Play")
        playButtonText.fontColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1)
        playButtonText.fontSize = 4 * vh
        playButtonText.fontName = "AvenirNext-Regular"
        playButtonText.verticalAlignmentMode = .center
        playButton.addChild(playButtonText)

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
        print("moved to home")
        // add tap gesture handler
        tap.addTarget(self, action: #selector(tapAction(_:)))
        tap.numberOfTouchesRequired = 1
        view.addGestureRecognizer(tap)

        // add swipe gesture handler
        swipeUp.addTarget(self, action: #selector(swipeUpAction(_:)))
        swipeUp.direction = .up
        view.addGestureRecognizer(swipeUp)
        swipeDown.addTarget(self, action: #selector(swipeDownAction(_:)))
        swipeDown.direction = .down
        view.addGestureRecognizer(swipeDown)
    }
    
    override func willMove(from view: SKView) {
        view.removeGestureRecognizer(swipeUp)
        view.removeGestureRecognizer(swipeDown)
    }

    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }

    @IBAction func tapAction(_ recognizer: UIPanGestureRecognizer) {
        let touchLocation = self.convertPoint(fromView: recognizer.location(in: self.view))
        let touchedNodes = self.nodes(at: touchLocation)
        for node in touchedNodes.reversed() where node == self.playButton {
            startGame()
            return
        }
    }

    @IBAction func swipeUpAction(_ recognizer: UISwipeGestureRecognizer) {
        // ignore left and right swipes
        let touchLocation = self.convertPoint(fromView: recognizer.location(in: self.view))
        let touchedNodes = self.nodes(at: touchLocation)
        for node in touchedNodes.reversed() {
            if node == self.difficultyRegion {
                if self.dificulty < 9 {
                    self.dificulty += 1
                }
                self.dificultyNumber.text = String(self.dificulty)
                break
            } else if node == self.levelRegion {
                if self.level < UInt64.max {
                    self.level += 1
                }
                self.levelNumber.text = String(self.level)
                break
            }
        }
    }
    
    
    @IBAction func swipeDownAction(_ recognizer: UISwipeGestureRecognizer) {
        // ignore left and right swipes
        let touchLocation = self.convertPoint(fromView: recognizer.location(in: self.view))
        let touchedNodes = self.nodes(at: touchLocation)
        for node in touchedNodes.reversed() {
            if node == self.difficultyRegion {
                if self.dificulty > 1 {
                    self.dificulty -= 1
                }
                self.dificultyNumber.text = String(self.dificulty)
                break
            } else if node == self.levelRegion {
                if  self.level > 1 {
                    self.level -= 1
                }
                self.levelNumber.text = String(self.level)
                break
            }
        }
    }

    func updateScene() {

    }

    func startGame() {
        let reveal = SKTransition.fade(with: self.backgroundColor, duration: 0.5)
        let scene = LoadingScene(size: self.size, dificulty: self.dificulty, level: self.level)
        self.view?.presentScene(scene, transition: reveal)
    }
}
