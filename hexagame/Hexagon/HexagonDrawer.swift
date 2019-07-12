//
//  HexagonDrawer.swift
//  hexagame
//  Used to draw the hexagons
//  Created by Nathan on 7/7/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

/// Create the image representation of a hexagon
class HexagonDrawer {
    static let scale: CGFloat = 3.0
    static let size = CGSize(width: 120, height: 104)
    
    static let movableBackground = HexagonDrawer.createBackground(movable: true)
    static let immovableBackground = HexagonDrawer.createBackground(movable: false)
    
    static let movableOutline = HexagonDrawer.createOutline(movable: true)
    static let immovableOutline = HexagonDrawer.createOutline(movable: false)
    
    static func draw(hexagon: Hexagon) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        let trianglePattern = self.createTrianglePattern(hexagon: hexagon)
        let connections = self.createSideConnections(hexagon: hexagon)
        if hexagon.isMovable {
            ctx.draw(self.movableBackground, in: CGRect(origin: .zero, size: self.size))
            ctx.draw(trianglePattern, in: CGRect(origin: .zero, size: self.size))
            ctx.draw(self.movableOutline, in: CGRect(origin: .zero, size: self.size))
            ctx.draw(connections, in: CGRect(origin: .zero, size: self.size))
            
        } else {
            ctx.draw(self.movableBackground, in: CGRect(origin: .zero, size: self.size))
            ctx.draw(trianglePattern, in: CGRect(origin: .zero, size: self.size))
            ctx.draw(self.movableOutline, in: CGRect(origin: .zero, size: self.size))
            ctx.draw(connections, in: CGRect(origin: .zero, size: self.size))
        }
        
        UIGraphicsEndImageContext()
        let image = ctx.makeImage()!
        return image
    }
    
    /// Draws the background of the hexagon
    ///
    /// - Parameter movable: is the hexagon movable
    /// - Returns: Image of the background of the hexagon
    static func createBackground(movable: Bool) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        // path to create hexagon
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 103)) // slightly inset so background doesn't bleed into outline
        path.addLine(to: CGPoint(x: 1, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 1))
        path.addLine(to: CGPoint(x: 90, y: 1))
        path.addLine(to: CGPoint(x: 119, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 103))
        path.closeSubpath()
        
        ctx.addPath(path)
        
        // based on if movable use different border color
        if movable {
            ctx.setFillColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) // light gray
        } else {
            ctx.setFillColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1) // dark gray
        }
        ctx.fillPath()
        
        // create the image
        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// Draws the outline of the hexagon.This includes the outershell, dividers, and the inner circle
    ///
    /// - Parameter movable: is the hexagon movable
    /// - Returns: outline image of a hexagon
    static func createOutline(movable: Bool) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        // set the 3 dividing lines to create the six triangle
        var path = CGMutablePath()
        path.move(to: CGPoint(x: 32, y: 4))
        path.addLine(to: CGPoint(x: 88, y: 100))
        
        path.move(to: CGPoint(x: 88, y: 4))
        path.addLine(to: CGPoint(x: 32, y: 100))
        
        path.move(to: CGPoint(x: 4, y: 52))
        path.addLine(to: CGPoint(x: 116, y: 52))
        path.closeSubpath()
        
        // draw the dividers
        ctx.setLineWidth(CGFloat(4)) // TODO: Determine if to switch to 2px for more distinction between hexagons
        ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        ctx.setLineCap(.round)
        ctx.addPath(path)
        ctx.strokePath()
        
        // movable hexagons have inner circle
        if movable {
            ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
            ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
            ctx.strokeEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
        }
        
        // draw the outer hexagon line
        path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 104))
        path.addLine(to: CGPoint(x: 0, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: 120, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 104))
        path.closeSubpath()
        ctx.addPath(path)
        ctx.clip() // used so that the hexagon
        ctx.addPath(path)
        ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        ctx.setLineWidth(CGFloat(8))
        ctx.drawPath(using: .stroke)
        
        
        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
    
    
    /// Create the triangle pattern of the hexagon without accounting if it is connected
    ///
    /// - Parameter hexagon: hexagon to create traingle pattern
    /// - Returns: triangle pattern of hexagon
    static func createTrianglePattern(hexagon: Hexagon) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        // flip vertically so image correctly renders triangle pattern in correct direction
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: self.size.height)
        ctx.concatenate(flipVertical)
        
        // start with north (as side iterator starts with north)
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: -CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
        
        // go through each side
        for side in hexagon.sides {
            if side.isConnectable { // skip sides that arent connectable (.base color)
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 60, y: 52))
                path.addLine(to: CGPoint(x: 88, y: 2))
                path.addLine(to: CGPoint(x: 116, y: 52))
                path.closeSubpath()
                ctx.setFillColor(HexagonSideColor.uiColor(color: side.connectionColor).cgColor)
                ctx.addPath(path)
                ctx.fillPath()
            }
            // rotate to next triangle position
            ctx.translateBy(x: 60, y: 52)
            ctx.rotate(by: CGFloat.pi/3)
            ctx.translateBy(x: -60, y: -52)
        }
        
        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
    

    
    /// Create the connections that overlay each
    ///
    /// - Parameter hexagon: hexxagon to create side connections
    /// - Returns: image of side connections
    static func createSideConnections(hexagon: Hexagon) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        // if dragging no connections should be made
        if hexagon.isDragging {
            let image = ctx.makeImage()!
            UIGraphicsEndImageContext()
            return image
        }
        
        // flip vertically so image correctly renders triangle pattern in correct direction
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: self.size.height)
        ctx.concatenate(flipVertical)
        
        // start with north (as side iterator starts with north)
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: -CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
        
        // draw the connecting areas
        for side in hexagon.sides {
            if side.isConnected {
                // opposite sides are what need to align correctly. Seems to be some issue with rotation accuaracy?
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
        
        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
}

