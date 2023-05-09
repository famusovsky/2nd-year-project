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
    
    private func addSource(_ audioSource: AudioSource) {
        sources.append(audioSource)
    }
    
    private func removeSource(_ audioSource: AudioSource) {
        if let index = sources.firstIndex(where: { $0 === audioSource }) {
            audioSource.stopAudio()
            sources.remove(at: index)
        }
    }
    
    public func updateByLevel(_ level: Level) {
        while !sources.isEmpty {
            sources.first!.stopAudio()
            sources.removeFirst()
        }
        
        let w = Double(level.getBoard().width)
        let h = Double(level.getBoard().height)
        let maxDistance = sqrt(w * w + h * h)
        
        for sourceModel in level.getAudioSources() {
            addSource(AudioSource(sourceModel, maxDistance))
        }
        
        userDirection = level.getDirection()
    }
    
    public func updateByLevelIndex(_ index: Int) {
        updateByLevel(levelList?.getLevel(index) ?? Level())
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
        case .updateLogics(_):
            break
        case .nothing:
            break
        }
        
        func moveTo(_ direction: Direction) {
            let xMovement = direction == .east ? -1 : direction == .west ? 1 : 0
            let yMovement = direction == .south ? 1 : direction == .north ? -1 : 0
            for source in sources {
                let newCoordinate = Coordinate(x: source.getX() + xMovement, y: source.getY() + yMovement)
                source.applyNewCoordinate(newCoordinate)
            }
        }
    }
}
