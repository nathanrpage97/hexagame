//
//  drawer.swift
//  hexagame
//
//  Created by Nathan Page on 11/28/20.
//  Copyright © 2020 Nathan. All rights reserved.
//

import SpriteKit

func drawExitButton(scale: CGFloat = 3.0) -> CGImage {
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, scale)
    let ctx = UIGraphicsGetCurrentContext()!

    let path = CGMutablePath()

    path.move(to: CGPoint(x: 512, y: 30.166))
    path.addLine(to: CGPoint(x: 481.834, y: 0))
    path.addLine(to: CGPoint(x: 256, y: 225.834))
    path.addLine(to: CGPoint(x: 30.166, y: 0))
    path.addLine(to: CGPoint(x: 0, y: 30.166))
    path.addLine(to: CGPoint(x: 225.834, y: 256))
    path.addLine(to: CGPoint(x: 0, y: 481.834))
    path.addLine(to: CGPoint(x: 30.166, y: 512))
    path.addLine(to: CGPoint(x: 256, y: 286.166))
    path.addLine(to: CGPoint(x: 481.834, y: 512))
    path.addLine(to: CGPoint(x: 512, y: 481.834))
    path.addLine(to: CGPoint(x: 286.166, y: 256))
    path.closeSubpath()

    ctx.setFillColor(UIColor.black.cgColor)
    ctx.setAlpha(0.8)
    ctx.addPath(path)
    ctx.fillPath()

    let image = ctx.makeImage()!
    UIGraphicsEndImageContext()
    return image

}

func drawChevron(scale: CGFloat = 3.0, color: CGColor) -> CGImage {

    UIGraphicsBeginImageContextWithOptions(CGSize(width: 512, height: 512), false, scale)
    let ctx = UIGraphicsGetCurrentContext()!

    let path = CGMutablePath()

    path.move(to: CGPoint(x: 315.869, y: 21.178))
    path.addLine(to: CGPoint(x: 294.621, y: -0))
    path.addLine(to: CGPoint(x: 91.566, y: 203.718))
    path.addLine(to: CGPoint(x: 294.621, y: 407.436))
    path.addLine(to: CGPoint(x: 315.869, y: 386.258))
    path.addLine(to: CGPoint(x: 133.924, y: 203.718))

    path.closeSubpath()

    ctx.setFillColor(UIColor.black.cgColor)
    ctx.setAlpha(0.8)
    ctx.addPath(path)
    ctx.fillPath()

    let image = ctx.makeImage()!
    UIGraphicsEndImageContext()
    return image

}
