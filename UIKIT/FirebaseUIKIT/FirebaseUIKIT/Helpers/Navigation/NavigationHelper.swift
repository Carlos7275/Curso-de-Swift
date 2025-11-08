import UIKit

func goToPage(name: String, window: UIWindow,withNavBar:Bool = false) {
    let storyboard = UIStoryboard(name: name, bundle: nil)
    guard let vc = storyboard.instantiateInitialViewController() else {
        print("No se pudo instanciar el storyboard: \(name)")
        return
    }

    let navVC = TabBarViewController()

    DispatchQueue.main.async { 
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: { window.rootViewController = withNavBar == false ? vc : navVC },
            completion: nil
        )
    }
}

