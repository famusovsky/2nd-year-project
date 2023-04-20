//
//  TileSideData.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct TileSideData: Codable {
    let interactions: Interactions
    // TODO: Picture
    
    init() {
        interactions = Interactions()
    }
    
    init(_ interactions: Interactions) {
        self.interactions = interactions
    }
}
