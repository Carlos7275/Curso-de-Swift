//
//  PokemonDetailViewController.swift
//  PokeApiUIKIT
//

import Combine
import UIKit

class PokemonDetailViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    // MARK: - IBOutlets
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var lblPokemon: UILabel!
    @IBOutlet weak var lblAltura: UILabel!
    @IBOutlet weak var lblPeso: UILabel!
    @IBOutlet weak var lblHabilidades: UILabel!
    @IBOutlet weak var coleccionTipos: UICollectionView!
    @IBOutlet weak var coleccionImagenes: UICollectionView!
    private var subscriptions = Set<AnyCancellable>()

    // MARK: - Variables
    public var pokemon: Pokemon?
    private let pokemonDetailViewModel = PokemonDetailViewModel()
    private var imagenes: [String] = []

    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Delegados y dataSource
        coleccionImagenes.delegate = self
        coleccionImagenes.dataSource = self
        coleccionTipos.delegate = self
        coleccionTipos.dataSource = self

        // Ocultar contenido inicial
        contentView.isHidden = false

        // Agregar overlay de carga
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])

        // Agregar spinner dentro del overlay
        loadingView.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(
                equalTo: loadingView.centerXAnchor
            ),
            spinner.centerYAnchor.constraint(
                equalTo: loadingView.centerYAnchor
            ),
        ])

        pokemonDetailViewModel.$mostrarError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mostrar in
                guard mostrar, let self = self else { return }
                let alert = UIAlertController(
                    title: "Error",
                    message: self.pokemonDetailViewModel.mensajeError,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
            }
            .store(in: &subscriptions)

        spinner.startAnimating()

        // Cargar datos asincrónicamente
        Task {
            do {
                guard let nombrePokemon = pokemon?.name else { return }
                await pokemonDetailViewModel.cargarDetalle(
                    nombreOId: nombrePokemon
                )

                guard let detalle = pokemonDetailViewModel.pokemonDetalle else {
                    return
                }

                imagenes.removeAll()
                if let front = detalle.sprites.front_default {
                    imagenes.append(front)
                }
                if let back = detalle.sprites.back_default {
                    imagenes.append(back)
                }
                if let frontShiny = detalle.sprites.front_shiny {
                    imagenes.append(frontShiny)
                }
                if let backShiny = detalle.sprites.back_shiny {
                    imagenes.append(backShiny)
                }
                if let official = detalle.sprites.other?.officialArtwork?
                    .front_default
                {
                    imagenes.append(official)
                }

                await MainActor.run {
                    lblPokemon.text = detalle.name.capitalized
                    lblAltura.text = "Altura: \(detalle.height)"
                    lblPeso.text = "Peso: \(detalle.weight)"
                    lblHabilidades.text = detalle.abilities.map {
                        $0.ability.name
                    }.joined(separator: "\n")

                    coleccionImagenes.reloadData()
                    coleccionTipos.reloadData()

                    contentView.isHidden = false
                    loadingView.isHidden = true
                    spinner.stopAnimating()
                }

            }
        }

    }

    // MARK: - UICollectionViewDataSource
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        if collectionView == coleccionImagenes {
            return imagenes.count
        } else if collectionView == coleccionTipos {
            return pokemonDetailViewModel.pokemonDetalle?.types.count ?? 0
        }
        return 0
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        if collectionView == coleccionImagenes {
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "ImagenCell",
                    for: indexPath
                ) as! ImagenesCollectionViewCell
            let urlString = imagenes[indexPath.row]
            if let url = URL(string: urlString) {
                DispatchQueue.global().async {
                    if let data = try? Data(contentsOf: url) {
                        let image = UIImage(data: data)
                        DispatchQueue.main.async {
                            cell.imagen?.image = image
                        }
                    }
                }
            }
            return cell
        } else {
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: "TipoCell",
                    for: indexPath
                ) as! TipoCollectionViewCell
            if let tipo = pokemonDetailViewModel.pokemonDetalle?.types[
                indexPath.row
            ].type.name {
                cell.botonTipo?.setTitle(tipo.capitalized, for: .normal)
                cell.botonTipo?.backgroundColor = colorTipo(tipo: tipo)
                cell.botonTipo?.setTitleColor(.white, for: .normal)
                cell.botonTipo?.layer.cornerRadius = 8
            }
            return cell
        }
    }

    // MARK: - UICollectionViewDelegateFlowLayout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        if collectionView == coleccionImagenes {
            return CGSize(width: 100, height: 100)
        } else {
            return CGSize(width: 80, height: 30)
        }
    }

}
