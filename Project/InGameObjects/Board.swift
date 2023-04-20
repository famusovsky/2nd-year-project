//
// Created by Алексей Степанов on 2023-01-07.
//

import Foundation

// TODO: Add json check

struct Board: Codable {
    // public let startCoordinate: Coordinate
    // public let startDirection: Direction
    public let width: Int
    public let height: Int
    private let field: [BoardTile]
    
    public init() {
        width = 0
        height = 0
        field = []
        // startCoordinate = Coordinate(x: 0, y: 0)
        // startDirection = Direction.north
        print(getJSON())
    }
    
    public init(_ JSON: String) {
        let decoder = JSONDecoder()
        let data = JSON.data(using: .utf8)!
        self = try! decoder.decode(Board.self, from: data)
    }
    
    public func getTile(_ x: size_t, _ y: size_t) -> BoardTile {
        if (x >= width || y >= height) {
            return BoardTile.empty
        }
        return field[width * y + x]
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
    
    public func getJSON() -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
