//
// Interactions.swift
// Project
//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation

struct Interactions: Codable {
    let onGoForward: [Action]
    let onGoBack: [Action]
    let onGoLeft: [Action]
    let onGoRight: [Action]
    let onTap: [ActionLocation:[Action]]
    
    init() {
        onGoForward = []
        onGoBack = []
        onGoLeft = []
        onGoRight = []
        onTap = [:]
    }
    
    init(onGoForward: [Action], onGoBack: [Action], onGoLeft: [Action], onGoRight: [Action], onTap: [ActionLocation:[Action]]) {
        self.onGoForward = onGoForward
        self.onGoBack = onGoBack
        self.onGoLeft = onGoLeft
        self.onGoRight = onGoRight
        self.onTap = onTap
    }
}
