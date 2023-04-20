//
//  LogicProperty.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

struct LogicProperty: Codable, Hashable {
    let name: String
    private var value: Int
    
    init(name: String, value: Int) {
        self.name = name
        self.value = value
    }
    
    mutating func updateValue(value: Int) {
        self.value = value
    }
}

struct LogicPropertyArray: Codable, Hashable {
    private var array: [LogicProperty]
    
    init() {
        array = []
    }
    
    init(array: [LogicProperty]) {
        self.array = array
    }
    
    mutating func updateLogic(name: String, newValue: Int) {
        if let index = array.firstIndex(where: {$0.name == name}) {
            array[index].updateValue(value: newValue)
        } else {
            let logic = LogicProperty(name: name, value: newValue)
            array.append(logic)
        }
    }
}
