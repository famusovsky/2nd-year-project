//
//  UIView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation
import UIKit

class GameUIView: UIView, TileObserver {
    private var currentInteractions: Interactions
    
    override init(frame: CGRect) {
        currentInteractions = Interactions()
        
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        currentInteractions = Interactions()
        
        super.init(coder: coder)
        self.backgroundColor = UIColor.clear
        
        setUp()
    }
    
    private func setUp() {
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
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapAction(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func updateByTile(_ tileSide: TileSideData) {
        currentInteractions = tileSide.interactions
    }
    
    // Handle the swipe gesture
    @objc
    func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        // TODO: throw action to GameLogics
        if gesture.direction == .up {
            print("up")
        } else if gesture.direction == .down {
            print("down")
        } else if gesture.direction == .left {
            print("left")
        } else if gesture.direction == .right {
            print("right")
        }
    }
    
    @objc
    func tapAction(_ gesture: UITapGestureRecognizer) {
        let tapLocation = Coordinate(x: Int(gesture.location(in: self).x), y: Int(gesture.location(in: self).y))
        
        for tapAction in currentInteractions.onTap {
            if tapAction.key.doesContainCoordinate(tapLocation) {
                // TODO: throw action to GameLogics
                print("tap success")
            }
        }
        print("tap unsuccess")
    }
}
