import Combine
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource, UISearchBarDelegate
{

    private let pokeViewModel = PokeViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var imageCache: [String: UIImage] = [:]

    @IBOutlet weak var tbPokemones: UITableView!
    @IBOutlet weak var txtBusqueda: UISearchBar!

    private let refreshControl = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()

        tbPokemones.delegate = self
        tbPokemones.dataSource = self
        tbPokemones.rowHeight = 60
        tbPokemones.register(
            UITableViewCell.self,
            forCellReuseIdentifier: "celda"
        )
        txtBusqueda.delegate = self

        refreshControl.attributedTitle = NSAttributedString(
            string: "Cargando Pokémon…"
        )
        refreshControl.addTarget(
            self,
            action: #selector(recargarDatos),
            for: .valueChanged
        )
        tbPokemones.refreshControl = refreshControl

        bindViewModel()
        cargarPokemones()

    }

    @objc func recargarDatos() {
        cargarPokemones()
    }

    func cargarPokemones() {
        Task {
            await pokeViewModel.cargarPokemones()
            refreshControl.endRefreshing()  // Detener animación

        }
    }

    private func bindViewModel() {
        pokeViewModel.$pokemonesFiltrados
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tbPokemones.reloadData()
            }
            .store(in: &subscriptions)

        pokeViewModel.$mostrarError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] mostrar in
                guard mostrar, let self = self else { return }
                let alert = UIAlertController(
                    title: "Error",
                    message: self.pokeViewModel.mensajeError,
                    preferredStyle: .alert
                )
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel))
                self.present(alert, animated: true)
            }
            .store(in: &subscriptions)
    }

    // MARK: - UITableView DataSource

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = pokeViewModel.pokemonesFiltrados.count

        if count == 0 {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
            label.text = "No hay pokemones"
            label.textAlignment = .center
            label.textColor = .gray
            label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            tableView.backgroundView = label
            tableView.separatorStyle = .none
        } else {
            tableView.backgroundView = nil
            tableView.separatorStyle = .singleLine
        }

        return count
    }


    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "mostrarDetalle", sender: indexPath)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "mostrarDetalle" {
            if let indexPath = tbPokemones.indexPathForSelectedRow {
                let selectedItem = pokeViewModel.pokemonesFiltrados[
                    indexPath.row
                ]
                let detailVC = segue.destination as! PokemonDetailViewController
                detailVC.title = selectedItem.name.capitalized
                detailVC.pokemon = selectedItem

            }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "celda",
            for: indexPath
        )
        let pokemon = pokeViewModel.pokemonesFiltrados[indexPath.row]

        cell.textLabel?.text = pokemon.name.capitalized

        // Imagen async con cache
        if let cached = imageCache[pokemon.imageURL] {
            cell.imageView?.image = cached
            cell.hideSpinner()
        } else if let url = URL(string: pokemon.imageURL) {
            Task {
                do {
                    let (data, _) = try await URLSession.shared.data(from: url)
                    if let image = UIImage(data: data) {
                        imageCache[pokemon.imageURL] = image
                        await MainActor.run {
                            if tableView.indexPath(for: cell) == indexPath {
                                cell.imageView?.image = image
                                cell.setNeedsLayout()
                                cell.hideSpinner()
                            }
                        }
                    }
                } catch {
                    await MainActor.run { cell.hideSpinner() }
                }
            }
        }

        return cell
    }

    // MARK: - ScrollView Delegate

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let lastVisibleIndex = tbPokemones.indexPathsForVisibleRows?.last?
                .row
        else { return }
        pokeViewModel.ventanaSegunIndice(lastVisibleIndex)
    }

    // MARK: - UISearchBar Delegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        pokeViewModel.busqueda = searchText
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

extension UITableViewCell {
    func showSpinner() -> UIActivityIndicatorView {
        let tag = 999
        if let spinner = contentView.viewWithTag(tag)
            as? UIActivityIndicatorView
        {
            spinner.startAnimating()
            return spinner
        } else {
            let spinner = UIActivityIndicatorView(style: .medium)
            spinner.tag = tag
            spinner.center = CGPoint(x: 30, y: contentView.frame.height / 2)
            spinner.startAnimating()
            contentView.addSubview(spinner)
            return spinner
        }
    }

    func hideSpinner() {
        contentView.viewWithTag(999)?.removeFromSuperview()
    }
}
