import SwiftUI
import WebKit

struct SVGAnimationView: UIViewRepresentable {
    let name: String
    let isPlaying: Bool

    func makeCoordinator() -> Coordinator { Coordinator(self) }

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.scrollView.isScrollEnabled = false
        webView.isOpaque = false
        webView.backgroundColor = .clear
        webView.scrollView.backgroundColor = .clear
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        context.coordinator.parent = self
        if !context.coordinator.isLoaded {
            guard let url = Bundle.main.url(forResource: name, withExtension: "svg"),
                  let svg = try? String(contentsOf: url) else { return }
            let html = """
            <!DOCTYPE html><html>
            <head>
            <meta name="viewport" content="width=device-width,initial-scale=1">
            <style>
            *{margin:0;padding:0;}
            body{background:transparent;display:flex;align-items:center;justify-content:center;width:100vw;height:100vh;overflow:hidden;}
            svg{width:100vw;height:100vh;}
            </style>
            </head>
            <body>\(svg)</body>
            </html>
            """
            uiView.loadHTMLString(html, baseURL: nil)
        } else {
            context.coordinator.applyPlayState(uiView)
        }
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: SVGAnimationView
        var isLoaded = false

        init(_ parent: SVGAnimationView) { self.parent = parent }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            isLoaded = true
            applyPlayState(webView)
        }

        func applyPlayState(_ webView: WKWebView) {
            let js = parent.isPlaying
                ? "var s=document.querySelector('svg');if(s)s.unpauseAnimations();"
                : "var s=document.querySelector('svg');if(s){s.pauseAnimations();s.setCurrentTime(0);}"
            webView.evaluateJavaScript(js, completionHandler: nil)
        }
    }
}
