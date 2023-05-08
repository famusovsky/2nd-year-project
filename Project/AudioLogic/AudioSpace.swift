//
//  AudioSpace.swift
//  Project
//
//  Created by Алексей Степанов on 07.05.2023.
//

class AudioSpace {
    private var sources: [AudioSource] = []
    
    
    private var userDirection: Direction = .north {
        didSet {
            sources.forEach({ $0.userDirection = self.userDirection })
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
        
        for sourceModel in level.getAudioSources() {
            addSource(AudioSource(sourceModel))
        }
        
        userDirection = level.getDirection()
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
            break
        case .goBack:
            moveTo(userDirection.opposite())
            break
        case .turnLeft:
            userDirection.turnLeft()
            break
        case .turnRight:
            userDirection.turnRight()
            break
        case .win:
            break
        case .lose:
            break
        case .goToLevel(_):
            break
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
