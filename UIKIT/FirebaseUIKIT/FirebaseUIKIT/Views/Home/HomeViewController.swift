//
//  HomeViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

import UIKit

class HomeViewController: BaseViewController {

    @IBOutlet weak var imagePerfil: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!
    private var loading = loadingView()

    let homeViewModel: HomeViewModel = HomeViewModel()

    func configurarVistaLoading() {
        view.addSubview(loading)
        NSLayoutConstraint.activate([
            loading.topAnchor.constraint(equalTo: view.topAnchor),
            loading.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loading.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loading.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // Agregar spinner dentro del overlay
        loading.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(
                equalTo: loading.centerXAnchor
            ),
            spinner.centerYAnchor.constraint(
                equalTo: loading.centerYAnchor
            ),
        ])
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configurarVistaLoading()
        spinner.startAnimating()

        cargarUsuario()

    }

    func cargarUsuario() {
        Task {
            do {
                try await homeViewModel.cargarUsuario()
                if let usuario = homeViewModel.usuarioSession.usuario {
                    let nombreCompleto =
                        "\(usuario.nombres) \(usuario.apellidos)"
                    lblNombre.text = "Hola \(nombreCompleto)"
                } else {
                    lblNombre.text = "Hola Desconocido"
                }

                if let urlString = homeViewModel.usuarioSession.usuario?.foto,
                    let url = URL(string: urlString)
                {

                    URLSession.shared.dataTask(with: url) {
                        data,
                        response,
                        error in
                        guard let data = data, error == nil else { return }
                        DispatchQueue.main.async {
                            self.imagePerfil.image = UIImage(data: data)

                        }
                    }.resume()
                }

                spinner.stopAnimating()
                loading.isHidden = true

            } catch let error as NSError {
                AlertHelper.showAlert(
                    on: self,
                    title: "Error:",
                    message: error.localizedDescription
                )
            }

        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        imagePerfil.layer.cornerRadius = imagePerfil.frame.width / 2
        imagePerfil.clipsToBounds = true
        imagePerfil.contentMode = .scaleAspectFill
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cargarUsuario()
    }

    @IBAction func btnIrPerfilAction(_ sender: Any) {
        if let tabBar = self.tabBarController {
            tabBar.selectedIndex = 2
        }
    }
}
