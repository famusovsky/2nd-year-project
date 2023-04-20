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
    
    init(widthMultiplier: CGFloat, heightMultiplier: CGFloat, radius: CGFloat) {
        self.widthMultiplier = widthMultiplier
        self.heightMultiplier = heightMultiplier
        self.radius = radius
    }
}
