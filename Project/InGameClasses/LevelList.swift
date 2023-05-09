//
//  LevelList.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-08.
//

import Foundation

class LevelList {
    private var levels: [Level] = []
    
    public func addLevel(_ newLevel: Level) {
        levels.append(newLevel)
    }
    
    public func addLevels(_ newLevels: [Level]) {
        newLevels.forEach({levels.append($0)})
    }
    
    public func addLevel(_ newLevelModel: LevelModel) {
        levels.append(Level(newLevelModel))
    }
    
    public func addLevels(_ newLevelModels: [LevelModel]) {
        newLevelModels.forEach({levels.append(Level($0))})
    }
    
    public func addLevel(_ newLevelModel: LevelModel, _ index: Int) {
        if index > 0 {
            while index >= levels.count {
                levels.append(Level())
            }
            levels.insert(Level(newLevelModel), at: index)
        }
    }
    
    public func removeLevel(_ index: Int) {
        if index > 0 && index < levels.count {
            levels.remove(at: index)
        }
    }
    
    public func getLevel(_ index: Int) -> Level? {
        if index >= 0 && index < levels.count {
            return levels[index]
        }
        
        print("no level")
        return nil
    }
}
