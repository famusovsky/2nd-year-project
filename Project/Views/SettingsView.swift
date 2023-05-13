//
//  SettingView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-09.
//

import Foundation
import UIKit

class SettingsView: UIView {
    private var saveDalegate: SaveDelegate?
    private var endDelegate: GameResultsObserver?
    
    private let levelChooseView = LevelChooseView()
    private let saveButton = UIButton()
    private let mainMenuButton = UIButton()
    private let levelChooseButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .black
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        backgroundColor = .black
        
        setUp()
    }
    
    public func setLoadGameSessionObserver(_ observer: IntegerChoiceObserver) {
        levelChooseView.setObserver(observer)
    }
    
    public func setEndDelegate(_ delegate: GameResultsObserver) {
        endDelegate = delegate
    }
    
    public func setSaveDelegate(_ delegate: SaveDelegate) {
        saveDalegate = delegate
    }
    
    private func setUp() {
        setUpSaveButton()
        setUpLevelChooseButton()
        setUpMainMenuButton()
        
        setUpLevelChooseView()
    }
    
    private func setUpSaveButton() {
        saveButton.backgroundColor = .darkGray
        saveButton.setTitle("Save current game", for: .normal)
        saveButton.setTitleColor(.white, for: .normal)
        saveButton.titleLabel?.font = .systemFont(ofSize: 28)
        
        saveButton.addAction(UIAction(handler: { _ in
            self.saveDalegate?.save()
        }), for: .touchUpInside)
        
        self.addSubview(saveButton)
        saveButton.pin(to: self, [.right, .left])
        saveButton.pinCenter(to: self)
        saveButton.pinHeight(to: self, 1 / 8)
    }
    
    private func setUpLevelChooseView() {
        self.addSubview(levelChooseView)
        
        levelChooseView.isHidden = true
        levelChooseView.pin(to: self)
    }
    
    private func setUpLevelChooseButton() {
        levelChooseButton.backgroundColor = .darkGray
        levelChooseButton.setTitle("Choose saved game", for: .normal)
        levelChooseButton.setTitleColor(.white, for: .normal)
        levelChooseButton.titleLabel?.font = .systemFont(ofSize: 28)
        
        levelChooseButton.addAction(UIAction(handler: { _ in
            self.levelChooseView.update()
            self.levelChooseView.isHidden = false
        }), for: .touchUpInside)
        
        self.addSubview(levelChooseButton)
        levelChooseButton.pin(to: self, [.right, .left])
        levelChooseButton.pinTop(to: saveButton.bottomAnchor, 25)
        levelChooseButton.pinHeight(to: self, 1 / 8)
    }
    
    private func setUpMainMenuButton() {
        mainMenuButton.setTitle("Back to Main Menu", for: .normal)
        mainMenuButton.setTitleColor(.white, for: .normal)
        mainMenuButton.titleLabel?.font = .systemFont(ofSize: 16)
        
        mainMenuButton.addAction(UIAction(handler: { _ in
            self.isHidden = true
            
            self.endDelegate?.reactToGameResult(.end)
        }), for: .touchUpInside)
        
        self.addSubview(mainMenuButton)
        mainMenuButton.pinCenterX(to: self)
        mainMenuButton.pinTop(to: self)
        mainMenuButton.pinHeight(to: self, 1 / 8)
        mainMenuButton.pinWidth(to: self, 1 / 2)
    }
}
