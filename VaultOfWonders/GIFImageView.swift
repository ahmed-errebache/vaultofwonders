import SwiftUI
import WebKit
import ImageIO

// Affiche le GIF animé
struct GIFImageView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url) else { return }
        uiView.load(data, mimeType: "image/gif", characterEncodingName: "UTF-8",
                    baseURL: url.deletingLastPathComponent())
    }
}

// Affiche uniquement la première frame du GIF (statique)
struct GIFFirstFrameView: UIViewRepresentable {
    let name: String

    func makeUIView(context: Context) -> UIImageView {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.backgroundColor = .clear
        return iv
    }

    func updateUIView(_ uiView: UIImageView, context: Context) {
        guard let url = Bundle.main.url(forResource: name, withExtension: "gif"),
              let data = try? Data(contentsOf: url),
              let source = CGImageSourceCreateWithData(data as CFData, nil),
              let cgImage = CGImageSourceCreateImageAtIndex(source, 0, nil) else { return }
        uiView.image = UIImage(cgImage: cgImage)
    }
}
