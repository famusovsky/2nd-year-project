//
//  GameResultsView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-10.
//

import Foundation

enum GameResult {
    case win,
         lose,
         end
}

protocol GameResultsObserver {
    func reactToGameResult(_ gameResult: GameResult)
}
