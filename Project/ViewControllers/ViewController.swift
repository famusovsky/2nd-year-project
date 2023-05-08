//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation
import UIKit

final class ViewController: UIViewController {
    private let mapView = MapView()
    private let gameUIView = GameUIView()
    // private var board: Board? = nil
    private let audio = AudioSpace()
    private var game: GameLogics? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var levelModel = LevelModel()
        
        // TODO: load game from file
        if let path = Bundle.main.path(forResource: "level", ofType: "json") {
            print("yes")
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                if let jsonString = String(data: data, encoding: .utf8) {
                    levelModel = decodeFromJSON(jsonString, to: LevelModel.self) ?? LevelModel()
                }
            } catch {
                // Handle error
                print(error)
            }
        } else {
            print("no")
        }
        
        let levels: [Level] = [Level(levelModel)]
        
        printCodable(codable: levelModel)
        
        game = GameLogics(levels)
        game?.setTileObserver(gameUIView)
        game?.setLevelObserver(mapView)
        
        setupPictureView()
        // TODO: change
        audio.updateByLevel(levels.first!)
        setupGameUIView()
        setupMapView()
        
        setupView()
    }
    
    private func setupView() {
        // TODO: setup main view
        view.backgroundColor = .systemBackground
        
        setUpMapButton()
    }
    
    private func setupGameUIView() {
        view.addSubview(gameUIView)
        
        gameUIView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        gameUIView.pin(to: view, [(.left, 15), (.right, -15)])
        gameUIView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        if game != nil {
            gameUIView.setActionExecutor(game!)
        }
        gameUIView.setActionExecutor(audio)
        
        gameUIView.isHidden = false
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        mapView.pin(to: view, [(.left, 15), (.right, -15)])
        mapView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
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
