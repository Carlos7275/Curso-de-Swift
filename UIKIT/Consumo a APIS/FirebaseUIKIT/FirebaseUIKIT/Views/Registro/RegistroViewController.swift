//
//  RegistroViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 06/11/25.
//

import FirebaseFirestore
import UIKit

class RegistroViewController: UIViewController, UIPickerViewDelegate,
    UIPickerViewDataSource
{

    @IBOutlet weak var dpFechaNacimiento: UIDatePicker!
    @IBOutlet weak var pickerGeneros: UIPickerView!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtPasswordAux: UITextField!
    @IBOutlet weak var txtPassword: UITextField!
    @IBOutlet weak var txtEmail: UITextField!

    private var generoSeleccionado: Genero?
    let validator = FormValidator()

    private let generosViewModel = GenerosViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()

        pickerGeneros.delegate = self
        pickerGeneros.dataSource = self

        txtEmail.setLeftIcon("envelope.fill")
        txtPassword.setLeftIcon("lock.fill")
        txtPasswordAux.setLeftIcon("lock.rotation")
        txtNombres.setLeftIcon("person.fill")
        txtApellidos.setLeftIcon("person.fill")

        cargarGeneros()
        crearFormulario()
    }

    func crearFormulario() {
        validator.register(field: txtEmail, rules: [required, validEmail()])
        validator.register(
            field: txtNombres,
            rules: [required, maxLength(100)]
        )

        validator.register(
            field: txtPassword,
            rules: [required, validPassword()]
        )

        validator.register(
            field: txtPasswordAux,
            rules: [
                required,
                matchField(
                    txtPassword,
                    message: "¡Las contraseñas no coinciden!"
                ),
            ]
        )
        validator.register(
            field: txtApellidos,
            rules: [required, maxLength(100)]
        )
        validator.register(field: pickerGeneros, rules: [required])
        validator.register(
            field: dpFechaNacimiento,
            rules: [required, validBirthday()]
        )
    }

    func cargarGeneros() {
        Task {
            await generosViewModel.obtenerGeneros()
            DispatchQueue.main.async(execute: {
                self.pickerGeneros.reloadAllComponents()

            })
        }
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1  // Una sola columna
    }

    func pickerView(
        _ pickerView: UIPickerView,
        numberOfRowsInComponent component: Int
    ) -> Int {
        return generosViewModel.generos.count
    }

    func pickerView(
        _ pickerView: UIPickerView,
        titleForRow row: Int,
        forComponent component: Int
    ) -> String? {
        return generosViewModel.generos[row].descripcion
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        generoSeleccionado = generosViewModel.generos[row]

    }

    @IBAction func btnRegistrarseAction(_ sender: UIButton) {
        guard validator.validateAll() else { return }

        guard let genero = generoSeleccionado else {
            AlertHelper.showAlert(
                on: self,
                title: "Error",
                message: "Debes seleccionar un género."
            )
            return
        }

        guard let email = txtEmail.text,
            let password = txtPassword.text,
            !email.isEmpty, !password.isEmpty
        else {
            AlertHelper.showAlert(
                on: self,
                title: "Error",
                message: "Correo y contraseña son obligatorios."
            )
            return
        }

        sender.isEnabled = false
        Loading.show(on: view)

        let generoRef: DocumentReference
        do {
            generoRef = try generosViewModel.obtenerReferenciaGenero(
                genero: genero
            )
        } catch {
            sender.isEnabled = true
            Loading.hide(from: view)
            AlertHelper.showAlert(
                on: self,
                title: "Error",
                message: error.localizedDescription
            )
            return
        }

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let usuario = Usuario(
            nombres: txtNombres.text ?? "",
            apellidos: txtApellidos.text ?? "",
            fechaNacimiento: formatter.string(from: dpFechaNacimiento.date),
            foto: "",
            genero: generoRef
        )

        AuthService.shared.registrarUsuarioCompleto(
            email: email,
            password: password,
            usuario: usuario
        ) { result in

            sender.isEnabled = true
            Loading.hide(from: self.view)

            switch result {
            case .success:
                AlertHelper.showAlert(
                    on: self,
                    title: "¡Éxito!",
                    message: "Usuario registrado correctamente."
                ) {
                    if let nav = self.navigationController {
                        nav.popViewController(animated: true)  // Si fue push (Show)
                    } else {
                        self.dismiss(animated: true)  // Si fue modal
                    }

                }

            case .failure(let error):
                AlertHelper.showAlert(
                    on: self,
                    title: "Error",
                    message: error.localizedDescription
                )
            }
        }
    }

    private static func formattedDate(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

}
