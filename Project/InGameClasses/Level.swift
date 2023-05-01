//
//  Level.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct LevelModel: Codable {
    var board: Board
    var logics: LogicPropertyArray
    var coordinate: Coordinate
    var direction: Direction
    
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
    private var model: LevelModel
    private var tileObservers: [TileObserver] = []
    
    init() {
        model = LevelModel(Board(), LogicPropertyArray(), Coordinate(), Direction.north)
    }
    
    init(_ board: Board, _ logics: LogicPropertyArray,
         _ startCoordinate: Coordinate, _ startDirection: Direction) {
        model = LevelModel(board, logics, startCoordinate, startDirection)
    }
    
    init(_ model: LevelModel) {
        self.model = model
    }
    
    public func getBoard() -> Board {
        return model.board
    }
    
    public func turnRight() {
        model.direction.turnRight()
        pingAllTileObservers()
    }
    
    public func turnLeft() {
        model.direction.turnLeft()
        pingAllTileObservers()
    }
    
    public func goForward() {
        let newPosition: Coordinate
        switch model.direction {
        case .north:
            newPosition = Coordinate(x: model.coordinate.x, y: model.coordinate.y + 1)
        case .east:
            newPosition = Coordinate(x: model.coordinate.x + 1, y: model.coordinate.y)
        case .south:
            newPosition = Coordinate(x: model.coordinate.x, y: model.coordinate.y - 1)
        case .west:
            newPosition = Coordinate(x: model.coordinate.x - 1, y: model.coordinate.y)
        }
        
        if newPosition.x >= 0 && newPosition.y >= 0 &&
            newPosition.x < model.board.width && newPosition.y < model.board.height {
            switch model.board.getTile(newPosition) {
            case .empty:
                break
            case .filled(let room):
                model.coordinate = newPosition
                pingAllTileObservers(room)
            }
        }
    }
    
    private func getCurrentRoom() -> Room {
        let currentTile = model.board.getTile(model.coordinate)
        if case let .filled(room) = currentTile {
            return room
        }
        return Room()
    }
    
    public func updateLogic(_ name: String, _ newValue: Int) {
        model.logics.updateLogic(name: name, newValue: newValue)
        pingAllTileObservers(getCurrentRoom())
    }
    
    public func setTileObserver(_ observer: TileObserver) {
        tileObservers.append(observer)
    }
    
    public func setTileObservers(_ observers: [TileObserver]) {
        for observer in observers {
            tileObservers.append(observer)
        }
    }
    
    public func removeTileObservers() {
        tileObservers.removeAll(keepingCapacity: false)
    }
    
    private func pingAllTileObservers(_ room: Room) {
        let current = room.getSideData(direction: model.direction, logics: model.logics)
        for observer in tileObservers {
            observer.updateByTile(current)
        }
    }
    
    public func pingAllTileObservers() {
        pingAllTileObservers(getCurrentRoom())
    }
    
    public func logInfo() {
        print((encodeToJSON(model.coordinate) ?? "none Coordinate")
              + " --- " +
              (encodeToJSON(model.direction) ?? "none Direction"))
    }
}
