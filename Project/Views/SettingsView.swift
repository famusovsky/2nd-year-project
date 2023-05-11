//
//  SettingView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-09.
//

import Foundation
import UIKit

class SettingsView: UIView {
    private let label = UILabel()
    private var saveDalegate: SaveDelegate?
    private var endDelegate: GameResultsObserver?
    
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
    
    public func setEndDelegate(_ delegate: GameResultsObserver) {
        endDelegate = delegate
    }
    
    public func setSaveDelegate(_ delegate: SaveDelegate) {
        saveDalegate = delegate
    }
    
    private func setUp() {
        setUpSaveButton()
        
        setUpMainMenuButton()
    }
    
    private func setUpSaveButton() {
        let button = UIButton()
        button.backgroundColor = .darkGray
        button.setTitle("Save current game", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 28)
        
        button.addAction(UIAction(handler: { _ in
            self.saveDalegate?.save()
        }), for: .touchUpInside)
        
        self.addSubview(button)
        button.pin(to: self, [.right, .left])
        button.pinCenter(to: self)
        button.pinHeight(to: self, 1 / 8)
        button.isEnabled = true
    }
    
    private func setUpMainMenuButton() {
        let button = UIButton()
        button.setTitle("Back to Main Menu", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16)
        
        button.addAction(UIAction(handler: { _ in
            self.isHidden = true
            
            self.endDelegate?.reactToGameResult(.end)
        }), for: .touchUpInside)
        
        self.addSubview(button)
        button.pin(to: self, [.right, .left])
        button.pinTop(to: self)
        button.pinHeight(to: self, 1 / 8)
    }
}

