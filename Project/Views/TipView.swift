//
//  TipView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-12.
//

import Foundation
import UIKit

class TipView: UIView {
    private let closeButton = UIButton()
    private let nextButton = UIButton()
    private let previousButton = UIButton()
    private let tipLabel = UILabel()
    
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
    
    private func setUp() {
        backgroundColor = .black
        
        setUpTipLabel()
        setUpNextButton()
        setUpPreviousButton()
        setUpCloseButton()
    }
    
    private func setUpTipLabel() {
        tipLabel.textColor = .white
        tipLabel.numberOfLines = 0
        tipLabel.lineBreakMode = .byWordWrapping
        self.addSubview(tipLabel)
        
        tipLabel.pin(to: self, [(.left, 15), (.right, -15)])
        tipLabel.pinTop(to: self.safeAreaLayoutGuide.topAnchor, 30)
        tipLabel.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor, -60)
    }
    
    private func setUpNextButton() {
        nextButton.setTitle("Next tip", for: .normal)
        nextButton.setTitleColor(.orange, for: .normal)
        nextButton.backgroundColor = .clear
        nextButton.addAction(UIAction(handler: { _ in
            if self.current + 1 < self.tips.count {
                self.current += 1
            }
            self.update()
        }), for: .touchUpInside)
        
        self.addSubview(nextButton)
        nextButton.pinRight(to: self)
        nextButton.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor)
        nextButton.pinWidth(to: self, 1 / 2)
        nextButton.setHeight(60)
    }
    
    private func setUpPreviousButton() {
        previousButton.setTitle("Previous tip", for: .normal)
        previousButton.setTitleColor(.orange, for: .normal)
        previousButton.backgroundColor = .clear
        previousButton.addAction(UIAction(handler: { _ in
            if self.current - 1 >= 0 {
                self.current -= 1
            }
            self.update()
        }), for: .touchUpInside)
        
        self.addSubview(previousButton)
        previousButton.pinLeft(to: self)
        previousButton.pinBottom(to: self.safeAreaLayoutGuide.bottomAnchor)
        previousButton.pinWidth(to: self, 1 / 2)
        previousButton.setHeight(60)
    }
    
    private func setUpCloseButton() {
        closeButton.setTitle("X", for: .normal)
        closeButton.setTitleColor(.orange, for: .normal)
        closeButton.backgroundColor = .black
        closeButton.addAction(UIAction(handler: { _ in
            self.isHidden = true
        }), for: .touchUpInside)
        
        self.addSubview(closeButton)
        closeButton.pinTop(to: self.safeAreaLayoutGuide.topAnchor)
        closeButton.pinRight(to: self.safeAreaLayoutGuide.trailingAnchor)
        closeButton.setWidth(25)
        closeButton.setHeight(25)
    }
    
    public func showTips(_ tips: [String]) {
        self.tips = tips
        current = 0
        
        update()
        
        self.isHidden = false
    }
    
    private func update() {
        tipLabel.text = tips[current]
        
        nextButton.isHidden = current + 1 >= tips.count
        previousButton.isHidden = current - 1 < 0
    }
}

extension TipView: StringsPresenterDelegate {
    func presentStrings(_ strings: [String]) {
        showTips(strings)
    }
}
