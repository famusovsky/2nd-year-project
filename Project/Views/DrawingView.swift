//
//  DrawingView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-30.
//

import Foundation
import UIKit

class DrawingView: UIView {
    // TODO: save the drawing between sessions
    private var path = UIBezierPath()
    private var isErasing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .clear
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    public func setUp() {
        cleanUp()
        
        setUpTogglePenButton()
        setUpCleanUpButton()
    }
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
        let point = gesture.location(in: self)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3.5
        
        switch gesture.state {
        case .began:
            path = UIBezierPath()
            path.move(to: point)
            
        case .changed:
            if isErasing {
                shapeLayer.strokeColor = UIColor.clear.cgColor
                
                let erasePath = UIBezierPath()
                erasePath.move(to: point)
                erasePath.addLine(to: CGPoint(x: point.x + 10, y: point.y))
                
                shapeLayer.path = erasePath.cgPath
            } else {
                shapeLayer.strokeColor = UIColor.black.cgColor
                
                path.addLine(to: point)
                
                shapeLayer.path = path.cgPath
            }
            
        case .ended:
            break
            
        default:
            break
        }
    }
    
    @objc
    private func togglePen(_ sender: UIButton) {
        isErasing.toggle()
        sender.isSelected.toggle()
    }
    
    private func setUpTogglePenButton() {
        let togglePenButton = UIButton()
        
        togglePenButton.layer.cornerRadius = 12
        togglePenButton.backgroundColor = .clear
        togglePenButton.setHeight(48)
        togglePenButton.setWidth(48)
        togglePenButton.setTitle("✍🏻", for: .normal)
        togglePenButton.setTitle("🧽", for: .selected)
        
        togglePenButton.addTarget(self, action: #selector(togglePen(_:)), for: .touchUpInside)
        self.addSubview(togglePenButton)
        
        togglePenButton.pinTop(to: self, 5)
        togglePenButton.pinLeft(to: self, 5)
        
        togglePenButton.isEnabled = true
    }
    
    @objc
    public func cleanUp() {
        path.removeAllPoints()
        
        while self.layer.sublayers?.count ?? 0 > 2 {
            self.layer.sublayers?.remove(at: 2)
        }
    }
    
    private func setUpCleanUpButton() {
        let cleanUpButton = UIButton()
        
        cleanUpButton.layer.cornerRadius = 12
        cleanUpButton.backgroundColor = .clear
        cleanUpButton.setHeight(48)
        cleanUpButton.setWidth(48)
        cleanUpButton.setTitle("🧹", for: .normal)
        
        cleanUpButton.addTarget(self, action: #selector(cleanUp), for: .touchUpInside)
        self.addSubview(cleanUpButton)
        
        cleanUpButton.pinTop(to: self, 5)
        cleanUpButton.pinLeft(to: self, 5 + 48 + 5)
        
        cleanUpButton.isEnabled = true
    }
}
