//
// Created by Алексей Степанов on 2023-01-08.
//

import Foundation

enum Direction: Int, Codable {
    case north = 0,
         east = 1,
         south = 2,
         west = 3

    mutating func turnRight() {
        self = Direction(rawValue: (rawValue + 1) % 4)!
    }

    mutating func turnLeft() {
        self = Direction(rawValue: (rawValue + 3) % 4)!
    }
}