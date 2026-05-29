import SwiftUI
import AVFoundation

struct VideoPlayerView: UIViewRepresentable {
    let name: String
    let isPlaying: Bool

    func makeCoordinator() -> Coordinator { Coordinator() }

    func makeUIView(context: Context) -> PlayerUIView {
        let view = PlayerUIView()
        if let url = Bundle.main.url(forResource: name, withExtension: "mp4") {
            let player = AVPlayer(url: url)
            player.isMuted = true
            view.setPlayer(player)
            context.coordinator.player = player
        }
        return view
    }

    func updateUIView(_ uiView: PlayerUIView, context: Context) {
        guard let player = context.coordinator.player else { return }
        if isPlaying {
            player.seek(to: .zero)
            player.play()
        } else {
            player.pause()
            player.seek(to: .zero)
        }
    }

    class Coordinator {
        var player: AVPlayer?
    }
}

class PlayerUIView: UIView {
    override class var layerClass: AnyClass { AVPlayerLayer.self }

    private var playerLayer: AVPlayerLayer { layer as! AVPlayerLayer }

    func setPlayer(_ player: AVPlayer) {
        playerLayer.player = player
        playerLayer.videoGravity = .resizeAspectFill
        playerLayer.backgroundColor = UIColor.clear.cgColor
        backgroundColor = .clear
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer.frame = bounds
    }
}
