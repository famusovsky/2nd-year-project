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
            self.updateAudioResult()
        }
    }
    
    public func getX() -> Int {
        return model.coordinate.x
    }
    
    public func getY() -> Int {
        return model.coordinate.y
    }
    
    public init(_ audio: AudioFile, _ point: Coordinate, _ range: Double, _ addAnimation: Bool = true) {
        model = AudioSourceModel(audio: audio, coordinate: point, range: range /*, addAnimation: addAnimation */)
        
        self.runAudio()
        
        self.updateAudioResult()
        self.updateVolume()
    }
    
    public init(_ model: AudioSourceModel) {
        self.model = model
        
        self.runAudio()
        
        self.updateAudioResult()
        self.updateVolume()
    }
    
    public func applyNewCoordinate(_ soundCoordinate: Coordinate) {
        model.coordinate = soundCoordinate
        
        self.updateAudioResult()
        self.updateVolume()
    }
    
    var player: AVAudioPlayer?
    
    var distance: CGFloat {
        return sqrt(CGFloat(model.coordinate.x * model.coordinate.x + model.coordinate.y * model.coordinate.y))
    }
    
    var volume: CGFloat {
        let distance = self.distance
        var volumeValue = max((1 - (max(distance, 0.2) - 0.2)), 0)
        volumeValue = max(volumeValue, 0.05)
        return volumeValue
    }
    
    var timer: Timer?
    
    func stopAudio() {
        self.player?.stop()
        self.timer?.invalidate()
    }
    
    func runAudio() {
        guard let url = Bundle.main.url(forResource: model.audio.name, withExtension: model.audio.file.rawValue) else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            self.player = try AVAudioPlayer(contentsOf: url, fileTypeHint: model.audio.file.type.rawValue)
            self.player?.isMeteringEnabled = true
            
            guard let player = self.player else { return }
            
            player.numberOfLoops = -1
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
        
        self.timer = Timer(timeInterval: 0.3, repeats: true) { _ in
            self.player?.updateMeters()
            // TODO: what is it?
            let power = self.averagePowerFromAllChannels()
        }
        RunLoop.current.add(self.timer!, forMode: .common)
    }
    
    func updateVolume() {
        player?.volume = Float(self.volume)
    }
    
    // DONE? TODO: change
    func updateAudioResult() {
        player?.pan = Float(audioResult())
    }
    
    private func averagePowerFromAllChannels() -> CGFloat {
        guard let player = self.player else {
            return 0
        }
        
        var power: CGFloat = 0.0
        (0..<player.numberOfChannels).forEach { (index) in
            power = power + CGFloat(player.averagePower(forChannel: index))
        }
        return power / CGFloat(player.numberOfChannels)
    }
    
    func audioResult() -> CGFloat {
        var angle = atan2(Double(model.coordinate.y), Double(model.coordinate.x))

        switch userDirection {
        case .east:
            angle += Double.pi / 2
        case .west:
            angle -= Double.pi / 2
        case .north:
            angle -= Double.pi
        case .south:
            break
        }

        let deg = angle * CGFloat(180.0 / Double.pi)
        let normDeg = (deg + 360).truncatingRemainder(dividingBy: 360)

        let result: CGFloat
        if normDeg > 270 || normDeg < 90 {
            let value = (180 - abs(normDeg - 180)) / 90
            result = 1 - value
        } else {
            let value = abs(normDeg - 180) / 90
            result = -1 + value
        }

        return normalizeAudioResultByVolume(result: result)
    }
    
    private func normalizeAudioResultByVolume(result: CGFloat) -> CGFloat {
        let volume = self.volume
        return result - result * pow(volume, 3)
    }
}

