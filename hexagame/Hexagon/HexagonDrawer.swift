//
//  HexagonDrawer.swift
//  HexagonGame
//
//  Created by Nathan on 9/24/19.
//  Copyright © 2019 Nathan. All rights reserved.
//

import SpriteKit

class HexagonDrawer {
    static let scale: CGFloat = 3.0
    static let size = Hexagon.outerSize

    static let lightGray = UIColor(red: 1, green: 1, blue: 1, alpha: 1).cgColor
    static let darkerGray = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1).cgColor
    static let darkGray = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1).cgColor

    /// Path of the hexagon
    static var hexagonPath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 104))
        path.addLine(to: CGPoint(x: 0, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: 120, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 104))
        path.closeSubpath()
        return path
    }

    /// Path of the hexagon inset to remove artifacts of light gray
    static var insetHexagonPath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 103))
        path.addLine(to: CGPoint(x: 1, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 1))
        path.addLine(to: CGPoint(x: 90, y: 1))
        path.addLine(to: CGPoint(x: 119, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 103))
        path.closeSubpath()
        return path
    }

    /// Outside edge of the triangle (only drawn if unconnectable or not connected)
    static var outsideEdgePath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: 120, y: 52))
        path.closeSubpath()
        return path
    }

    /// Path of divider between a connectable triangle and whatever its sibling is
    static var dividerPath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 60, y: 52))
        path.addLine(to: CGPoint(x: 120, y: 52))
        path.closeSubpath()
        return path
    }

    /// Path of the triangle (north east positioned, requires dividers to hide overlap)
    static var trianglePath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 60, y: 53))
        path.addLine(to: CGPoint(x: 91, y: -1.7))
        path.addLine(to: CGPoint(x: 120, y: 53))
        path.closeSubpath()
        return path
    }

    /// if the triangle is connected, these two lines create the crisp diamond shape between the connected hexagons
    static var triangleConnectedLinesPath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: 120, y: 0))
        path.move(to: CGPoint(x: 120, y: 52))
        path.addLine(to: CGPoint(x: 150, y: 0))
        path.closeSubpath()
        return path
    }

    /// when the triangle is connectable but not yet connected, this provides an indicator to make it more visually obvious
    static var triangleConnectableIndicatorPath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 108, y: 4))
        path.addLine(to: CGPoint(x: 90, y: 34.5))
        path.addLine(to: CGPoint(x: 120, y: 35))
        path.closeSubpath()
        return path
    }

    /// when the triangle is connectable but not yet connected, this provides an indicator to make it more visually obvious
    static var triangleConnectableClipPath: CGMutablePath {
        let path = CGMutablePath()
        path.move(to: CGPoint(x: 108, y: 4))
        path.addLine(to: CGPoint(x: 90, y: 34.5))
        path.addLine(to: CGPoint(x: 120, y: 35))
        path.closeSubpath()
        return path
    }

    /**
     Draw the full hexagon image
     - Parameter hexagon: Hexagon information used to draw the image
     - Returns: Image of the hexagon
     */
    static func draw(hexagon: Hexagon) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!

        // clip the image around the hexagon to remove overflow
        ctx.addPath(hexagonPath)
        ctx.clip()

        // draw the inner hexagon
        ctx.addPath(insetHexagonPath)
        ctx.setFillColor(hexagon.isMovable ? lightGray : darkGray)
        ctx.fillPath()

        // start with north (as side iterator starts with north, and triangle faces north-east)
        // the ctx must be rotated 60deg counter-clockwise
        rotateLeft(ctx)

        // draw the triangles of each side and the outside edge if not connected
        for triangle in hexagon.triangles {
            let triangleImage = drawTriangle(hexagon: hexagon, triangle: triangle)
            ctx.draw(triangleImage, in: CGRect(origin: .zero, size: size))

            // draw the outside edge
            if !triangle.isConnected || hexagon.isDragging || triangle.neighbor?.isDragging ?? false {
                ctx.addPath(outsideEdgePath)
                ctx.setLineWidth(6)
                ctx.setStrokeColor(darkGray)
                ctx.strokePath()
            }
            rotateRight(ctx)
        }

        // draw the dividers
        for triangle in hexagon.triangles {
            if triangle.isConnectable || hexagon.getTriangle(direction: triangle.direction.right).isConnectable {
                ctx.addPath(dividerPath)
                ctx.setLineWidth(3)
                ctx.setStrokeColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
                ctx.setLineCap(.square)
                ctx.strokePath()
                ctx.setLineCap(.butt)
            }
            rotateRight(ctx)
        }

        // draw the circle based on hexagon movability
        if hexagon.isMovable {
            ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            ctx.setFillColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }

        ctx.setLineWidth(3)
        ctx.setStrokeColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)

        if hexagon.isSelected {
            ctx.addPath(hexagonPath)
            ctx.setLineWidth(12)
            ctx.strokePath()
            ctx.setLineWidth(3)
        }
        ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
        ctx.strokeEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))

        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }

    static func drawTriangle(hexagon: Hexagon, triangle: Triangle) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!

        // flip vertically so image correctly renders triangle pattern in correct direction
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: self.size.height)
        ctx.concatenate(flipVertical)

        // if a connectable side draw triangle color otherwise skip
        if triangle.isConnectable {
            ctx.addPath(trianglePath)
            ctx.setFillColor(triangle.color.uiColor.cgColor)
            ctx.fillPath()
        }

        // triangle is connected draw the lines to correctly create a diamond shape
        if triangle.isConnected && !hexagon.isDragging && !(triangle.neighbor?.isDragging ?? false) {
            ctx.addPath(triangleConnectedLinesPath)
            ctx.setLineCap(.square)
            ctx.setStrokeColor(darkGray)
            ctx.setLineWidth(6)
            ctx.strokePath()
            ctx.setLineCap(.butt)
        } else if triangle.isConnectable {
            // if triangle is able to be connected, draw black triangle to make it hollow
            ctx.addPath(triangleConnectableIndicatorPath)
            ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            ctx.setLineWidth(6)
            ctx.strokePath()

            // clip out some of the excess drawn parts of the triangle
            ctx.addPath(triangleConnectableClipPath)
            ctx.setBlendMode(.clear)
            ctx.fillPath()
            ctx.setBlendMode(.normal)
        }

        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
    static func rotateLeft(_ ctx: CGContext) {
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: -CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
    }
    static func rotateRight(_ ctx: CGContext) {
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
    }
}
