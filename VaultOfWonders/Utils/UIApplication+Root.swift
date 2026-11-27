import UIKit

extension UIApplication {
    // Le contrôleur affiché à l'écran : Google en a besoin pour présenter
    // sa fenêtre de choix de compte par-dessus l'application.
    var rootViewController: UIViewController? {
        connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }?
            .rootViewController
    }
}
