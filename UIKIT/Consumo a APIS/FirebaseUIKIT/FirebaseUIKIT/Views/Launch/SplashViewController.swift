import FirebaseAuth
import UIKit

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Simular un pequeño delay para mostrar splash
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.checkAuthStatus()
        }
    }

    func checkAuthStatus() {
        if let user = Auth.auth().currentUser {
            // Usuario logueado, verificar token
            user.getIDTokenForcingRefresh(false) { token, error in
                if error != nil {
                    // Token inválido o expiró
                    self.logoutWithAlert(
                        message:
                            "Tu sesión expiró. Por favor vuelve a iniciar sesión."
                    )
                } else {
                    // Token válido → ir a Home
                    self.goToHome()
                }
            }
        } else {
            // No hay usuario → ir a Login
            self.goToLogin()
        }
    }

    func logoutWithAlert(message: String) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }

        let alert = UIAlertController(
            title: "Sesión",
            message: message,
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "OK", style: .default) { _ in
                self.goToLogin()
            }
        )
        self.present(alert, animated: true)
    }

    // MARK: - Funciones de navegación

    func goToHome() {
        let tabBarVC = TabBarViewController()
        setRootViewController(tabBarVC)
    }

    func goToPage(name: String) {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        guard let VC = storyboard.instantiateInitialViewController() else {
            return
        }
        setRootViewController(VC)
    }

    
    func goToLogin() {
        goToPage(name: "LoginView")
    }

    // MARK: - Función helper moderna para iOS 15+
    private func setRootViewController(_ vc: UIViewController) {
        DispatchQueue.main.async {  // asegurar hilo principal
            // Intenta obtener ventana desde view.window
            if let windowScene = self.view.window?.windowScene,
                let window = windowScene.windows.first
            {
                window.rootViewController = vc
                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: nil
                )
            }
            // Fallback usando connectedScenes
            else if let scene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
                let window = scene.windows.first
            {
                window.rootViewController = vc
                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: nil
                )
            } else {
                print(
                    "No se pudo encontrar la ventana para cambiar rootViewController"
                )
            }
        }
    }

}
