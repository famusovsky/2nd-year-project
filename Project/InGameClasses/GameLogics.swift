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
    private var levelObservers: [LevelObserver] = []
    // TODO: array of pictures
    
    init(_ levels: [Level], _ currentLevel: Int = 0) {
        self.levels = levels
        self.currentLevel = currentLevel
    }
    
    public func win() {
        // TODO: implement
        print("win")
    }
    
    public func lose() {
        // TODO: implement
        print("lose")
    }
    
    public func doActions(_ actions: [Action]) {
        print("do actions")
        for action in actions {
            doAction(action)
        }
    }
    
    public func doAction(_ action: Action) {
        print("do action")
        switch action {
        case .win:
            win()
            break
        case .lose:
            lose()
            break
        case .goForward:
            levels[currentLevel].goForward()
            break
        case .goBack:
            break
        case .turnLeft:
            levels[currentLevel].turnLeft()
            break
        case .turnRight:
            levels[currentLevel].turnRight()
            break
        case .goToLevel(let destination):
            levels[currentLevel].removeTileObservers()
            currentLevel = destination
            
            // TODO: update Views
            levels[currentLevel].setTileObservers(tileObservers)
            levels[currentLevel].pingAllTileObservers()
            pingAllLevelObservers()
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
        
        // TODO: remove log
        levels[currentLevel].logInfo()
    }
    
    public func setTileObserver(_ observer: TileObserver) {
        tileObservers.append(observer)
        
        levels[currentLevel].setTileObserver(observer)
        levels[currentLevel].pingAllTileObservers()
    }
    
    public func setLevelObserver(_ observer: LevelObserver) {
        levelObservers.append(observer)
        
        observer.updateByLevel(levels[currentLevel])
    }
    
    private func pingAllLevelObservers() {
        for observer in levelObservers {
            observer.updateByLevel(levels[currentLevel])
        }
    }
}
