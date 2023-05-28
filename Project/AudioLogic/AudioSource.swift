//
//  AudioSource.swift
//  Project
//
//  Created by Алексей Степанов on 07.05.2023.
//

import AVFoundation

struct AudioSourceModel: Codable {
    var audio: AudioFile
    var coordinate: Coordinate
    var range: Double
}

class AudioSource {
    private var model: AudioSourceModel
    
    public var userDirection: Direction = .north {
        didSet {
            self.updateAudio()
        }
    }
    
    public var userAngle: CGFloat = 0 {
        didSet {
            self.updateAudio()
        }
    }
    
    public func getX() -> Int {
        return model.coordinate.x
    }
    
    public func getY() -> Int {
        return model.coordinate.y
    }
    
    public func getName() -> String {
        return model.audio.name
    }
    
    public init(_ audio: AudioFile, _ point: Coordinate, _ range: Double) {
        self.model = AudioSourceModel(audio: audio, coordinate: point, range: range)
        
        self.runAudio()
        
        self.updateAudio()
    }
    
    public init(_ model: AudioSourceModel) {
        self.model = model
        
        self.runAudio()
        
        self.updateAudio()
    }
    
    public func applyNewCoordinate(_ soundCoordinate: Coordinate) {
        model.coordinate = soundCoordinate
        
        self.updateAudio()
    }
    
    var distance: Double {
        if model.coordinate.x == model.coordinate.y && model.coordinate.x == 0 {
            return 0
        }
        
        var xRelativeToTheUser = Double(model.coordinate.x)
        var yRelativeToTheUser = Double(model.coordinate.y)
        
        switch userDirection {
        case .north:
            yRelativeToTheUser -= 0.15
        case .east:
            xRelativeToTheUser -= 0.15
        case .south:
            yRelativeToTheUser += 0.15
        case .west:
            xRelativeToTheUser += 0.15
        }
        
        return sqrt(xRelativeToTheUser * xRelativeToTheUser + yRelativeToTheUser * yRelativeToTheUser)
    }
    
    private var volume: Double {
        let distance = self.distance
        if distance > model.range {
            return model.range / distance * 0.05
        }
        return max(1 - distance / model.range, 0.05)
    }
    
    private var player: AVAudioPlayer?
    private var timer: Timer?
    
    private func runAudio() {
        guard let url = Bundle.main.url(forResource: model.audio.name, withExtension: model.audio.file.rawValue) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: model.audio.file.type.rawValue)
            self.player?.isMeteringEnabled = true
            
            guard let player = self.player else { return }
            
            player.numberOfLoops = -1
            player.volume = 0
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    public func stopAudio() {
        self.player?.stop()
        self.timer?.invalidate()
    }
    
    private func updateAudio() {
        var angle = atan2(Double(model.coordinate.y), Double(model.coordinate.x))
        let volume = self.volume

        switch userDirection {
        case .east:
            angle += Double.pi / 2
        case .west:
            angle -= Double.pi / 2
        case .north:
            angle += 2 * Double.pi
        case .south:
            angle -= Double.pi
        }
        
        angle -= userAngle

        let normDeg = (angle * CGFloat(180.0 / Double.pi) + 360).truncatingRemainder(dividingBy: 360)
        let result: CGFloat
        
        if normDeg > 270 || normDeg < 90 {
            let value = (180 - abs(normDeg - 180)) / 90
            result = 1 - value
        } else {
            let value = abs(normDeg - 180) / 90
            result = -1 + value
        }
        
        player?.pan = Float(result - result * pow(volume, 3))
        player?.setVolume(Float(volume), fadeDuration: 1)
    }
}

