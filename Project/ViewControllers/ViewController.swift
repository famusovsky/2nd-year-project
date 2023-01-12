//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation
import UIKit

final class ViewController: UIViewController {
    private var board: Board? = nil
    let mapView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()

        let str = """
                  {"width":2,"field":[{"empty":{}},{"room":{"_0":[0,{}]}},{"room":{"_0":[0,{}]}},{"empty":{}}],"height":2}
                  """
        board = Board(JSON: str)
        
        mapView.isHidden = true
        view.addSubview(mapView)
        setupView()
        setupMapView()
    }

    /*override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setupView()
    }*/

    private func setupView() {
        view.backgroundColor = .systemBackground
    }

    private func setupUI() {

    }

    private func setupMapView() {
        mapView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        mapView.pin(to: view, [(.left, 15), (.right, -15)])
        mapView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)

        if let board = board {
            var prevTile: UIView? = nil
            for i in 0..<board.getWidth() * board.getHeight() {
                print(i)

                let tile = UIView()
                mapView.addSubview(tile)

                switch board.getTile(i) {
                case .empty:
                    tile.backgroundColor = .systemYellow
                case .room(_):
                    tile.backgroundColor = .systemPurple
                }

                if i != 0 {
                    if i % board.getWidth() == 0 {
                        tile.pinTop(to: prevTile!.bottomAnchor)
                        tile.pinLeft(to: mapView)
                    } else {
                        tile.pinTop(to: prevTile!)
                        tile.pinLeft(to: prevTile!.trailingAnchor)
                    }
                } else {
                    tile.pinTop(to: mapView)
                    tile.pinLeft(to: mapView)
                }

                tile.pinHeight(to: mapView, 1 / CGFloat(board.getHeight()))
                tile.pinWidth(to: mapView, 1 / CGFloat(board.getWidth()))

                prevTile = tile
            }
        }
    }

    public func updateMap(_ board: Board) {
        self.board = board
        view.subviews.forEach { $0.removeFromSuperview() }

        setupMapView()
    }
}
