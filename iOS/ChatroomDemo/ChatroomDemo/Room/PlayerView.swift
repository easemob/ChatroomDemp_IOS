//
//  PlayerView.swift
//  ChatroomDemo
//
//  Created by 朱继超 on 2023/10/25.
//

import UIKit
import AVFoundation
import ChatroomUIKit

final class PlayerView: UIView {
    
    private var playerLayer: AVPlayerLayer?
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var player: AVPlayer?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect,player: AVPlayer) {
        self.init(frame: frame)
        self.player = player
        self.playerLayer = AVPlayerLayer(player: player)
        self.playerLayer?.frame = self.bounds
        self.playerLayer?.videoGravity = .resizeAspectFill
        self.layer.addSublayer(self.playerLayer!)
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func playerDidFinishPlaying() {
        playerLayer?.player?.seek(to: CMTime.zero)
        playerLayer?.player?.play()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
