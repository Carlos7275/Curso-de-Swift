//
//  LoginViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var btnLoginGoogle: UIButton!
    @IBOutlet weak var btnIniciarSesion: UIButton!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!
    private let authService = AuthService.shared

    let validator = FormValidator()

    func crearFormulario() {
        validator.register(field: txtEmail, rules: [required, validEmail()])
        validator.register(
            field: txtPassword,
            rules: [required]
        )
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        crearFormulario()

    }

    @IBAction func btnIniciarSesionAction(_ sender: UIButton) {
        guard validator.validateAll() else { return }

        // Guardar la configuración original
        let originalConfig = sender.configuration

        // Configuración con spinner
        var config = sender.configuration ?? UIButton.Configuration.filled()
        config.title = sender.title(for: .normal)
        config.showsActivityIndicator = true
        sender.configuration = config
        sender.isUserInteractionEnabled = false

        authService.login(
            email: txtEmail.text!,
            password: txtPassword.text!
        ) { resultado in
            DispatchQueue.main.async {
                // Restaurar configuración original
                sender.configuration = originalConfig
                sender.isUserInteractionEnabled = true

                switch resultado {
                case .success:
                    if let window = self.view.window {
                        goToPage(
                            name: "HomeView",
                            window: window,
                            withNavBar: true
                        )
                    }
                case .failure(let error):
                    AlertHelper.showAlert(
                        on: self,
                        title: "Error:",
                        message: error.localizedDescription
                    )
                }
            }
        }
    }

    @IBAction func btnLoginGoogleAction(_ sender: Any) {
        
        
        AuthService.shared.loginConGoogle(presenting: self) { result in
            switch result {
            case .success(let _uid):
                // Navegar a tu Home
                if let window = self.view.window {
                    goToPage(
                        name: "HomeView",
                        window: window,
                        withNavBar: true
                    )
                }
            case .failure(let error):
                AlertHelper.showAlert(
                    on: self,
                    title: "Error:",
                    message: error.localizedDescription
                )
            }
        }

    }

}
