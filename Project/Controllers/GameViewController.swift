//
// Created by Алексей Степанов on 2023-01-11.
//

import Foundation
import UIKit
import AVFoundation
import CoreMotion

final class GameViewController: UIViewController, GameResultsObserver {
    private let mapView = MapView()
    private let gameUIView = GameUIView()
    private let pictureView = PictureView()
    private let settingsView = SettingsView()
    private let tipView = TipView()
    private let gameOverView = GameOverView()
    
    private var audio = AudioSpace()
    private let headphoneMotionManager = CMHeadphoneMotionManager()
    private var game: GameLogics? = nil
    private var levelList = LevelList()
    
    public var loadGameSessionObserver: IntegerChoiceObserver?
    
    convenience init(levelList: LevelList, firstLevel: Int, _ loadGameSessionObserver: IntegerChoiceObserver? = nil) {
        self.init()
        
        self.levelList = levelList
        
        game = GameLogics(levelList, firstLevel)
        self.loadGameSessionObserver = loadGameSessionObserver
        
        audio.setLevelList(levelList)
        audio.updateByLevelIndex(firstLevel)
    }
    
    convenience init(gameData: GameData, _ loadGameSessionObserver: IntegerChoiceObserver? = nil) {
        self.init()
        
        self.levelList.installGameData(gameData)
        let firstLevel = gameData.index
        
        game = GameLogics(levelList, firstLevel)
        self.loadGameSessionObserver = loadGameSessionObserver
        
        audio.setLevelList(levelList)
        audio.updateByLevelIndex(firstLevel)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        
        setupPictureView()
        setupGameUIView()
        setupMapView()
        setupView()
        setupSettingsView()
        setUpGameOverView()
        setUpTipView()
        
        game?.setTileObserver(gameUIView)
        game?.setLevelObserver(mapView)
        
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
        
        pictureView.pin(to: view)
        
        if game != nil {
            game?.setTileObserver(pictureView)
        }
        
        pictureView.isHidden = false
    }
    
    private func setupGameUIView() {
        view.addSubview(gameUIView)
        
        gameUIView.pin(to: view)
        
        if game != nil {
            gameUIView.setActionExecutor(game!)
        }
        gameUIView.setActionExecutor(audio)
        
        gameUIView.isHidden = false
    }
    
    private func setUpTipView() {
        view.addSubview(tipView)
        
        tipView.pin(to: view)
        
        tipView.isHidden = true
        
        game?.setStringsPresenterDelegate(tipView)
    }
    
    private func setUpGameOverView() {
        view.addSubview(gameOverView)
        
        gameOverView.pin(to: view)
        
        gameOverView.isHidden = true
        
        gameOverView.setGameResultsObserver(self)
        game?.setGameResultsObserver(gameOverView)
    }
    
    private func setupMapView() {
        view.addSubview(mapView)
        
        mapView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        mapView.pin(to: view, [.left, .right])
        mapView.pinBottom(to: view)
        
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
    }
    
    @objc
    private func mapButtonPressed() {
        mapView.isHidden.toggle()
    }
    
    private func setupSettingsView() {
        settingsView.setSaveDelegate(game!)
        settingsView.setEndDelegate(self)
        
        if loadGameSessionObserver != nil {
            settingsView.setLoadGameSessionObserver(loadGameSessionObserver!)
        }
        
        view.addSubview(settingsView)
        
        settingsView.pinTop(to: view.safeAreaLayoutGuide.topAnchor)
        settingsView.pin(to: view, [.left, .right])
        settingsView.pinBottom(to: view)
        
        settingsView.isHidden = true
        
        setUpSettingsButton()
    }
    
    private func setUpSettingsButton() {
        let settingsButton = UIButton()
        
        settingsButton.layer.cornerRadius = 12
        settingsButton.backgroundColor = .clear
        settingsButton.setHeight(48)
        settingsButton.setWidth(48)
        settingsButton.setTitle("⚙️", for: .normal)
        
        settingsButton.addAction(UIAction(handler: { _ in
            self.settingsView.isHidden.toggle()
        }), for: .touchUpInside)
        
        view.addSubview(settingsButton)
        settingsButton.pinTop(to: settingsView.topAnchor, 5)
        settingsButton.pinRight(to: settingsView, -30)
    }
    
    func reactToGameResult(_ gameResult: GameResult) {
        switch gameResult {
        case .end:
            if let controller = navigationController as? CustomNavigationController {
                controller.shouldAllowBack = true
            }
            
            // TODO: MINOR totally close view controller not just hide it
            audio.removeAllSources()
            navigationController?.popToRootViewController(animated: false)
        default:
            break
        }
    }
    
    public func stopAll() {
        audio.removeAllSources()
        
        NotificationCenter.default.removeObserver(self, name: AVAudioSession.routeChangeNotification, object: nil)
    }
    
    
    public func setLoadGameSessionObserver(_ observer: IntegerChoiceObserver) {
        loadGameSessionObserver = observer
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
