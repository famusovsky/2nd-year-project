//
//  Room.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct Room: Codable {
    // TODO: Should also contain pictures
    let data: [Direction: [LogicPropertyArray: TileSideData]]
    
    init() {
        data = [:]
    }
    
    init(data: [Direction: [LogicPropertyArray: TileSideData]]) {
        self.data = data
    }
    
    func getSideData(direction: Direction,
                         logics: LogicPropertyArray) -> TileSideData  {
        
        if let set = data[direction], let value = set[logics]  {
            return value
        }
        return TileSideData()
    }
}
