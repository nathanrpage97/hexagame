//
//  HexagonDrawer.swift
//  hexagame
//  Used to draw the hexagons
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

func createHexagonBackground(movable: Bool) -> CGImage? {
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 104), false, 3.0)
    guard let ctx = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    /*  Outer black hexagon   */
    let path = CGMutablePath();
    path.move(to: CGPoint(x: 30, y: 103))
    path.addLine(to: CGPoint(x: 1, y: 52))
    path.addLine(to: CGPoint(x: 30, y: 1))
    path.addLine(to: CGPoint(x: 90, y: 1))
    path.addLine(to: CGPoint(x: 119, y: 52))
    path.addLine(to: CGPoint(x: 90, y: 103))
    path.closeSubpath()
    
    ctx.addPath(path)

    if movable {
        ctx.setFillColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    } else {
        ctx.setFillColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        
    }
    ctx.fillPath()
    UIGraphicsEndImageContext()
    let image = ctx.makeImage()
    return image
}

func createDividers(isMovable: Bool) -> CGImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 104), false, 3.0)
    guard let ctx = UIGraphicsGetCurrentContext() else {
        return nil
    }
    /*  Draw the 3 seperator lines  */
    var path = CGMutablePath();
    path.move(to: CGPoint(x: 32, y: 4))
    path.addLine(to: CGPoint(x: 88, y: 100))
    
    path.move(to: CGPoint(x: 88, y: 4))
    path.addLine(to: CGPoint(x: 32, y: 100))
    
    path.move(to: CGPoint(x: 4, y: 52))
    path.addLine(to: CGPoint(x: 116, y: 52))
    
    path.closeSubpath()
    ctx.setLineWidth(CGFloat(4)) // TODO: Determine if to switch to 
    ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    
    ctx.setLineCap(.round)
    ctx.addPath(path)
    ctx.strokePath()
    
    
    if isMovable {
        ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
        ctx.strokeEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
    }
    
    
    path = CGMutablePath();
    path.move(to: CGPoint(x: 30, y: 104))
    path.addLine(to: CGPoint(x: 0, y: 52))
    path.addLine(to: CGPoint(x: 30, y: 0))
    path.addLine(to: CGPoint(x: 90, y: 0))
    path.addLine(to: CGPoint(x: 120, y: 52))
    path.addLine(to: CGPoint(x: 90, y: 104))
    path.closeSubpath()
    ctx.addPath(path)
    ctx.clip()
    
    ctx.addPath(path)
    ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
    ctx.setLineWidth(CGFloat(8))
    ctx.drawPath(using: .stroke)
    
    UIGraphicsEndImageContext()
    let image = ctx.makeImage()
    return image
}

func createColorConnections(hexagon: Hexagon) -> CGImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 104), false, 3.0)
    // UIGraphicsBeginImageContext(CGSize(width: 120, height: 104))
    guard let ctx = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 104)
    ctx.concatenate(flipVertical) // flip by y
    
    // start with north
    ctx.translateBy(x: 60, y: 52)
    ctx.rotate(by: -CGFloat.pi/3)
    ctx.translateBy(x: -60, y: -52)
    
    for side in hexagon.sides {
        if side.isConnectable {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 60, y: 52))
            path.addLine(to: CGPoint(x: 88, y: 2))
            path.addLine(to: CGPoint(x: 116, y: 52))
            path.closeSubpath()
            ctx.setFillColor(HexagonSideColor.uiColor(color: side.connectionColor).cgColor)
            ctx.addPath(path)
            ctx.fillPath()
        }
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
    }
    UIGraphicsEndImageContext()
    let image = ctx.makeImage()
    return image
}


func createConnections(hexagon: Hexagon) -> CGImage? {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 104), false, 3.0)
    // UIGraphicsBeginImageContext(CGSize(width: 120, height: 104))
    guard let ctx = UIGraphicsGetCurrentContext() else {
        return nil
    }
    
    let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: 104)
    ctx.concatenate(flipVertical) // flip by y
    
    // start with north
    ctx.translateBy(x: 60, y: 52)
    ctx.rotate(by: -CGFloat.pi/3)
    ctx.translateBy(x: -60, y: -52)
    if hexagon.isDragging {
        let image = ctx.makeImage()
        return image
    }
    for side in hexagon.sides {
        if side.isConnected {
            if side.direction == .northEast || side.direction == .southWest {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 88, y: 8))
                path.addLine(to: CGPoint(x: 90.4, y: 4))
                path.addLine(to: CGPoint(x: 93.4, y: 4))
                path.addLine(to: CGPoint(x: 118.862, y: 45.403))
                path.addLine(to: CGPoint(x: 116.2, y: 50))
                path.addLine(to: CGPoint(x: 112.019, y: 50))
                path.closeSubpath()
                ctx.setFillColor(HexagonSideColor.uiColor(color: side.connectionColor).cgColor)
                ctx.addPath(path)
                ctx.fillPath()
            } else if side.direction == .southEast || side.direction == .northWest {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 88.759, y: 6.25))
                //path.addLine(to: CGPoint(x: 92.438, y: 4))
                path.addLine(to: CGPoint(x: 90.0, y: 4.2))
                path.addLine(to: CGPoint(x: 92.9, y: 4.2))
                //path.addLine(to: CGPoint(x: 117.641, y: 47.7))
                path.addLine(to: CGPoint(x: 117.862, y: 47.593))
                path.addLine(to: CGPoint(x: 116.7, y: 49.8))
                path.addLine(to: CGPoint(x: 113.019, y: 49.8))
                path.closeSubpath()
                ctx.setFillColor(HexagonSideColor.uiColor(color: side.connectionColor).cgColor)
                ctx.addPath(path)
                ctx.fillPath()
            } else if side.direction == .north || side.direction == .south {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 88.689, y: 5.8))
                //path.addLine(to: CGPoint(x: 92.438, y: 4))
                path.addLine(to: CGPoint(x: 89.83, y: 3.8))
                path.addLine(to: CGPoint(x: 92.4, y: 3.8))
                //path.addLine(to: CGPoint(x: 117.641, y: 47.7))
                path.addLine(to: CGPoint(x: 118.262, y: 47.693))
                path.addLine(to: CGPoint(x: 116.7, y: 50.2))
                path.addLine(to: CGPoint(x: 114.019, y: 50.2))
                path.closeSubpath()
                ctx.setFillColor(HexagonSideColor.uiColor(color: side.connectionColor).cgColor)
                ctx.addPath(path)
                ctx.fillPath()
            }
        }
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
    }
    UIGraphicsEndImageContext()
    let image = ctx.makeImage()
    return image
}


let baseMovableHexagon = createHexagonBackground(movable: true)
let baseImmovableHexagon = createHexagonBackground(movable: false)

let movableDividers = createDividers(isMovable: true)
let immovableDividers = createDividers(isMovable: false)


func drawHexagon(hexagon: Hexagon) -> CGImage? {
    
    guard let baseMovableHexagon = baseMovableHexagon,
        let baseImmovableHexagon = baseImmovableHexagon,
        let movableDividers = movableDividers,
        let immovableDividers = immovableDividers else {
            return nil
    }
    
    guard let connections = createColorConnections(hexagon: hexagon) else {
        return nil
    }
    
    guard let connectors = createConnections(hexagon: hexagon) else {
        return nil
    }

    UIGraphicsBeginImageContextWithOptions(CGSize(width: 120, height: 104), false, 3.0)
    
    guard let ctx = UIGraphicsGetCurrentContext() else {
        return nil
    }
    if hexagon.isMovable {
        ctx.draw(baseMovableHexagon, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        ctx.draw(connections, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        ctx.draw(movableDividers, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        ctx.draw(connectors, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        
    } else {
        ctx.draw(baseImmovableHexagon, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        ctx.draw(connections, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        ctx.draw(immovableDividers, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
        ctx.draw(connectors, in: CGRect(origin: .zero, size: CGSize(width: 120, height: 104)))
    }
    
    UIGraphicsEndImageContext()
    let image = ctx.makeImage()
    return image
}


