//
//  Room.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct Room: Codable {
    // TODO: MINOR Should also contain pictures
    let data: [Direction: [LogicPropertyArray: TileSideData]]
    
    init() {
        data = [:]
    }
    
    init(data: [Direction: [LogicPropertyArray: TileSideData]]) {
        self.data = data
    }
    
    func getSideData(direction: Direction,
                         logics: LogicPropertyArray) -> TileSideData  {
        
        if let set = data[direction]  {
            if let index = set.firstIndex(where: {logics.contains($0.key)} ){
                return set[index].value
            }
        }
        return TileSideData()
    }
}
