//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion

// TODO: create a menu viewcontroller

final class GameViewController: UIViewController {
    private let mapView = MapView()
    private let gameUIView = GameUIView()
    private let pictureView = PictureView()
    private let audio = AudioSpace()
    private let headphoneMotionManager = CMHeadphoneMotionManager()
    private var game: GameLogics? = nil
    private var levelList = LevelList()
    private var firstLevel = 0
    
    convenience init(levelList: LevelList = LevelList(), firstLevel: Int = 0) {
        self.init()
        
        self.levelList = levelList
        self.firstLevel = firstLevel
        
        game = GameLogics(levelList)
        game?.setTileObserver(gameUIView)
        game?.setLevelObserver(mapView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        // TODO: change
        audio.setLevelList(levelList)
        audio.updateByLevelIndex(firstLevel)
        
        setupPictureView()
        setupGameUIView()
        setupMapView()
        setupView()
        
        if headphoneMotionManager.isDeviceMotionAvailable {
            NotificationCenter.default.addObserver(self, selector: #selector(handleRouteChange), name: AVAudioSession.routeChangeNotification, object: nil)
            
            headphoneMotionManagerTryConnect()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    private func processData(_ data: CMDeviceMotion) {
        let angle = CGFloat(data.attitude.yaw)
        audio.userAngle = angle
    }
    
    private func setupView() {
        view.backgroundColor = .black
        
        setUpMapButton()
    }
    
    private func setupPictureView() {
        view.addSubview(pictureView)
        
        pictureView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        pictureView.pin(to: view, [(.left, 15), (.right, -15)])
        pictureView.pinBottom(to: view.safeAreaLayoutGuide.bottomAnchor)
        
        if game != nil {
            game?.setTileObserver(pictureView)
        }
        
        pictureView.isHidden = false
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

extension GameViewController {
    @objc
    func handleRouteChange(notification: Notification) {
        guard let userInfo = notification.userInfo,
              let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
              let reason = AVAudioSession.RouteChangeReason(rawValue: reasonValue) else {
            return
        }
        
        switch reason {
        case .newDeviceAvailable:
            headphoneMotionManagerTryConnect()
        case .oldDeviceUnavailable:
            headphoneMotionManagerDisconnect()
        default:
            break
        }
    }
    
    func headphoneMotionManagerTryConnect() {
        if headphoneMotionManager.isDeviceMotionAvailable {
            let audioSession = AVAudioSession.sharedInstance()
            let outputs = audioSession.currentRoute.outputs
            var isSpatialAudioAvialible = false
            for output in outputs {
                if output.portType == AVAudioSession.Port.bluetoothA2DP {
                    isSpatialAudioAvialible = true
                    break
                }
            }
            
            if isSpatialAudioAvialible {
                headphoneMotionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler: {
                    [weak self] motion, error  in
                    guard let motion = motion, error == nil else { return }
                    self?.processData(motion)
                })
            }
        }
    }
    
    func headphoneMotionManagerDisconnect() {
        if headphoneMotionManager.isDeviceMotionActive {
            headphoneMotionManager.stopDeviceMotionUpdates()
            
            audio.userAngle = 0
        }
    }
}
