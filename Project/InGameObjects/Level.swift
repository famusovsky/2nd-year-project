//
//  Level.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct LevelModel: Codable {
    let board: Board
    let logics: LogicPropertyArray
    let coordinate: Coordinate
    let direction: Direction
    
    init() {
        board = Board()
        logics = LogicPropertyArray()
        coordinate = Coordinate()
        direction = Direction.north
    }
    
    init(_ board: Board, _ logics: LogicPropertyArray,
         _ startCoordinate: Coordinate, _ startDirection: Direction) {
        self.board = board
        self.logics = logics
        coordinate = startCoordinate
        direction = startDirection
    }
}

class Level {
    private let board: Board
    private var logics: LogicPropertyArray
    private var currentCoordinate: Coordinate
    private var currentDirection: Direction
    private var tileObservers: [TileObserver] = []
    
    init() {
        board = Board()
        logics = LogicPropertyArray()
        currentCoordinate = Coordinate()
        currentDirection = Direction.north
    }
    
    init(_ board: Board, _ logics: LogicPropertyArray,
         _ startCoordinate: Coordinate, _ startDirection: Direction) {
        self.board = board
        self.logics = logics
        currentCoordinate = startCoordinate
        currentDirection = startDirection
    }
    
    init(_ model: LevelModel) {
        self.board = model.board
        self.logics = model.logics
        currentCoordinate = model.coordinate
        currentDirection = model.direction
    }
    
    public func turnRight() {
        currentDirection.turnRight()
    }
    
    public func turnLeft() {
        currentDirection.turnLeft()
    }
    
    public func goForward() {
        let newPosition: Coordinate
        switch currentDirection {
        case .north:
            newPosition = Coordinate(x: currentCoordinate.x, y: currentCoordinate.y + 1)
        case .east:
            newPosition = Coordinate(x: currentCoordinate.x + 1, y: currentCoordinate.y)
        case .south:
            newPosition = Coordinate(x: currentCoordinate.x, y: currentCoordinate.y - 1)
        case .west:
            newPosition = Coordinate(x: currentCoordinate.x - 1, y: currentCoordinate.y)
        }
        
        switch board.getTile(newPosition) {
        case .empty:
            break
        case .filled(let room):
            currentCoordinate = newPosition
            pingAllTileObservers(room)
        }
    }
    
    public func updateLogic(_ name: String, _ newValue: Int) {
        logics.updateLogic(name: name, newValue: newValue)
        let currentTile = board.getTile(currentCoordinate)
        if case let .filled(room) = currentTile {
            pingAllTileObservers(room)
        }
    }
    
    public func setTileObserver(_ observer: TileObserver) {
        tileObservers.append(observer)
    }
    
    private func pingAllTileObservers(_ room: Room) {
        let current = room.getSideData(direction: currentDirection, logics: logics)
        for observer in tileObservers {
            observer.updateByTile(current)
        }
    }
}
