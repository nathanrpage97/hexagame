//
//  GameScene.swift
//  hexagame
//
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {

    private var draggingHexagon: Hexagon?

    var hexagonLevel: HexagonLevel
    let pan = UIPanGestureRecognizer()
    let pinch = UIPinchGestureRecognizer()

    init(size: CGSize, dificulty: Int, seed: UInt64) {

        self.hexagonLevel = LevelGenerator.create(seed: seed, dificulty: dificulty)

        super.init(size: size)
        self.backgroundColor = UIColor.init(red: 223/255.0, green: 227/255.0, blue: 224/255.0, alpha: 1)
        self.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        let cameraNode = SKCameraNode()
        cameraNode.position = CGPoint(x: 0, y: 0)
        self.addChild(cameraNode)
        self.camera = cameraNode

        self.addChild(hexagonLevel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func didMove(to view: SKView) {
        // add pan gesture handler
        pan.addTarget(self, action: #selector(panAction(_:)))
        self.view?.addGestureRecognizer(pan)
        pan.maximumNumberOfTouches = 1

        // add pinch gesture handler
        pinch.addTarget(self, action: #selector(pinchAction(_:)))
        self.view?.addGestureRecognizer(pinch)

        // constrain the camera
        setCameraConstraints()
    }

    func setCameraConstraints() {
        // require camera and hexagon level exist to create constraints upon
        guard let camera = camera else {
            return
        }

        let hexagonLevelWidth = hexagonLevel.size.width
        var viewWidth = self.frame.size.width * camera.xScale * 0.8

        let hexagonLevelHeight = hexagonLevel.size.height
        var viewHeight = self.frame.size.height * camera.yScale * 0.8

        // lower bound the zoom
        if hexagonLevelWidth < viewWidth && hexagonLevelHeight < viewHeight {
            let newScale = max(
                hexagonLevelWidth / (0.8 * self.frame.size.width), hexagonLevelHeight / (0.8 * self.frame.size.height)
            )
            camera.xScale = newScale
            camera.yScale = newScale
            viewWidth = self.frame.size.width * camera.xScale * 0.8
            viewHeight = self.frame.size.height * camera.yScale * 0.8
        }

        // upper bound the zoom
        if hexagonLevelHeight / (camera.yScale * CGFloat(hexagonLevel.gridSize.rows)) > 300 ||
            hexagonLevelWidth / (camera.xScale * CGFloat(hexagonLevel.gridSize.cols)) > 400 {
            let newScale = max(
                hexagonLevelHeight / CGFloat(300 * hexagonLevel.gridSize.rows),
                hexagonLevelWidth / CGFloat(400 * hexagonLevel.gridSize.cols)
            )
            camera.xScale = newScale
            camera.yScale = newScale
            viewWidth = self.frame.size.width * camera.xScale * 0.8
            viewHeight = self.frame.size.height * camera.yScale * 0.8
        }

        let boundX = abs(viewWidth - hexagonLevelWidth)
        let boundY = abs(viewHeight - hexagonLevelHeight)

        let horizontalConstraint = SKConstraint.positionX(SKRange(lowerLimit: -boundX/2, upperLimit: boundX/2))
        let verticalConstraint = SKConstraint.positionY(SKRange(lowerLimit: -boundY/2, upperLimit: boundY/2))
        camera.constraints = [horizontalConstraint, verticalConstraint]
    }

    @objc func panAction(_ recognizer: UIPanGestureRecognizer) {
        // pan action required when level and camera exists
        guard let camera = self.camera else {
            return
        }
        // started to pan (check if dragging a node)
        if recognizer.state == .began {
            let touchLocation = self.convertPoint(fromView: recognizer.location(in: self.view))
            // check if dragging a node
            let location = self.convert(touchLocation, to: hexagonLevel)
            let touchedNodes = hexagonLevel.nodes(at: location)
            for node in touchedNodes.reversed() {
                if let hexagon = node as? Hexagon {
                    if !hexagon.isTouching(location: self.convert(touchLocation, to: hexagon)) {
                        continue
                    }
                    if !hexagon.isMovable {
                        continue
                    }
                    draggingHexagon = hexagon
                    hexagon.startDragging()
                    hexagonLevel.placeHolderHexagon.show(position: hexagon.gridPosition)
                    return
                }
            }
        } else if recognizer.state == .changed {

            let translation = recognizer.translation(in: recognizer.view)
            // clear translation
            recognizer.setTranslation(.zero, in: recognizer.view)

            if let hexagon = self.draggingHexagon {
                hexagon.position.x += translation.x * camera.xScale
                hexagon.position.y -= translation.y * camera.yScale
            } else {
                camera.position.x -= translation.x  * camera.xScale
                camera.position.y += translation.y  * camera.yScale
            }
        } else if recognizer.state == .ended || recognizer.state == .cancelled {
            guard let draggingHexagon = draggingHexagon else {
                return
            }

            let touchLocation = self.convertPoint(fromView: recognizer.location(in: recognizer.view))
            // check if dragging a node
            let location = self.convert(touchLocation, to: hexagonLevel)
            let touchedNodes = hexagonLevel.nodes(at: location)
            var found = false
            for node in touchedNodes.reversed() {
                if let hexagon = node as? Hexagon {
                    if hexagon != draggingHexagon &&
                        hexagon.isTouching(location: self.convert(touchLocation, to: hexagon)) {
                        hexagonLevel.switchHexagons(srcHexagon: draggingHexagon, destinationHexagon: hexagon)
                        found = true
                        break
                    }
                }
            }
            draggingHexagon.stopDragging()
            draggingHexagon.resetGridPosition()
            hexagonLevel.placeHolderHexagon.hide()
            if found && hexagonLevel.isFinished {
                run(SKAction.sequence([
                    SKAction.run { [weak self] in
                        // 5
                        print("Go back to home scene")
                        guard let `self` = self else { return }
                        let reveal = SKTransition.fade(with: self.backgroundColor, duration: 1)
                        let scene = HomeScene(size: self.size)
                        self.view?.presentScene(scene, transition: reveal)
                    }
                ]))
            }

            self.draggingHexagon = nil
        }
    }

    @objc func pinchAction(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .changed {
            guard let camera = self.camera else {
                return
            }
            // get center point on pinch action
            let locationInView = recognizer.location(in: recognizer.view)
            let location = self.convertPoint(fromView: locationInView)

            camera.xScale *= 1 / recognizer.scale
            camera.yScale *= 1 / recognizer.scale

            // get center point after pinch
            let locationAfterScale = self.convertPoint(fromView: locationInView)

            // adjust to cancel out
            let locationDelta = CGPoint(x: location.x - locationAfterScale.x, y: location.y - locationAfterScale.y)
            camera.position.x += locationDelta.x
            camera.position.y += locationDelta.y

            recognizer.scale = 1.0
            setCameraConstraints()
        }
    }
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
