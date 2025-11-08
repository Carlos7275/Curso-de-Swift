//
//  PerfilViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

import UIKit

class PerfilViewController: BaseViewController {

    let homeViewModel = HomeViewModel()

    @IBOutlet weak var imgPerfil: UIImageView!

    @IBOutlet weak var txtApellidos: UITextField!
    @IBOutlet weak var txtNombres: UITextField!

    @IBOutlet weak var dpFechaNacimiento: UIDatePicker!

    override func viewDidLoad() {
        super.viewDidLoad()
        establecerDatos()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        establecerDatos()
    }
    
    func establecerDatos() {
        txtNombres.text = homeViewModel.usuarioSession.usuario!.nombres
        txtApellidos.text = homeViewModel.usuarioSession.usuario!.apellidos
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let fecha = formatter.date(
            from: homeViewModel.usuarioSession.usuario!.fechaNacimiento
        )
        dpFechaNacimiento.date = fecha ?? Date()

        if let urlString = homeViewModel.usuarioSession.usuario?.foto,
            let url = URL(string: urlString)
        {

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
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imgPerfil.layer.cornerRadius = imgPerfil.frame.width / 2
        imgPerfil.clipsToBounds = true
        imgPerfil.contentMode = .scaleAspectFill
    }

    @IBAction func btnGuardarAction(_ sender: Any) {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"

        let fechaFormateada = formatter.string(from: dpFechaNacimiento.date)
        do {
            Task {
                try await homeViewModel.userService.actualizarUsuario(
                    uid: homeViewModel.authService.obtenerUID()!,
                    cambios: [
                        "nombres": txtNombres.text!,
                        "apellidos": txtApellidos.text!,
                        "fechanacimiento": "\(fechaFormateada)",
                    ],
                    foto: nil
                )
                AlertHelper.showAlert(
                    on: self,
                    title: "Exito",
                    message: "Se actualizo la información del usuario"
                )
            }

        } catch let error as NSError {
            AlertHelper.showAlert(
                on: self,
                title: "Error:",
                message: error.localizedDescription
            )
        }

    }
}
