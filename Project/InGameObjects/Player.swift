//
// Created by Алексей Степанов on 2023-01-15.
//

import Foundation

struct Coordinate : Codable {
    var x: Int
    var y: Int
}

class Player {
    private var board: Board? = nil
    private var position: Coordinate? = nil
    private var direction: Direction? = nil
}
