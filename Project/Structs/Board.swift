//
// Board.swift
// Project
//
// Created by Алексей Степанов on 2023-01-07.
//

import Foundation

struct Board: Codable {
    public let width: Int
    public let height: Int
    private let field: [BoardTile]
    
    public init() {
        width = 0
        height = 0
        field = []
    }
    
    public func getTile(_ x: size_t, _ y: size_t) -> BoardTile {
        if (x >= width || y >= height) {
            return BoardTile.empty
        }
        return field[width * (height - y - 1) + x]
    }
    
    public func getTile(_ coordinate: Coordinate) -> BoardTile {
        return getTile(coordinate.x, coordinate.y)
    }
    
    public func getTile(_ num: size_t) -> BoardTile {
        if (num >= width * height) {
            return BoardTile.empty
        }
        return field[num]
    }
}
