import UIKit

func goToPage(name: String, window: UIWindow) {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    guard let vc = storyboard.instantiateInitialViewController() else {
        print("No se pudo instanciar el storyboard: \(name)")
        return
    }

    let navVC = UINavigationController(rootViewController: vc)

    DispatchQueue.main.async { 
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { window.rootViewController = navVC },
            completion: nil
        )
    }
}

