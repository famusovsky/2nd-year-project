//
//  AudioSpace.swift
//  Project
//
//  Created by Алексей Степанов on 07.05.2023.
//

import Foundation

class AudioSpace {
    private var sources: [AudioSource] = []
    
    private var levelList: LevelList?
    private var currentLevel: Int?
    
    private var currentXMove = 0
    private var currentYMove = 0
    
    public func setLevelList(_ levelList: LevelList) {
        self.levelList = levelList
    }
    
    private var userDirection: Direction = .north {
        didSet {
            sources.forEach({ $0.userDirection = self.userDirection })
        }
    }
    
    public var userAngle: CGFloat = 0 {
        didSet {
            sources.forEach({ $0.userAngle = self.userAngle })
        }
    }
    
    public func updateByLevel(_ level: Level) {
        while !sources.isEmpty {
            sources.first!.stopAudio()
            sources.removeFirst()
        }
        
        currentXMove = -1 * level.getCoordinate().x
        currentYMove = -1 * level.getCoordinate().y
        
        userDirection = level.getDirection()
        
        for sourceModel in level.getAudioSources() {
            addSource(AudioSource(sourceModel))
        }
    }
    
    public func updateByLevelIndex(_ index: Int) {
        currentLevel = index
        updateByLevel(levelList?.getLevel(index) ?? Level())
    }
    
    public func update() {
        updateByLevel(levelList?.getLevel(currentLevel ?? 0) ?? Level())
    }
    
    private func addSource(_ audioSource: AudioSource) {
        sources.append(audioSource)
        
        let newCoordinate = Coordinate(x: audioSource.getX() + currentXMove, y: audioSource.getY() + currentYMove)
        audioSource.applyNewCoordinate(newCoordinate)
        
        audioSource.userDirection = userDirection
    }
    
    private func removeSource(_ audioSource: AudioSource) {
        if let index = sources.firstIndex(where: { $0 === audioSource }) {
            audioSource.stopAudio()
            sources.remove(at: index)
        }
    }
}

extension AudioSpace: ActionExecutor {
    func doActions(_ actions: [Action]) {
        for action in actions {
            doAction(action)
        }
    }
    
    func doAction(_ action: Action) {
        switch action {
        case .goForward:
            moveTo(userDirection)
        case .goBack:
            moveTo(userDirection.opposite())
        case .turnLeft:
            userDirection.turnLeft()
        case .turnRight:
            userDirection.turnRight()
        case .win:
            break
        case .lose:
            break
        case .goToLevel(let destination):
            updateByLevelIndex(destination)
        case .updateLogics(let logics):
            for logic in logics {
                levelList?.getLevel(currentLevel ?? 0)?.updateLogic(logic.key, logic.value)
            }
            
            // TODO: not restart sources which are stay turned on
            update()
            break
        case .nothing:
            break
        }
        
        func moveTo(_ direction: Direction) {
            let xMovement = direction == .east ? -1 : direction == .west ? 1 : 0
            let yMovement = direction == .south ? 1 : direction == .north ? -1 : 0
            
            currentXMove += xMovement
            currentYMove += yMovement
            
            for source in sources {
                let newCoordinate = Coordinate(x: source.getX() + xMovement, y: source.getY() + yMovement)
                source.applyNewCoordinate(newCoordinate)
            }
        }
    }
}
