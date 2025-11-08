//
//  PerfilViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

import UIKit

class PerfilViewController: BaseViewController, UIPickerViewDelegate,
    UIPickerViewDataSource
{
    var generoSeleccionado: Genero?

    let homeViewModel = HomeViewModel()
    let generosViewModel = GenerosViewModel()

    @IBOutlet weak var imgPerfil: UIImageView!

    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtNombres: UITextField!

    @IBOutlet weak var dpFechaNacimiento: UIDatePicker!

    @IBOutlet weak var pickGeneros: UIPickerView!
    let validator = FormValidator()

    override func viewDidLoad() {
        super.viewDidLoad()
        establecerDatos()
        crearFormulario()
        cargarGeneros()
    }

    func cargarGeneros() {
        Task {
            await generosViewModel.obtenerGeneros()

            guard let ref = homeViewModel.usuarioSession.usuario?.genero else {
                return
            }

            do {
                let generoUsuario =
                    try await generosViewModel.obtenerGeneroDesdeRef(ref)

                if let index = generosViewModel.generos.firstIndex(where: {
                    $0.id == generoUsuario.id
                }) {
                    DispatchQueue.main.async {
                        self.pickGeneros.reloadAllComponents()
                        self.pickGeneros.selectRow(
                            index,
                            inComponent: 0,
                            animated: false
                        )
                        self.generoSeleccionado = self.generosViewModel.generos[index]

                    }
                }
            } catch {
                print("Error obteniendo género:", error.localizedDescription)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pickGeneros.delegate = self
        pickGeneros.dataSource = self
        establecerDatos()
    }

    func crearFormulario() {
        
        validator.register(
            field: txtApellidos,
            rules: [required, maxLength(100)]
        )
        validator.register(
            field: dpFechaNacimiento,
            rules: [required, validBirthday()]
        )

        validator.register(field: pickGeneros, rules: [required])
    }

    func establecerDatos() {
        let usuario = homeViewModel.usuarioSession.usuario!

        txtNombres.text = usuario.nombres
        txtApellidos.text = usuario.apellidos

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let fecha = formatter.date(
            from: usuario.fechaNacimiento
        )
        dpFechaNacimiento.date = fecha ?? Date()

        let urlString = usuario.foto

        let url = URL(string: urlString)!

        URLSession.shared.dataTask(with: url) {
            data,
            response,
            error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.imgPerfil.image = UIImage(data: data)

            }
        }.resume()

    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imgPerfil.layer.cornerRadius = imgPerfil.frame.width / 2
        imgPerfil.clipsToBounds = true
        imgPerfil.contentMode = .scaleAspectFill
    }

    @IBAction func btnGuardarAction(_ sender: UIButton) {
        // Guardar la configuración original
        let originalConfig = sender.configuration

        // Crear una configuración con spinner
        var config = sender.configuration ?? UIButton.Configuration.filled()
        config.title = sender.title(for: .normal) // Mantener el título
        config.showsActivityIndicator = true
        sender.configuration = config

        sender.isUserInteractionEnabled = false

        Task {
            defer {
                DispatchQueue.main.async {
                    // Restaurar configuración original
                    sender.configuration = originalConfig
                    sender.isUserInteractionEnabled = true
                }
            }

            // Validación
            guard validator.validateAll() else { return }
            guard let genero = generoSeleccionado else {
                AlertHelper.showAlert(on: self, title: "Error", message: "Selecciona un género")
                return
            }

            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd"
            let fechaFormateada = formatter.string(from: dpFechaNacimiento.date)

            var cambios: [String: Any] = [
                "nombres": txtNombres.text!,
                "apellidos": txtApellidos.text!,
                "fechanacimiento": fechaFormateada
            ]

            do {
                let generoRef = try generosViewModel.obtenerReferenciaGenero(genero: genero)
                cambios["genero"] = generoRef

                try await homeViewModel.userService.actualizarUsuario(
                    uid: homeViewModel.usuarioSession.usuario!.id!,
                    cambios: cambios,
                    foto: nil
                )

                AlertHelper.showAlert(
                    on: self,
                    title: "Éxito",
                    message: "Se actualizó la información del usuario"
                )

            } catch {
                AlertHelper.showRetryAlert(
                    on: self,
                    title: "Error",
                    message: error.localizedDescription,
                    retryTitle: "Reintentar"
                ) {
                    self.btnGuardarAction(sender)
                }
            }
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
}
