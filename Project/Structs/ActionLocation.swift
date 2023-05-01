//
//  ActionLocation.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct ActionLocation: Codable, Hashable {
    let widthMultiplier: CGFloat
    let heightMultiplier: CGFloat
    let radius: CGFloat
    let coordinate: Coordinate
    
    init(widthMultiplier: CGFloat, heightMultiplier: CGFloat, radius: CGFloat, coordinate: Coordinate) {
        self.widthMultiplier = widthMultiplier
        self.heightMultiplier = heightMultiplier
        self.radius = radius
        self.coordinate = coordinate
    }
    
    public func doesContainCoordinate(_ coordinate: Coordinate) -> Bool {
        let realWidthRadius = Int(self.radius * self.widthMultiplier)
        let realHeightRadius = Int(self.radius * self.heightMultiplier)
        
        return coordinate.x <= self.coordinate.x + realWidthRadius &&
                coordinate.x >= self.coordinate.x - realWidthRadius &&
                coordinate.y <= self.coordinate.y + realHeightRadius &&
                coordinate.y >= self.coordinate.y - realHeightRadius
    }
}
