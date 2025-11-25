//
//  ViewController.swift
//  ScrollView
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 18/11/25.
//

import UIKit

class ViewController: UIViewController, UIPickerViewDelegate,
    UIPickerViewDataSource
{

    let validator = FormValidator()

    let generosViewModel = GenerosViewModel()
    let registroViewModel = RegistroViewModel()

    var generoSeleccionado: Generos?
    @IBOutlet weak var cwColorFavorito: UIColorWell!
    @IBOutlet weak var dpFechaNacimiento: UIDatePicker!
    @IBOutlet weak var generosPicker: UIPickerView!
    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtNombres: UITextField!
    @IBOutlet weak var txtContraAux: UITextField!
    @IBOutlet weak var txtContra: UITextField!
    @IBOutlet weak var txtCorreo: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        generosPicker.delegate = self
        generosPicker.dataSource = self
        inicializarSpinner()
        crearFormulario()
        cargarGeneros()

    }

    /// Creamos el overlay con el spinner
    func inicializarSpinner() {

        view.addSubview(overlay)

        NSLayoutConstraint.activate([
            overlay.topAnchor.constraint(equalTo: view.topAnchor),
            overlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            overlay.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            overlay.trailingAnchor.constraint(equalTo: view.trailingAnchor),

        ])
        overlay.isHidden = false

        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])

        spinner.startAnimating()
    }

    func ocultarSpinner() {
        spinner.stopAnimating()
        overlay.isHidden = true
    }

    /// Carga los generos al picker
    func cargarGeneros() {
        Task {
            await generosViewModel.cargarGeneros()
            DispatchQueue.main.async {
                self.generosPicker.reloadAllComponents()
                self.ocultarSpinner()
            }
        }
    }
    /// Crea el formulario reactivo para el registro con sus respectivas validaciónes
    func crearFormulario() {
        validator.register(field: txtCorreo, rules: [required, validEmail()])

        validator.register(
            field: txtContra,
            rules: [required, validPassword()]
        )

        validator.register(
            field: txtContraAux,
            rules: [required, validPassword(), matchField(txtContra)]
        )

        validator.register(field: generosPicker, rules: [required])
        validator.register(
            field: dpFechaNacimiento,
            rules: [required, validBirthday()]
        )
        validator.register(field: cwColorFavorito, rules: [required])

    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
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
        return generosViewModel.generos[row].nombre
    }

    func pickerView(
        _ pickerView: UIPickerView,
        didSelectRow row: Int,
        inComponent component: Int
    ) {
        generoSeleccionado = self.generosViewModel.generos[row]

    }
    @IBAction func btnGuardarAction(_ sender: Any) {
        guard validator.validateAll() else { return }

        let formatter = DateFormatter()

        formatter.dateFormat = "yyyy-MM-dd"

        let fecha = formatter.string(from: dpFechaNacimiento?.date ?? Date())
        let color = cwColorFavorito.selectedColor?.toHex ?? ""
        let idGenero = generoSeleccionado?.id ?? ""

        let registro = UsuariosRequest(
            correo: txtCorreo!.text ?? "",
            password: txtContra!.text ?? "",
            nombres: txtNombres!.text ?? "",
            apellidos: txtApellidos!.text ?? "",
            genero: idGenero,
            fechaNacimiento: fecha,
            colorFavorito: color
        )

        registroViewModel.registrarUsuario(usuario: registro) {
            estado in

            if estado {
                AlertHelper.showAlert(
                    on: self,
                    title: "¡Exito!",
                    message: "¡Se registro correctamente al usuario!"
                )
            } else {
                AlertHelper.showAlert(
                    on: self,
                    title: "¡Error!",
                    message: "¡Hubo un error al registrar"
                )
            }

        }

    }

}
