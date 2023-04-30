//
//  MapView.swift
//  Project
//
//  Created by Алексей Степанов on 2023-04-20.
//

import Foundation
import UIKit

class MapView: UIView {
    private var drawingView: DrawingView
    
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
        var prevTile: UIView? = nil
        for i in 0..<board.width * board.height {
            let tile = UIView()
            
            if let firstSubview = self.subviews.first {
                self.insertSubview(tile, belowSubview: firstSubview)
            } else {
                self.addSubview(tile)
            }
            
            switch board.getTile(i) {
            case .empty:
                tile.backgroundColor = .clear
            case .filled(_):
                tile.backgroundColor = .systemPurple
            }
            
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
    
    public func update(_ board: Board) {
        //        self.board = board
        self.subviews.forEach { $0.removeFromSuperview() }
        
        // drawingView.clearDrawing()
        self.addSubview(drawingView)
        drawingView.pin(to: self)
        
        setUp(board)
    }
}
