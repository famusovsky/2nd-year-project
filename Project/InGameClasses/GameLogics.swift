//
//  GameLogics.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

class GameLogics: ActionExecutor {
    private let levels: [Level]
    private var currentLevel: Int
    private var tileObservers: [TileObserver] = []
    // TODO: array of pictures
    
    init(_ levels: [Level], _ currentLevel: Int = 0) {
        self.levels = levels
        self.currentLevel = currentLevel
    }
    
    public func win() {
        // TODO
    }
    
    public func lose() {
        // TODO
    }
    
    public func doActions(_ actions: [Action]) {
        for action in actions {
            doAction(action)
        }
    }
    
    public func doAction(_ action: Action) {
        switch action {
        case .win:
            win()
            break
        case .lose:
            lose()
            break
        case .goToLevel(let destination):
            levels[currentLevel].removeTileObservers()
            currentLevel = destination
            for observer in tileObservers {
                levels[currentLevel].setTileObserver(observer)
            }
            levels[currentLevel].pingAllTileObservers()
            // TODO: update Views
            break
        case .updateLogics(let logics):
            for logic in logics {
                levels[currentLevel].updateLogic(logic.key, logic.value)
            }
            levels[currentLevel].pingAllTileObservers()
            break
        case .nothing:
            break
        }
    }
    
    public func setTileObserver(_ observer: TileObserver) {
        tileObservers.append(observer)
    }
}
