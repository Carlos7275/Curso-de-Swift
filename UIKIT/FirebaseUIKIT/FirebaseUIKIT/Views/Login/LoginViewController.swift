//
//  LoginViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//

import UIKit

class LoginViewController: UIViewController {

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

    @IBAction func btnIniciarSesionAction(_ sender: Any) {

        if validator.validateAll() {

            authService.login(
                email: txtEmail.text!,
                password: txtPassword.text!
            ) { resultado in
                switch resultado {
                case .success:
                    goToPage(name: "HomeView", window: self.view.window!,withNavBar: true)
                    break
                case .failure(let error):
                    AlertHelper.showAlert(
                        on: self,
                        title:"Error:",
                        message: error.localizedDescription
                    )
                    break

                }

            }
        }
    }
}
