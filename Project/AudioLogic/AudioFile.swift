//
//  AudioFile.swift
//  Project
//
//  Created by Алексей Степанов on 07.05.2023.
//

import Foundation
import AVFoundation
import UIKit

struct AudioFile: Codable {
    enum File: String, Codable {
        case mp3
        case wav
        
        var type: AVFileType {
            switch self {
            case .mp3:
                return AVFileType.mp3
            case .wav:
                return AVFileType.wav
            }
        }
    }
    
    var name: String
    var file: File
    
    static var monkey: AudioFile {
        return AudioFile(name: "monkey", file: .mp3)
    }
}
