//
//  LevelList.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-08.
//

import Foundation

class LevelList {
    private var levels: [Int:Level] = [:]
    
    public func addLevel(_ newLevelModel: LevelModel, _ index: Int) {
        levels[index] = Level(newLevelModel)
    }
    
    public func removeLevel(_ index: Int) {
        levels.removeValue(forKey: index)
    }
    
    public func getLevel(_ index: Int) -> Level? {
        if levels.keys.contains(index) {
            return levels[index]
        }
        
        return nil
    }
}

extension LevelList {
    public func getLevelModelList() -> [Int:LevelModel] {
        var levelModelList: [Int:LevelModel] = [:]
        
        for pair in levels {
            levelModelList[pair.key] = pair.value.getLevelModel()
        }
        
        return levelModelList
    }
    
    public func installGameData(_ gameData: GameData) {
        levels = [:]
        
        for pair in gameData.levels {
            levels[pair.key] = Level(pair.value)
        }
    }
}
