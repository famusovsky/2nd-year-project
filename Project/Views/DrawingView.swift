//
//  DrawingView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-30.
//

import Foundation
import UIKit
import PencilKit

class DrawingView: UIView, PKCanvasViewDelegate {
    // TODO: save the drawing between sessions
    private let canvasView = PKCanvasView()
    private var isErasing = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.overrideUserInterfaceStyle = .light
        self.backgroundColor = .clear
        
        setUpCanvasView()
        setUpTogglePenButton()
        setUpCleanUpButton()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.backgroundColor = .clear
        
        setUpCanvasView()
        setUpTogglePenButton()
        setUpCleanUpButton()
    }
    
    private func setUpCanvasView() {
        canvasView.backgroundColor = .clear
        canvasView.delegate = self
        canvasView.drawingPolicy = .anyInput
        self.addSubview(canvasView)
        
        canvasView.pin(to: self)
    }
    
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        setNeedsDisplay()
    }
    
    @objc
    private func togglePen(_ sender: UIButton) {
        isErasing.toggle()
        sender.isSelected.toggle()
        
        canvasView.tool = isErasing ? PKEraserTool(.bitmap) : PKInkingTool(.pen)
    }
    
    @objc
    public func cleanUp() {
        canvasView.drawing = PKDrawing()
    }
    
    private func setUpTogglePenButton() {
        let togglePenButton = UIButton()
        
        togglePenButton.layer.cornerRadius = 12
        togglePenButton.backgroundColor = .clear
        togglePenButton.setHeight(48)
        togglePenButton.setWidth(48)
        togglePenButton.setTitle("✍🏻", for: .normal)
        togglePenButton.setTitle("🧽", for: .selected)
        
        togglePenButton.addTarget(self, action: #selector(togglePen(_:)), for: .touchUpInside)
        self.addSubview(togglePenButton)
        
        togglePenButton.pinTop(to: self, 5)
        togglePenButton.pinLeft(to: self, 5)
        
        togglePenButton.isEnabled = true
    }
    
    private func setUpCleanUpButton() {
        let cleanUpButton = UIButton()
        
        cleanUpButton.layer.cornerRadius = 12
        cleanUpButton.backgroundColor = .clear
        cleanUpButton.setHeight(48)
        cleanUpButton.setWidth(48)
        cleanUpButton.setTitle("🧹", for: .normal)
        
        cleanUpButton.addTarget(self, action: #selector(cleanUp), for: .touchUpInside)
        self.addSubview(cleanUpButton)
        
        cleanUpButton.pinTop(to: self, 5)
        cleanUpButton.pinLeft(to: self, 5 + 48 + 5)
        
        cleanUpButton.isEnabled = true
    }
}
