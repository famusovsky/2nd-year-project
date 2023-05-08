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
    
//    public func applyFrom(_ soundCoordinate: Coordinate, _ width: Int, _ height: Int) {
//        let x = soundCoordinate.x / width
//        let y = soundCoordinate.y / height
//        model.coordinate = Coordinate(x: x, y: y)
//
//        self.updateAudioResult()
//        self.updateVolume()
//    }
    
    public func applyNewCoordinate(_ soundCoordinate: Coordinate) {
        model.coordinate = soundCoordinate
        
        self.updateAudioResult()
        self.updateVolume()
    }
    
    //  ??? DO I NEED IT ???
//    var getVectorOnCircle: Vector2D {
//        return Vector2D(
//            (Double(model.coordinate.x) - 0.5) * 2,
//            (Double(model.coordinate.y) - 0.5) * 2
//        )
//    }
    
    //    // DELETED TODO: update corresponding to the player's position on the board
    //    var userVector: Vector2D {
    //        var vector = Vector2D(1, 0)
    //        vector = vector.rotated(by: -self.yaw)
    //        return vector
    //    }
    
    var player: AVAudioPlayer?
    
    // DONE TODO: считать через coordinate + userCoordinate
    var distance: CGFloat {
        //        let vector = self.getVectorOnCircle
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
            let power = self.averagePowerFromAllChannels()
            let value = (160 + power)
            // print(value)
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
    
    // DONE? TODO: считать через coordinate и userCoordinate
    func audioResult() -> CGFloat {
        var angle = atan2(Double(model.coordinate.y), Double(model.coordinate.x))
        
        switch userDirection {
        case .north:
            angle += Double.pi / 2
        case .east:
            break
        case .south:
            angle += Double.pi / 2 * 3
        case .west:
            angle += Double.pi
        }
        
        var deg = angle * CGFloat(180.0 / Double.pi)
        deg = abs(deg)
        
        let result: CGFloat
        if deg > 90 {
            let value = (180 - deg) / 90
            result = -1 + value
        } else {
            let value = deg / 90
            result = 1 - value
        }
        
        return self.normalizeAudioResultByVolume(result: result)
    }
    
    private func normalizeAudioResultByVolume(result: CGFloat) -> CGFloat {
        let volume = self.volume
        return result - result * pow(volume, 3)
    }
}

