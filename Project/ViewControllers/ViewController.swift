//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation
import UIKit

final class ViewController: UIViewController {
    private var board: Board? = nil
    let mapView = MapView()
    let gameUIView = GameUIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: load game from file
        let str = """
                {
                "width":2,
                "height":2,
                "field":[{"empty":{}},{"filled":{"room":{"data":[]}}},{"filled":{"room":{"data":[]}}},{"empty":{}}],
                }
                """
        board = Board(str)
        
        setupGameUIView()
        setupMapView()
        
        setupView()
    }
    
    /*override func viewWillAppear(_ animated: Bool) {
     super.viewDidAppear(animated)
     
     setupView()
     }*/
    
    private func setupView() {
        // TODO: setup main view
        view.backgroundColor = .systemBackground
        
        setUpMapButton()
    }
    
    private func setupGameUIView() {
        gameUIView.setUp()
        
        view.addSubview(gameUIView)
        
        gameUIView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        gameUIView.pin(to: view, [(.left, 15), (.right, -15)])
        gameUIView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        gameUIView.isHidden = false
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        mapView.pin(to: view, [(.left, 15), (.right, -15)])
        mapView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        if let board = board {
            mapView.update(board)
        }
        
        mapView.isHidden = true
    }
    
    private func setUpMapButton() {
        let mapButton = UIButton()
        
        mapButton.layer.cornerRadius = 12
        mapButton.backgroundColor = .clear
        mapButton.setHeight(48)
        mapButton.setWidth(48)
        mapButton.setTitle("🗺️", for: .normal)
        
        mapButton.addTarget(self, action: #selector(mapButtonPressed), for: .touchUpInside)
        view.addSubview(mapButton)
        
        mapButton.pinTop(to: mapView.topAnchor, 5)
        mapButton.pinRight(to: mapView, -5)
        
        mapButton.isEnabled = true
    }
    
    @objc
    private func mapButtonPressed() {
        mapView.isHidden.toggle()
    }
}

extension ViewController {
    public func printCodable(codable: Codable) {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let jsonData = try encoder.encode(codable)
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                print(jsonString)
            }
        } catch {
            print(error.localizedDescription)
        }
    }
}
