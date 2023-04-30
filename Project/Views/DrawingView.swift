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
    
    @objc
    private func handlePanGesture(_ gesture: UIPanGestureRecognizer) {
        let shapeLayer = CAShapeLayer()
        self.layer.addSublayer(shapeLayer)
        let point = gesture.location(in: self)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        switch gesture.state {
        case .began:
            // Start a new path at the touch location
            path = UIBezierPath()
            path.move(to: point)
            
        case .changed:
            if isErasing {
                // Set the stroke color to clear to erase the existing lines
                shapeLayer.strokeColor = UIColor.clear.cgColor
                
                // Create a new path to erase the lines at the touch location
                let erasePath = UIBezierPath()
                erasePath.move(to: point)
                erasePath.addLine(to: CGPoint(x: point.x + 10, y: point.y))
                
                // Update the shape layer's path to reflect the erasure
                shapeLayer.path = erasePath.cgPath
            } else {
                shapeLayer.strokeColor = UIColor.black.cgColor
                
                // Add a line to the existing path at the touch location
                path.addLine(to: point)
                
                // Update the shape layer's path to reflect the new line
                shapeLayer.path = path.cgPath
            }
            
        case .ended:
            // No action needed
            break
            
        default:
            break
        }
    }


    
    
    //    // Method to enable or disable erasing
    //    func setEraserEnabled(_ enabled: Bool) {
    //        isErasing = enabled
    //
    //        if isErasing {
    //            // Set the line width to a larger value to make the eraser more visible
    //            shapeLayer.lineWidth = 20
    //
    //            // Set the blend mode to "clear" to erase the existing lines
    //            shapeLayer.blendMode = .clear
    //        } else {
    //            // Reset the line width and blend mode to their default values
    //            shapeLayer.lineWidth = 1
    //            shapeLayer.blendMode = .normal
    //
    //            // Set the stroke color to black to draw new lines
    //            shapeLayer.strokeColor = UIColor.black.cgColor
    //        }
    //    }
    
    // Method to clear all the drawing on the view
    func clearDrawing() {
        // Reset the path and shape layer's path
        path.removeAllPoints()
        self.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
    }
}
