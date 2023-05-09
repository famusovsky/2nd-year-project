//
//  GameLogics.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

class GameLogics: ActionExecutor {
    private let levelList: LevelList
    private var currentLevel: Int
    private var tileObservers: [TileObserver] = []
    private var levelObservers: [LevelObserver] = []
    // TODO: array of pictures
    
    init(_ levels: LevelList, _ currentLevel: Int = 0) {
        self.levelList = levels
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
            levelList.getLevel(currentLevel)?.goForward()
            break
        case .goBack:
            break
        case .turnLeft:
            levelList.getLevel(currentLevel)?.turnLeft()
            break
        case .turnRight:
            levelList.getLevel(currentLevel)?.turnRight()
            break
        case .goToLevel(let destination):
            levelList.getLevel(currentLevel)?.removeTileObservers()
            currentLevel = destination
            
            // TODO: update Views
            levelList.getLevel(currentLevel)?.setTileObservers(tileObservers)
            levelList.getLevel(currentLevel)?.pingAllTileObservers()
            pingAllLevelObservers()
            break
        case .updateLogics(let logics):
            for logic in logics {
                levelList.getLevel(currentLevel)?.updateLogic(logic.key, logic.value)
            }
            levelList.getLevel(currentLevel)?.pingAllTileObservers()
            break
        case .nothing:
            break
        }
    }
    
    public func setTileObserver(_ observer: TileObserver) {
        tileObservers.append(observer)
        
        levelList.getLevel(currentLevel)?.setTileObserver(observer)
        levelList.getLevel(currentLevel)?.pingAllTileObservers()
    }
    
    public func setLevelObserver(_ observer: LevelObserver) {
        levelObservers.append(observer)
        
        observer.updateByLevel(levelList.getLevel(currentLevel) ?? Level())
    }
    
    private func pingAllLevelObservers() {
        for observer in levelObservers {
            observer.updateByLevel(levelList.getLevel(currentLevel) ?? Level())
        }
    }
}
