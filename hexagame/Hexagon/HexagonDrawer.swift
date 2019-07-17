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
    
    static func draw(hexagon: Hexagon) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        var path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 104))
        path.addLine(to: CGPoint(x: 0, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 0))
        path.addLine(to: CGPoint(x: 90, y: 0))
        path.addLine(to: CGPoint(x: 120, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 104))
        path.closeSubpath()
        ctx.addPath(path)
        ctx.clip() // used so that the hexagon
        
        path = CGMutablePath()
        path.move(to: CGPoint(x: 30, y: 103))
        path.addLine(to: CGPoint(x: 1, y: 52))
        path.addLine(to: CGPoint(x: 30, y: 1))
        path.addLine(to: CGPoint(x: 90, y: 1))
        path.addLine(to: CGPoint(x: 119, y: 52))
        path.addLine(to: CGPoint(x: 90, y: 103))
        path.closeSubpath()
        ctx.addPath(path)
        
        if hexagon.isMovable {
            ctx.setFillColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1) // light gray
        } else {
            ctx.setFillColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1) // dark gray
        }
        ctx.fillPath()
        
        // start with north (as side iterator starts with north)
        ctx.translateBy(x: 60, y: 52)
        ctx.rotate(by: -CGFloat.pi/3)
        ctx.translateBy(x: -60, y: -52)
        
        // draw the traingles and the blocker if not connected
        for side in hexagon.sides {
            let triange = HexagonDrawer.createTriange(hexagon: hexagon, side: side)
            ctx.draw(triange, in: CGRect(origin: .zero, size: self.size))
            
            if !side.isConnected {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 90 ,y: 0))
                path.addLine(to: CGPoint(x: 120 ,y: 52))
                ctx.setLineWidth(8)
                ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
                ctx.addPath(path)
                ctx.strokePath()
            }
            
            ctx.translateBy(x: 60, y: 52)
            ctx.rotate(by: CGFloat.pi/3)
            ctx.translateBy(x: -60, y: -52)
        }
        
        // draw the dividers
        for side in hexagon.sides {
            if side.acrossSides.1?.isConnectable == true || side.isConnectable {
                let path = CGMutablePath()
                path.move(to: CGPoint(x: 60 ,y: 52))
                path.addLine(to: CGPoint(x: 120 ,y: 52))
                ctx.setLineWidth(4)
                ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
                ctx.addPath(path)
                ctx.setLineCap(.square)
                ctx.strokePath()
                ctx.setLineCap(.butt)
            }
            
            ctx.translateBy(x: 60, y: 52)
            ctx.rotate(by: CGFloat.pi/3)
            ctx.translateBy(x: -60, y: -52)
        }
        
        // draw the ellipse
        if hexagon.isMovable {
            ctx.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
        } else {
            ctx.setFillColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1)
        }
        
        ctx.fillEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))
        ctx.setLineWidth(CGFloat(4))
        ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        ctx.strokeEllipse(in: CGRect(origin: CGPoint(x: 50, y: 42), size: CGSize(width: 20, height: 20)))

        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
    
    static func createTriange(hexagon: Hexagon, side: HexagonSide) -> CGImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        let ctx = UIGraphicsGetCurrentContext()!
        
        // flip vertically so image correctly renders triangle pattern in correct direction
        let flipVertical = CGAffineTransform(a: 1, b: 0, c: 0, d: -1, tx: 0, ty: self.size.height)
        ctx.concatenate(flipVertical)

        if side.connectionColor != .base {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 60 ,y: 53))
            path.addLine(to: CGPoint(x: 91 ,y: -1.7))
            path.addLine(to: CGPoint(x: 120 ,y: 53))
            path.closeSubpath()
            
            ctx.setFillColor(HexagonSideColor.uiColor(color: side.connectionColor).cgColor)
            ctx.addPath(path)
            ctx.fillPath()
        }
        
        if side.isConnected {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 90 ,y: 0))
            path.addLine(to: CGPoint(x: 120 ,y: 0))
            path.move(to: CGPoint(x: 120 ,y: 52))
            path.addLine(to: CGPoint(x: 150 ,y: 0))
            path.closeSubpath()
            ctx.addPath(path)
            ctx.setLineCap(.square)
            ctx.setStrokeColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            ctx.setLineWidth(8)
            ctx.strokePath()
            ctx.setLineCap(.butt)

        } else if side.isConnectable {
            let path = CGMutablePath()
            path.move(to: CGPoint(x: 82 ,y: 39))
            path.addLine(to: CGPoint(x: 105 ,y: 0))
            path.addLine(to: CGPoint(x:  120,y: 39))
            path.closeSubpath()
            ctx.addPath(path)
            ctx.setFillColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
            ctx.fillPath()
        }
        
        let image = ctx.makeImage()!
        UIGraphicsEndImageContext()
        return image
    }
    
}
