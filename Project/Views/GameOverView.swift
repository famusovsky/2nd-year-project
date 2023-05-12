//
//  GameOverView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-12.
//

import Foundation
import UIKit

class GameOverView: UIView, GameResultsObserver {
    private let gameOverLabel = UILabel()
    private let textLabel = UILabel()
    private var mainMenuButton = UIButton()
    private var endDelegate: GameResultsObserver?
    
    private var tips: [String] = []
    private var current: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    public func setGameResultsObserver(_ observer: GameResultsObserver) {
        endDelegate = observer
    }
    
    private func setUp() {
        backgroundColor = .black
        
        setUpMainMenuButton()
        setUpGameOverLabel()
        setUpTextLabel()
    }
    
    private func setUpMainMenuButton() {
        mainMenuButton.setTitle("Back to Main Menu", for: .normal)
        mainMenuButton.setTitleColor(.orange, for: .normal)
        mainMenuButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        mainMenuButton.addAction(UIAction(handler: { _ in
            self.isHidden = true
            
            self.endDelegate?.reactToGameResult(.end)
        }), for: .touchUpInside)
        
        self.addSubview(mainMenuButton)
        
        mainMenuButton.pinCenterX(to: self)
        mainMenuButton.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor)
        mainMenuButton.pinHeight(to: self, 1 / 8)
        mainMenuButton.pinWidth(to: self, 1 / 2)
    }
    
    private func setUpGameOverLabel() {
        gameOverLabel.textColor = .orange
        gameOverLabel.text = "The Game Is Over"
        gameOverLabel.font = .boldSystemFont(ofSize: 36)
        gameOverLabel.numberOfLines = 2
        gameOverLabel.textAlignment = .center
        self.addSubview(gameOverLabel)
        
        gameOverLabel.pin(to: self, [(.left, 15), (.right, -15)])
        gameOverLabel.pinTop(to: self.safeAreaLayoutGuide.topAnchor)
        gameOverLabel.pinHeight(to: self, 1 / 6)
    }
    
    private func setUpTextLabel() {
        textLabel.textColor = .white
        textLabel.numberOfLines = 0
        textLabel.lineBreakMode = .byWordWrapping
        textLabel.font = .boldSystemFont(ofSize: 16)
        self.addSubview(textLabel)
        
        textLabel.pin(to: self, [(.left, 15), (.right, -15)])
        textLabel.pinTop(to: gameOverLabel.bottomAnchor)
        textLabel.pinBottom(to: mainMenuButton.topAnchor)
    }
    
    func reactToGameResult(_ gameResult: GameResult) {
        switch gameResult {
        case .win(let text):
            if gameOverLabel.text != nil {
                gameOverLabel.text! += "\nYou won!"
            } else {
                gameOverLabel.text = "You won!"
            }
            textLabel.text = text
            
            self.isHidden = false
        case .lose(let text):
            if gameOverLabel.text != nil {
                gameOverLabel.text! += "\nYou lose!"
            } else {
                gameOverLabel.text = "You lose!"
            }
            textLabel.text = text
            
            self.isHidden = false
        case .end:
            break
        }
    }
}
