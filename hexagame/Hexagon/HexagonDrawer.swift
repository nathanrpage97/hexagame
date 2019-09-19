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
    /// scale of the image relative to size
    static let scale: CGFloat = 3.0

    /// size of the image
    static let size = CGSize(width: 120, height: 104)

    /// Draws the image of a hexagon
    ///
    /// - Parameter hexagon: hexagon to draw
    /// - Returns: image of the hexagon
    static func draw(hexagon: Hexagon) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!

        // clip the image around the hexagon to remove any overflow
        var path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 104))
        path.addLine(to: CGPoint(x: 0, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: 120, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 104))
        path.closeSubpath()
        ctx.addPath(path)
        ctx.clip()

        // draw the hexagon background inset 1px to prevent artifcacts of light gray being visible
        path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 103))
        path.addLine(to: CGPoint(x: 1, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 1))
        path.addLine(to: CGPoint(x: 90, y: 1))
        path.addLine(to: CGPoint(x: 119, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 103))
        path.closeSubpath()
        ctx.addPath(path)

        // use hexagon movability to determine background color
        if hexagon.isMovable {
            ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1) // light gray
        } else {
            ctx.setFillColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1) // dark gray
        }
        ctx.fillPath()

        // start with north (as side iterator starts with north, and triangle faces north-east)
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: -CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)

        // draw the traingles of each side and the outside edge if not connected
        for side in hexagon.sides {
            // draw triangle for side
            let triange = HexagonDrawer.createTriange(hexagon: hexagon, side: side)
            ctx.draw(triange, in: CGRect(origin: .zero, size: self.size))

            // !side.isConnected || hexagon.isDragging || side.neighbor?.isDragging ?? false
            // draw the outside edge
            if !side.isConnected || hexagon.isDragging || side.neighbor?.isDragging ?? false {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 90, y: 0))
                path.addLine(to: CGPoint(x: 120, y: 52))
                ctx.setLineWidth(6)
                ctx.setStrokeColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
                ctx.addPath(path)
                ctx.strokePath()
            }

            ctx.translateBy(x: 60, y: 52)
            ctx.rotate(by: CGFloat.pi/3)
            ctx.translateBy(x: -60, y: -52)
        }

        // draw the dividers
        for side in hexagon.sides {
            if hexagon.getSide(direction: side.direction.right).isConnectable || side.isConnectable {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 60, y: 52))
                path.addLine(to: CGPoint(x: 120, y: 52))
                ctx.setLineWidth(3)
                ctx.setStrokeColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
                ctx.addPath(path)
                ctx.setLineCap(.square)
                ctx.strokePath()
                ctx.setLineCap(.butt)
            }

            ctx.translateBy(x: 60, y: 52)
            ctx.rotate(by: CGFloat.pi/3)
            ctx.translateBy(x: -60, y: -52)
        }

        // draw the circle based on hexagon movability
        if hexagon.isMovable {
            ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            ctx.setFillColor(red: 0.6, green: 0.6, blue: 0.6, alpha: 1)
        }
        ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
        ctx.setLineWidth(3)
        ctx.setStrokeColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
        ctx.strokeEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))

        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }

    /// Generates the image for a triangle given the side and hexagon
    ///
    /// - Parameters:
    ///   - hexagon: the hexagon to draw the triangle
    ///   - side: the side of the hexagon to draw the triangle
    /// - Returns: a triangle facing north-east
    static func createTriange(hexagon: Hexagon, side: HexagonSide) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!

        // flip vertically so image correctly renders triangle pattern in correct direction
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: self.size.height)
        ctx.concatenate(flipVertical)

        // if a connectable side draw triangle color otherwise skip
        if side.isConnectable {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 60, y: 53))
            path.addLine(to: CGPoint(x: 91, y: -1.7))
            path.addLine(to: CGPoint(x: 120, y: 53))
            path.closeSubpath()

            ctx.setFillColor(side.connectionColor.uiColor.cgColor)
            ctx.addPath(path)
            ctx.fillPath()
        }

        // if triangle is connected draw the two black lines so the diamond connects properly
        if side.isConnected && !hexagon.isDragging && !(side.neighbor?.isDragging ?? false) {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 90, y: 0))
            path.addLine(to: CGPoint(x: 120, y: 0))
            path.move(to: CGPoint(x: 120, y: 52))
            path.addLine(to: CGPoint(x: 150, y: 0))
            path.closeSubpath()
            ctx.addPath(path)
            ctx.setLineCap(.square)
            ctx.setStrokeColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1)
            ctx.setLineWidth(6)
            ctx.strokePath()
            ctx.setLineCap(.butt)
        } else if side.isConnectable {
            // if triangle is able to be connected, draw black triangle to make it hollow
            var path = CGMutablePath()

            path = CGMutablePath()
            path.move(to: CGPoint(x: 108, y: 4))
            path.addLine(to: CGPoint(x: 90, y: 34.5))
            path.addLine(to: CGPoint(x: 120, y: 35))

            //path.closeSubpath()
            ctx.addPath(path)
            ctx.setStrokeColor(red: 0, green: 0, blue: 0, alpha: 0.2)
            ctx.setLineWidth(6)
            ctx.strokePath()

            path = CGMutablePath()
            path.move(to: CGPoint(x: 90, y: 34.5))
            path.addLine(to: CGPoint(x: 108, y: 4))
            path.addLine(to: CGPoint(x: 120, y: 4))
            path.addLine(to: CGPoint(x: 120, y: 35))

            path.closeSubpath()
            ctx.setBlendMode(.clear)
            ctx.addPath(path)
            ctx.fillPath()
            ctx.setBlendMode(.normal)
        }

        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
}
