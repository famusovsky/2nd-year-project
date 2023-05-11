//
//  GameData.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-11.
//

import Foundation

struct GameData: Codable {
    let index: Int
    let levels: [Int : LevelModel]
}
