//
//  LevelChooseView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-09.
//

import Foundation
import UIKit

class LevelChooseView: UIView {
    private var observers: [IntegerChoiceObserver] = []
    private let label = UILabel()
    private let closeButton = UIButton()
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        setUp()
    }
    
    private func setUp() {
        backgroundColor = .black
        
        setUpScrollView()
        setUpContentView()
        setUpCloseButton()
        setUpLabel()
    }
    
    private func setUpScrollView() {
        addSubview(scrollView)
        scrollView.backgroundColor = .clear
        scrollView.pin(to: self)
        
        scrollView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        scrollView.isScrollEnabled = true
    }
    
    private func setUpContentView() {
        scrollView.addSubview(contentView)
        contentView.backgroundColor = .clear
        contentView.pin(to: scrollView, [.left, .right])
        contentView.pinCenterX(to: scrollView)
    }
    
    private func setUpCloseButton() {
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = .black
        closeButton.addAction(UIAction(handler: { _ in
            self.isHidden = true
        }), for: .touchUpInside)
        
        self.addSubview(closeButton)
        closeButton.pinTop(to: self)
        closeButton.pinRight(to: self.safeAreaLayoutGuide.trailingAnchor)
        closeButton.setWidth(25)
        closeButton.setHeight(25)
    }
    
    private func setUpLabel() {
        label.textColor = .white
        label.text = "No saved games"
        self.addSubview(label)
        label.pinCenterX(to: self)
        label.pinTop(to: self)
        label.pinRight(to: closeButton.leadingAnchor)
        label.setHeight(25)
    }
    
    public func setObserver(_ observer: IntegerChoiceObserver) {
        observers.append(observer)
    }
    
    public func update() {
        let defaults = UserDefaults.standard
        label.isHidden = false
        contentView.subviews.forEach { $0.removeFromSuperview() }
        
        if var savedGames = defaults.stringArray(forKey: "savedGames") {
            if savedGames.count > 0 {
                contentView.setHeight(savedGames.count * 45 + 135)
                scrollView.contentSize.height = CGFloat(savedGames.count * 45 + 45)
                label.isHidden = true
                
                let deleteAll = UIButton()
                deleteAll.setTitle("DELETE ALL SAVED GAMES", for: .normal)
                deleteAll.setTitleColor(.orange, for: .normal)
                deleteAll.backgroundColor = .clear
                deleteAll.addAction(UIAction(handler: { _ in
                    savedGames.removeAll(keepingCapacity: false)
                    defaults.set(savedGames, forKey: "savedGames")
                    self.update()
                }), for: .touchUpInside)
                contentView.addSubview(deleteAll)
                deleteAll.pin(to: contentView, [.left, .right, .top])
                deleteAll.setHeight(45)
                
                for i in 0...(savedGames.count - 1) {
                    let name = decodeFromJSON(savedGames[i], to: GameData.self)?.name
                    
                    let chooseSavedGame = UIButton()
                    chooseSavedGame.setTitle("Saved game \(name ?? "№\(i)")", for: .normal)
                    chooseSavedGame.setTitleColor(.white, for: .normal)
                    chooseSavedGame.backgroundColor = .darkGray
                    chooseSavedGame.addAction(UIAction(handler: { _ in
                        self.pingAllObservers(i)
                        self.isHidden = true
                    }), for: .touchUpInside)
                    
                    let deleteSavedGame = UIButton()
                    deleteSavedGame.setTitle("X", for: .normal)
                    deleteSavedGame.setTitleColor(.orange, for: .normal)
                    deleteSavedGame.backgroundColor = .darkGray
                    deleteSavedGame.addAction(UIAction(handler: { _ in
                        savedGames.remove(at: i)
                        defaults.set(savedGames, forKey: "savedGames")
                        self.update()
                    }), for: .touchUpInside)
                    
                    contentView.addSubview(chooseSavedGame)
                    contentView.addSubview(deleteSavedGame)
                    
                    chooseSavedGame.pinLeft(to: contentView)
                    chooseSavedGame.pinRight(to: deleteSavedGame.leadingAnchor)
                    chooseSavedGame.setHeight(25)
                    chooseSavedGame.pinTop(to: contentView, i * 45 + 45)
                    
                    deleteSavedGame.pinRight(to: contentView)
                    deleteSavedGame.pinWidth(to: contentView, 1 / 4)
                    deleteSavedGame.setHeight(25)
                    deleteSavedGame.pinTop(to: contentView, i * 45 + 45)
                }
            }
        }
    }
    
    private func pingAllObservers(_ chosen: Int) {
        for observer in observers {
            observer.updateByChoice(chosen)
        }
    }
}
