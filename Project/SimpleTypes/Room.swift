//
//  Room.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct Room: Codable {
    // TODO: Should also contain pictures
    let data: [Direction: [LogicPropertyArray: Interactions]]
    
    init() {
        data = [:]
    }
    
    init(data: [Direction: [LogicPropertyArray: Interactions]]) {
        self.data = data
    }
    
    func getInteractions(direction: Direction,
                         logics: LogicPropertyArray) -> Interactions  {
        
        if let set = data[direction], let value = set[logics]  {
            return value
        }
        return Interactions()
    }
}
