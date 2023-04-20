//
//  LogicProperty.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct LogicProperty: Codable, Hashable {
    let name: String
    let value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
}

struct LogicPropertyArray: Codable, Hashable {
    let array: [LogicProperty]
    
    init(array: [LogicProperty]) {
        self.array = array
    }
}
