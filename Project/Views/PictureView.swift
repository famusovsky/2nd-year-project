//
//  PictureView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation
import UIKit

class PictureView: UIView, TileObserver {
    private var goForwardOption = false
    private var goLeftOption = false
    private var goRightOption = false
    private var tapOptions: [ActionLocation] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.darkGray
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = UIColor.darkGray
    }
    
    override func draw(_ rect: CGRect) {
        self.subviews.forEach( { $0.removeFromSuperview() } )
        
        let context = UIGraphicsGetCurrentContext()!
        
        context.setStrokeColor(UIColor.black.cgColor)
        context.setFillColor(UIColor.lightGray.cgColor)
        context.setLineWidth(10.0)
        
        context.move(to: CGPoint(x: 0.0, y: bounds.maxY - bounds.midY / 8 - 15.0))
        context.addLine(to: CGPoint(x: bounds.maxX, y: bounds.maxY - bounds.midY / 8 - 15.0))
        context.strokePath()
        
        if goForwardOption {
            let firstPoint = CGPoint(x: bounds.midX - bounds.width / 3, y: bounds.maxY - bounds.midY / 8)
            let secondPoint = CGPoint(x: bounds.midX - bounds.width / 8, y: bounds.midY)
            let thirdPoint = CGPoint(x: bounds.midX + bounds.width / 8, y: bounds.midY)
            let fourthPoint = CGPoint(x: bounds.midX + bounds.width / 3, y: bounds.maxY - bounds.midY / 8)
            
            createQuadPath(firstPoint, secondPoint, thirdPoint, fourthPoint, context)
        }
        
        if goLeftOption {
            let firstPoint = CGPoint(x: 0.0 - 10.0, y: bounds.maxY - bounds.midY / 8)
            let secondPoint = CGPoint(x: 0.0 - 10.0, y: bounds.maxY - bounds.midY / 4)
            let thirdPoint = CGPoint(x: bounds.midX - bounds.width / 3, y: bounds.maxY - bounds.midY / 8)
            
            createQuadPath(firstPoint, secondPoint, thirdPoint, firstPoint, context)
        }
        
        if goRightOption {
            let firstPoint = CGPoint(x: bounds.maxX + 10.0, y: bounds.maxY - bounds.midY / 8)
            let secondPoint = CGPoint(x: bounds.maxX + 10.0, y: bounds.maxY - bounds.midY / 4)
            let thirdPoint = CGPoint(x: bounds.midX + bounds.width / 3, y: bounds.maxY - bounds.midY / 8)
            
            createQuadPath(firstPoint, secondPoint, thirdPoint, firstPoint, context)
        }
        
        for option in tapOptions {
            let round = UIView()
            round.setWidth(Int(option.radius) * 2)
            round.setHeight(Int(option.radius) * 2)
            round.layer.cornerRadius = option.radius
            round.backgroundColor = .orange
            round.alpha = 0.2

            self.addSubview(round)
            round.pinCenterX(to: self.leadingAnchor, option.coordinate.x)
            round.pinCenterY(to: self.topAnchor, option.coordinate.y)
        }
        
        context.addRect(CGRect(x: 0.0, y: 0.0, width: bounds.width, height: bounds.midY + 10.0))
        context.setFillColor(UIColor.black.cgColor)
        context.fillPath()
        
        context.addRect(CGRect(x: 0.0, y: bounds.height, width: bounds.width, height: -1 * bounds.midY / 8 - 10.0))
        context.setFillColor(UIColor.lightGray.cgColor)
        context.fillPath()
    }
    
    private func createQuadPath(_ firstPoint: CGPoint, _ secondPoint: CGPoint, _ thirdPoint: CGPoint, _ fourthPoint: CGPoint, _ context: CGContext) {
        let road = UIBezierPath()
        road.move(to: firstPoint)
        road.addLine(to: secondPoint)
        road.addLine(to: thirdPoint)
        road.addLine(to: fourthPoint)
        road.close()
        road.fill()
        context.addPath(road.cgPath)
        
        context.move(to: firstPoint)
        context.addLine(to: secondPoint)
        context.strokePath()
    }
    
    public func redraw() {
        setNeedsDisplay()
    }
    
    // TODO: MINOR fix -- have to show road only when go<there> possibility exists
    func updateByTile(_ tileSide: TileSideData) {
        goForwardOption = !tileSide.interactions.onGoForward.isEmpty
        goLeftOption = !tileSide.interactions.onGoLeft.isEmpty
        goRightOption = !tileSide.interactions.onGoRight.isEmpty
        
        tapOptions = []
        tileSide.interactions.onTap.forEach( {tapOptions.append($0.key)} )
        
        redraw()
    }
}

