//
//  MenuViewController.swift
//  Project
//
//  Created by Алексей Степанов on 2023-05-09.
//

import Foundation
import UIKit

final class MenuViewController: UIViewController {
    private let label = UILabel()
    private let newGameButton = UIButton()
    private let continueGameButton = UIButton()
    private var levelList = LevelList()
    
    private var gameViewController: GameViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.hidesBackButton = true
        
        setUp()
    }
    
    private func setUp() {
        view.backgroundColor = .black
        
        // TODO: load game from file
        getGameData()
        
        setUpLabel()
        setUpNewGameButton()
        setUpContinueGameButton()
    }
    
    private func setUpLabel() {
        label.text = "Stereo"
        label.textColor = .white
        label.font = .boldSystemFont(ofSize: 56)
        
        view.addSubview(label)
        label.pin(to: view, [.right, .left])
        label.pinCenterX(to: view.centerXAnchor)
        label.pinCenterY(to: view.centerYAnchor, -1 * Int(view.bounds.midY) / 3)
        label.textAlignment = .center
    }
    
    private func setUpNewGameButton() {
        newGameButton.backgroundColor = .darkGray
        newGameButton.setTitle("New Game", for: .normal)
        newGameButton.setTitleColor(.white, for: .normal)
        newGameButton.titleLabel?.font = .systemFont(ofSize: 28)
        newGameButton.addTarget(self, action: #selector(newGame), for: .touchUpInside)
        
        view.addSubview(newGameButton)
        newGameButton.pin(to: view, [.right, .left])
        newGameButton.pinCenter(to: view)
        newGameButton.setHeight(Int(view.bounds.midY) / 8)
        continueGameButton.isEnabled = true
    }
    
    // TODO: check if there is a game to continue
    private func setUpContinueGameButton() {
        continueGameButton.backgroundColor = .darkGray
        continueGameButton.setTitle("Continue Game", for: .normal)
        continueGameButton.setTitleColor(.white, for: .normal)
        continueGameButton.titleLabel?.font = .systemFont(ofSize: 28)
        continueGameButton.addTarget(self, action: #selector(continueGame), for: .touchUpInside)
        
        view.addSubview(continueGameButton)
        continueGameButton.pin(to: view, [.right, .left])
        continueGameButton.pinCenterX(to: view.centerXAnchor)
        continueGameButton.pinTop(to: newGameButton.bottomAnchor, 28)
        continueGameButton.setHeight(Int(view.bounds.midY) / 8)
        continueGameButton.isEnabled = true
    }
    
    
    @objc
    private func newGame() {
        print("amogus")
        
        gameViewController = GameViewController(levelList: levelList, firstLevel: 0)
        
        navigationController?.pushViewController(gameViewController!, animated: true)
        // present(gameViewController!, animated: true, completion: nil)
    }
    
    @objc
    private func continueGame() {
        
    }
    
    private func getGameData() {
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        
        do {
            let directoryContents = try fileManager.contentsOfDirectory(at: bundleURL, includingPropertiesForKeys: nil)
            let jsonFiles = directoryContents.filter { $0.lastPathComponent.hasPrefix("level-") && $0.lastPathComponent.hasSuffix(".json") }
            
            let regex = try! NSRegularExpression(pattern: "level-(\\d+)\\.json")
            
            for file in jsonFiles {
                do {
                    let data = try Data(contentsOf: file, options: .mappedIfSafe)
                    if let jsonString = String(data: data, encoding: .utf8),
                       let levelModel = decodeFromJSON(jsonString, to: LevelModel.self) {
                        
                        let matches = regex.matches(in: file.lastPathComponent, range: NSRange(file.lastPathComponent.startIndex..., in: file.lastPathComponent))
                        if let levelNumber = (matches.map {
                            Int(file.lastPathComponent[Range($0.range(at: 1), in: file.lastPathComponent)!])!
                        }.first) {
                            levelList.addLevel(levelModel, levelNumber)
                        }
                    }
                } catch {
                    print("Error while getting data from the file \(file.relativePath):  \(error.localizedDescription)")
                }
            }
        } catch {
            print("Error while enumerating files \(bundleURL): \(error.localizedDescription)")
        }
    }
}

