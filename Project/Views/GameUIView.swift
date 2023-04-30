//
//  UIView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation
import UIKit

class GameUIView: UIView, TileObserver {
    public func setUp() {
        let swipeUp = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeUp.direction = .up
        self.addGestureRecognizer(swipeUp)

        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeDown.direction = .down
        self.addGestureRecognizer(swipeDown)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeLeft.direction = .left
        self.addGestureRecognizer(swipeLeft)

        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeAction(_:)))
        swipeRight.direction = .right
        self.addGestureRecognizer(swipeRight)
    }
    
    func updateByTile(_ tileSide: TileSideData) {
        self.subviews.forEach { $0.removeFromSuperview() }
        
        
    }
    
    // Handle the swipe gesture
    @objc func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            // Handle swipe up action
        } else if gesture.direction == .down {
            // Handle swipe down action
        } else if gesture.direction == .left {
            // Handle swipe left action
        } else if gesture.direction == .right {
            // Handle swipe right action
        }
    }
}
