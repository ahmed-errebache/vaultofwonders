import SwiftUI

// La vidéo du coffre, utilisée sur l'accueil et pendant l'ouverture.
// La vidéo a un fond blanc. En mode clair, le mélange « multiply » rend ce blanc
// transparent (blanc x couleur du fond = couleur du fond). En mode sombre, ce mélange
// noircirait le coffre : on garde donc le fond blanc, présenté comme une tuile arrondie.
struct ChestVideoView: View {
    let isPlaying: Bool

    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        VideoPlayerView(name: "money", isPlaying: isPlaying)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .blendMode(colorScheme == .dark ? .normal : .multiply)
    }
}
