//
// Created by Алексей Степанов on 2023-01-15.
//

import Foundation

class Player {
    private var board: Board? = nil
    private var position: Coordinate? = nil
    private var direction: Direction? = nil

    public func setBoard(_ board: Board) {
        self.board = board
        position = board.startCoordinate
        direction = board.startDirection
    }

    public func turnRight() {
        direction?.turnRight()
    }

    public func turnLeft() {
        direction?.turnLeft()
    }

    public func goForward() {
        if let currentPosition = position, let direction = direction, let board = board {
            let newPosition: Coordinate
            switch direction {
            case .north:
                newPosition = Coordinate(x: currentPosition.x, y: currentPosition.y + 1)
            case .east:
                newPosition = Coordinate(x: currentPosition.x + 1, y: currentPosition.y)
            case .south:
                newPosition = Coordinate(x: currentPosition.x, y: currentPosition.y - 1)
            case .west:
                newPosition = Coordinate(x: currentPosition.x - 1, y: currentPosition.y)
            }
            switch board.getTile(newPosition) {
            case .empty:
                break
            case .room(let interactions):
                // TODO: check interactions
                position = newPosition
            }
        }
    }
}
