import UIKit
import FirebaseAuth

class SplashViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        // Puedes agregar un logo aquí si quieres
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
                if let error = error {
                    // Token inválido o expiró
                    self.logoutWithAlert(message: "Tu sesión expiró. Por favor vuelve a iniciar sesión.")
                } else {
                    // Token válido → ir a Home
                    self.goToHome()
                }
            }
        } else {
            // No hay usuario → ir a Login
            goToLogin()
        }
    }
    
    func logoutWithAlert(message: String) {
        do {
            try Auth.auth().signOut()
        } catch let error {
            print("Error al cerrar sesión: \(error.localizedDescription)")
        }
        
        // Mostrar alerta
        let alert = UIAlertController(title: "Sesión", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            self.goToLogin()
        })
        self.present(alert, animated: true)
    }
    
    func goToHome() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
        let navVC = UINavigationController(rootViewController: homeVC)
        UIApplication.shared.windows.first?.rootViewController = navVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
    
    func goToLogin() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let loginVC = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        UIApplication.shared.windows.first?.rootViewController = loginVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
