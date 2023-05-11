//
//  MapView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation
import UIKit

class MapView: UIView, LevelObserver {
    private var drawingView: DrawingView
    private var tilesView = UIView()
    
    override init(frame: CGRect) {
        drawingView = DrawingView()
        
        super.init(frame: frame)
        self.backgroundColor = .lightGray
    }
    
    required init?(coder: NSCoder) {
        drawingView = DrawingView()
        
        super.init(coder: coder)
        self.backgroundColor = .lightGray
    }
    
    private func setUp(_ board: Board) {
        tilesView.pin(to: self)
        
        var prevTile: UIView? = nil
        
        for i in 0..<board.width * board.height {
            let tile = UIView()
            
            tilesView.addSubview(tile)
            
            switch board.getTile(i) {
            case .empty:
                tile.backgroundColor = .clear
            case .filled(_):
                tile.backgroundColor = .darkGray
            }
            tile.layer.borderWidth = 1
            tile.layer.borderColor = UIColor.black.cgColor
            
            if i != 0 {
                if i % board.width == 0 {
                    tile.pinTop(to: prevTile!.bottomAnchor)
                    tile.pinLeft(to: self)
                } else {
                    tile.pinTop(to: prevTile!)
                    tile.pinLeft(to: prevTile!.trailingAnchor)
                }
            } else {
                tile.pinTop(to: self)
                tile.pinLeft(to: self)
            }
            
            tile.pinHeight(to: self, 1 / CGFloat(board.height))
            tile.pinWidth(to: self, 1 / CGFloat(board.width))
            
            prevTile = tile
        }
    }
    
    public func updateByLevel(_ level: Level) {
        update(level.getBoard())
    }
    
    private func update(_ board: Board) {
        self.subviews.forEach { $0.removeFromSuperview() }
        setUpTilesView()
        setUpDrawingView()
        
        setUp(board)
    }
    
    private func setUpTilesView() {
        tilesView = UIView()
        
        // TODO: MINOR make tiles square
        self.addSubview(tilesView)
        tilesView.pin(to: self)
    }
    
    private func setUpDrawingView() {
        drawingView.cleanUp()
        
        self.addSubview(drawingView)
        drawingView.pin(to: self)
    }
}
