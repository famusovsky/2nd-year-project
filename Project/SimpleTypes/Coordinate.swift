//
// Created by Алексей Степанов on 2023-01-07.
//

import Foundation

struct Coordinate : Codable {
    let x: Int
    let y: Int
    
    init() {
        x = 0
        y = 0
    }
    
    init(x: Int, y: Int) {
        self.x = x
        self.y = y
    }
}

