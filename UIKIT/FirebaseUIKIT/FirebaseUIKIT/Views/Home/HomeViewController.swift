//
//  HomeViewController.swift
//  FirebaseUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 07/11/25.
//

import Combine
import UIKit

class HomeViewController: BaseViewController {

    private let totalCard = EstadisticasCard()
    private let favCard = EstadisticasCard()
    private let noFavCard = EstadisticasCard()

    @IBOutlet weak var imagePerfil: UIImageView!
    @IBOutlet weak var lblNombre: UILabel!

    let estadisticasViewModel = EstadisticasViewModel()
    private let refreshControl = UIRefreshControl()

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
        cargarEstadisticas()
        configurarEstadisticasUI()
        vincularViewModel()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        cargarUsuario()
        cargarEstadisticas()
        configurarEstadisticasUI()
        vincularViewModel()
    }

    func cargarEstadisticas() {
        estadisticasViewModel.cargarEstadisticasMesActual()
    }

    private func vincularViewModel() {
        estadisticasViewModel.$total.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.totalCard.numberText = "\(value)"
            }.store(in: &estadisticasViewModel.subscriptions)

        estadisticasViewModel.$favoritos.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.favCard.numberText = "\(value)"
            }.store(in: &estadisticasViewModel.subscriptions)

        estadisticasViewModel.$noFavoritos.receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                self?.noFavCard.numberText = "\(value)"
            }.store(in: &estadisticasViewModel.subscriptions)
    }

    private func configurarEstadisticasUI() {
        // Configurar contenido inicial
        totalCard.configure(
            title: "Total Diarios",
            icon: UIImage(systemName: "book.fill"),
            number: "0",
            tint: .systemBlue
        )

        favCard.configure(
            title: "Favoritos",
            icon: UIImage(systemName: "star.fill"),
            number: "0",
            tint: .systemYellow
        )

        noFavCard.configure(
            title: "No Favoritos",
            icon: UIImage(systemName: "star"),
            number: "0",
            tint: .systemGray
        )

        // Usamos un stack vertical para centrar todo
        let stack = UIStackView(arrangedSubviews: [
            totalCard, favCard, noFavCard,
        ])
        stack.axis = .vertical
        stack.alignment = .fill
        stack.spacing = 16
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stack.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 16
            ),
            stack.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -16
            ),

            totalCard.heightAnchor.constraint(equalToConstant: 90),
        ])
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
                AlertHelper.showRetryAlert(
                    on: self,
                    title: "Error",
                    message: error.localizedDescription,

                ) {

                    self.cargarUsuario()

                }
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
