//
//  ActionExecutor.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-30.
//

import Foundation

protocol ActionExecutor {
    func doActions(_ actions: [Action])
    
    func doAction(_ action: Action)
}
