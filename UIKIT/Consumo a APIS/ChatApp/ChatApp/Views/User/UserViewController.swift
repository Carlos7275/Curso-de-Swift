//
//  UserViewController.swift
//  ChatApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import UIKit

class UserViewController: UIViewController {
    let validator = FormValidator()

    @IBOutlet weak var txtUsuario: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        crearFormulario()
    }

    func crearFormulario() {
        validator.register(field: txtUsuario, rules: [required])
    }

    @IBAction func btnIngresarAction(_ sender: Any) {
        guard validator.validateAll() else { return }

        UserDefaults.standard.set(txtUsuario.text!, forKey: "username")
        UserDefaults.standard.set("\(UUID())", forKey: "idUser")
        goToPage(name: "ChatView", window: self.view.window!)
    }
}
