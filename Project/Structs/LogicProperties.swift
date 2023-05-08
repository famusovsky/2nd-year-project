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
    
    init(_ name: String, _ value: Int) {
        self.name = name
        self.value = value
    }
    
    mutating func updateValue(_ value: Int) {
        self.value = value
    }
    
    public func getValue() -> Int {
        return value
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
            array[index].updateValue(newValue)
        } else {
            let logic = LogicProperty(name, newValue)
            array.append(logic)
        }
    }
    
    public func contains(_ logic: LogicProperty) -> Bool {
        return array.contains(where: { $0.name == logic.name && $0.getValue() == logic.getValue() })
    }
}
