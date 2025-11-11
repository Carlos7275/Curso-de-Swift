import Combine
import UIKit

class DiarioViewController: BaseViewController, UITableViewDelegate,
    UITableViewDataSource, UISearchBarDelegate
{

    // MARK: - IBOutlets
    @IBOutlet weak var tbDiarios: UITableView!
    @IBOutlet weak var swFavoritos: UISwitch!
    @IBOutlet weak var txtBusqueda: UISearchBar!

    // MARK: - Properties
    private let viewModel = DiariosViewModel()
    private var subscriptions = Set<AnyCancellable>()

    private let lblNoDiarios: UILabel = {
        let label = UILabel()
        label.text = "No hay diarios registrados"
        label.textAlignment = .center
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        return label
    }()

    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 26)
        button.tintColor = .white
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 30
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOpacity = 0.3
        button.layer.shadowOffset = CGSize(width: 0, height: 3)
        button.layer.shadowRadius = 4
        return button
    }()

    private let refreshControl = UIRefreshControl()

    private let spinner: UIActivityIndicatorView = {
        let sp = UIActivityIndicatorView(style: .large)
        sp.hidesWhenStopped = true
        sp.color = .systemBlue
        return sp
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFilters()
        setupFloatingButton()
        setupNoDiariosLabel()
        setupSpinner()
        bindViewModel()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        filtrosCambiados()
    }

    // MARK: - Setup Table
    private func setupTableView() {
        tbDiarios.delegate = self
        tbDiarios.dataSource = self
        tbDiarios.rowHeight = 70
        tbDiarios.register(
            DiarioCell.self,
            forCellReuseIdentifier: "diarioCell"
        )

        refreshControl.addTarget(
            self,
            action: #selector(refrescarDiarios),
            for: .valueChanged
        )
        tbDiarios.refreshControl = refreshControl
    }

    // MARK: - Setup Filters
    private func setupFilters() {
        txtBusqueda.delegate = self
        swFavoritos.addTarget(
            self,
            action: #selector(filtrosCambiados),
            for: .valueChanged
        )
    }

    // MARK: - Setup No Diarios Label
    private func setupNoDiariosLabel() {
        view.addSubview(lblNoDiarios)
        lblNoDiarios.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lblNoDiarios.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lblNoDiarios.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - Setup Spinner
    private func setupSpinner() {
        view.addSubview(spinner)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    // MARK: - Bind ViewModel
    private func bindViewModel() {
        viewModel.$diarios
            .receive(on: DispatchQueue.main)
            .sink { [weak self] diarios in
                self?.tbDiarios.reloadData()
                self?.lblNoDiarios.isHidden = !diarios.isEmpty
                self?.spinner.stopAnimating()
                self?.refreshControl.endRefreshing()
            }
            .store(in: &subscriptions)
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return viewModel.diarios.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        if indexPath.row == viewModel.diarios.count - 1 {
            viewModel.cargarSiguientePagina()
        }

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "diarioCell",
                for: indexPath
            ) as? DiarioCell
        else {
            return UITableViewCell()
        }

        let diario = viewModel.diarios[indexPath.row]
        cell.textLabel?.text = diario.titulo

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        cell.detailTextLabel?.text = formatter.string(
            from: diario.fechaCreacion
        )

        // Configurar botón favorito
        let imageName = diario.favorito ? "star.fill" : "star"
        let config = UIImage.SymbolConfiguration(
            pointSize: 24,
            weight: .regular
        )
        cell.favButton.setImage(
            UIImage(systemName: imageName, withConfiguration: config),
            for: .normal
        )
        cell.favButton.tag = indexPath.row
        cell.favButton.addTarget(
            self,
            action: #selector(favButtonTapped(_:)),
            for: .touchUpInside
        )

        return cell
    }

    // MARK: - UITableViewDelegate
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        tableView.deselectRow(at: indexPath, animated: true)
        let diarioSeleccionado = viewModel.diarios[indexPath.row]
        let vc = DiarioDetailViewController(modo: .ver(diarioSeleccionado))
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }

    // MARK: - Acción favorito
    @objc private func favButtonTapped(_ sender: UIButton) {
        var diario = viewModel.diarios[sender.tag]
        diario.favorito.toggle()

        viewModel.modificar(diario) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success():
                self.viewModel.diarios[sender.tag] = diario
            case .failure(let error):
                AlertHelper.showAlert(
                    on: self,
                    message:
                        "Error al actualizar favorito: \(error.localizedDescription)"
                )
            }
        }
    }

    // MARK: - Eliminar diario con confirmación
    func tableView(
        _ tableView: UITableView,
        commit editingStyle: UITableViewCell.EditingStyle,
        forRowAt indexPath: IndexPath
    ) {
        if editingStyle == .delete {
            let diario = viewModel.diarios[indexPath.row]
            AlertHelper.showRetryAlert(
                on: self,
                title: "Eliminar Diario",
                message: "¿Estás seguro de que deseas eliminar este diario?",
                retryTitle: "Eliminar",
                showCancel: true
            ) { [weak self] in
                guard let self = self else { return }
                self.viewModel.eliminar(diario) { result in
                    switch result {
                    case .success():
                        self.viewModel.diarios.remove(at: indexPath.row)
                        tableView.deleteRows(at: [indexPath], with: .automatic)
                        AlertHelper.showAlert(
                            on: self,
                            message: "Diario eliminado"
                        )
                    case .failure(let error):
                        AlertHelper.showAlert(
                            on: self,
                            message:
                                "Error al eliminar diario: \(error.localizedDescription)"
                        )
                    }
                }
            }
        }
    }

    // MARK: - UISearchBarDelegate
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtrosCambiados()
    }

    // MARK: - Filtros
    @objc private func filtrosCambiados() {
        spinner.startAnimating()
        let busqueda = txtBusqueda.text
        let favorito = swFavoritos.isOn ? true : nil
        viewModel.cargarDiarios(busqueda: busqueda, favorito: favorito)
    }

    // MARK: - Pull to Refresh
    @objc private func refrescarDiarios() {
        filtrosCambiados()
    }

    // MARK: - Botón flotante
    private func setupFloatingButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 60),
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            addButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: -20
            ),
        ])
        addButton.addTarget(
            self,
            action: #selector(addButtonTapped),
            for: .touchUpInside
        )
    }

    @objc private func addButtonTapped() {
        let vc = DiarioDetailViewController(modo: .agregar)
        vc.hidesBottomBarWhenPushed = true

        self.navigationController?.pushViewController(vc, animated: true)
    }

}
