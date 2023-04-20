//
//  Action.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

enum Action: Codable {
    case nothing,
         win,
         lose,
         goToLevel(destination: Int),
         updateLogics(logics: [String:Int])
}
