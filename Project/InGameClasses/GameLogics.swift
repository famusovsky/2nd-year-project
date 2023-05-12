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
    private var stringsPresenter: StringsPresenterDelegate?
    private var gameResultsObserver: GameResultsObserver?
    // TODO: MINOR Should also contain array of pictures
    
    init(_ levels: LevelList, _ currentLevel: Int = 0) {
        self.levelList = levels
        self.currentLevel = currentLevel
    }
    
    public func setGameResultsObserver(_ observer: GameResultsObserver) {
        gameResultsObserver = observer
    }
    
    public func doActions(_ actions: [Action]) {
        print("do actions")
        for action in actions {
            doAction(action)
        }
    }
    
    public func doAction(_ action: Action) {
        switch action {
        case .win(let text):
            gameResultsObserver?.reactToGameResult(GameResult.win(text: text))
        case .lose(let text):
            gameResultsObserver?.reactToGameResult(GameResult.win(text: text))
        case .goForward:
            levelList.getLevel(currentLevel)?.goForward()
        case .turnLeft:
            levelList.getLevel(currentLevel)?.turnLeft()
        case .turnRight:
            levelList.getLevel(currentLevel)?.turnRight()
        case .goToLevel(let destination):
            levelList.getLevel(currentLevel)?.removeTileObservers()
            currentLevel = destination
            
            levelList.getLevel(currentLevel)?.setTileObservers(tileObservers)
            levelList.getLevel(currentLevel)?.pingAllTileObservers()
            pingAllLevelObservers()
        case .updateLogics(let logics):
            for logic in logics {
                levelList.getLevel(currentLevel)?.updateLogic(logic.key, logic.value)
            }
            levelList.getLevel(currentLevel)?.pingAllTileObservers()
        case .showTips(let tips):
            stringsPresenter?.presentStrings(tips)
        case .nothing, .goBack:
            break
        }
        
        // XXX: remove log
        levelList.getLevel(currentLevel)?.logInfo()
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
    
    public func setStringsPresenterDelegate(_ delegate: StringsPresenterDelegate) {
        stringsPresenter = delegate
    }
    
    private func pingAllLevelObservers() {
        for observer in levelObservers {
            observer.updateByLevel(levelList.getLevel(currentLevel) ?? Level())
        }
    }
}

extension GameLogics: SaveDelegate {
    public func save() {
        
        let defaults = UserDefaults.standard
        var savedGames = defaults.stringArray(forKey: "savedGames") ?? []
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "[dd-MM-yyyy HH:mm:ss]"
        let dateString = dateFormatter.string(from: Date())
        
        let currentGame = GameData(name: dateString, index: currentLevel, levels: levelList.getLevelModelList())
        
        if let currentGameJSON = encodeToJSON(currentGame) {
            savedGames.append(currentGameJSON)
            defaults.set(savedGames, forKey: "savedGames")
        }
    }
}
