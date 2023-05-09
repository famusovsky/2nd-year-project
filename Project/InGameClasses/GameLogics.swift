//
//  GameLogics.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

class GameLogics: ActionExecutor {
    private let levels: LevelList
    private var currentLevel: Int
    private var tileObservers: [TileObserver] = []
    private var levelObservers: [LevelObserver] = []
    // TODO: array of pictures
    
    init(_ levels: LevelList, _ currentLevel: Int = 0) {
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
            levels.getLevel(currentLevel)?.goForward()
            break
        case .goBack:
            break
        case .turnLeft:
            levels.getLevel(currentLevel)?.turnLeft()
            break
        case .turnRight:
            levels.getLevel(currentLevel)?.turnRight()
            break
        case .goToLevel(let destination):
            levels.getLevel(currentLevel)?.removeTileObservers()
            currentLevel = destination
            
            // TODO: update Views
            levels.getLevel(currentLevel)?.setTileObservers(tileObservers)
            levels.getLevel(currentLevel)?.pingAllTileObservers()
            pingAllLevelObservers()
            break
        case .updateLogics(let logics):
            for logic in logics {
                levels.getLevel(currentLevel)?.updateLogic(logic.key, logic.value)
            }
            levels.getLevel(currentLevel)?.pingAllTileObservers()
            break
        case .nothing:
            break
        }
        
        // TODO: remove log
        levels.getLevel(currentLevel)?.logInfo()
    }
    
    public func setTileObserver(_ observer: TileObserver) {
        tileObservers.append(observer)
        
        levels.getLevel(currentLevel)?.setTileObserver(observer)
        levels.getLevel(currentLevel)?.pingAllTileObservers()
    }
    
    public func setLevelObserver(_ observer: LevelObserver) {
        levelObservers.append(observer)
        
        observer.updateByLevel(levels.getLevel(currentLevel) ?? Level())
    }
    
    private func pingAllLevelObservers() {
        for observer in levelObservers {
            observer.updateByLevel(levels.getLevel(currentLevel) ?? Level())
        }
    }
}
