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
    private var actionExecutors: [ActionExecutor]
    
    override init(frame: CGRect) {
        currentInteractions = Interactions()
        actionExecutors = []
        
        super.init(frame: frame)
        self.backgroundColor = .clear
        
        setUp()
    }
    
    required init?(coder: NSCoder) {
        currentInteractions = Interactions()
        actionExecutors = []
        
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
    
    @objc
    private func swipeAction(_ gesture: UISwipeGestureRecognizer) {
        if gesture.direction == .up {
            print("up")
            pingAllActionExecutors(currentInteractions.onGoForward)
        } else if gesture.direction == .down {
            print("down")
            pingAllActionExecutors(currentInteractions.onGoBack)
        } else if gesture.direction == .left {
            print("left")
            pingAllActionExecutors(currentInteractions.onGoRight)
        } else if gesture.direction == .right {
            print("right")
            pingAllActionExecutors(currentInteractions.onGoLeft)
        }
    }
    
    @objc
    private func tapAction(_ gesture: UITapGestureRecognizer) {
        let tapLocation = Coordinate(x: Int(gesture.location(in: self).x), y: Int(gesture.location(in: self).y))
        
        for tapAction in currentInteractions.onTap {
            if tapAction.key.doesContainCoordinate(tapLocation) {
                print("tap success")
                pingAllActionExecutors(tapAction.value)
            }
        }
        print("tap unsuccess")
    }
    
    private func pingAllActionExecutors(_ actions: [Action]) {
        for executor in actionExecutors {
            executor.doActions(actions)
        }
    }
    
    public func updateByTile(_ tileSide: TileSideData) {
        currentInteractions = tileSide.interactions
    }
    
    public func setActionExecutor(_ executor: ActionExecutor) {
        actionExecutors.append(executor)
        print("executor is added")
    }
}
