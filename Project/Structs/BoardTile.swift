//
//  BoardTile.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation

enum BoardTile: Codable {
    case empty,
         filled(room: Room)
}
