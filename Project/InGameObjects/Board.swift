//
// Created by Алексей Степанов on 2023-01-07.
//

import Foundation

enum BoardTile: Codable {
    case empty
    case room([Direction: Interaction])
}

struct Board: Codable {
    private let width: Int
    private let height: Int
    private var field: [BoardTile]

    public init() {
        width = 0
        height = 0
        field = []
    }

    public init(JSON: String) {
        let decoder = JSONDecoder()
        let data = JSON.data(using: .utf8)!
        self = try! decoder.decode(Board.self, from: data)
    }

    public func getWidth() -> Int { width }

    public func getHeight() -> Int { height }

    public func getTile(_ x: size_t, _ y: size_t) -> BoardTile { field[width * y + x] }

    public func getTile(_ num: size_t) -> BoardTile { field[num] }

    public func getJSON() -> String {
        let encoder = JSONEncoder()
        let data = try! encoder.encode(self)
        return String(data: data, encoding: .utf8)!
    }
}
