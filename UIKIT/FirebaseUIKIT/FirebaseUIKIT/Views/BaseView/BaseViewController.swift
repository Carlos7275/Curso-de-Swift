import UIKit
class BaseViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        configurarMenu()
    }

    private func configurarMenu() {

        // Acción - Info de la app
        let infoAction = UIAction(title: "Información", image: UIImage(systemName: "info.circle")) { _ in
            self.mostrarInfo()
        }

        // Acción - Cerrar sesión
        let logoutAction = UIAction(title: "Cerrar sesión", image: UIImage(systemName: "rectangle.portrait.and.arrow.right"), attributes: .destructive) { _ in
            self.cerrarSesion()
        }

        // Menu
        let menu = UIMenu(title: "", children: [infoAction, logoutAction])

        // Botón con menú
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: nil,
            image: UIImage(systemName: "ellipsis.circle"),
            primaryAction: nil,
            menu: menu
        )
    }

    private func mostrarInfo() {
        print("Mostrar información de la app")
        // Aquí puedes mostrar un modal, alerta o pantalla
    }

    private func cerrarSesion() {
        do {
            try AuthService.shared.logout()
            goToPage(name: "LoginView", window: self.view.window!)

        } catch let error as NSError {
            AlertHelper.showAlert(on: self, message: error.localizedDescription)
        }
    }
}
