import Combine
import UIKit

class HomeViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var txtBusqueda: UISearchBar!
    @IBOutlet weak var collectionMovies: UICollectionView!

    private var cancellables = Set<AnyCancellable>()

    // MARK: - Properties
    private let movieViewModel = MoviesViewModel()
    private var searchTimer: Timer?

    private var refresh = UIRefreshControl()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupEmptyLabel()
        setupRefreshControl()
        setupObserverError()
        setupSpinner()
        txtBusqueda.delegate = self
        loadInitialMovies()

    }
    ///Observamos los cambios que hay en los errores del viewModel y mostramos si hay error
    func setupObserverError() {
        movieViewModel.$showError.sink { [weak self] showError in
            guard let self = self else { return }

            if showError {
                AlertHelper.showAlert(
                    on: self,
                    title: "Error:",
                    message: movieViewModel.errorMessage
                )
            }
        }.store(in: &cancellables)
    }

    ///Configuramos el refresh hacia el collection view para actualizar con pull on refresh
    private func setupRefreshControl() {
        refresh.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )
        collectionMovies.refreshControl = refresh

    }
    @objc
    ///Configuramos la funcion para el pull on refresh que cargara las peliculas iniciales
    private func refreshData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.loadInitialMovies()
            self.refresh.endRefreshing()

        }
    }

    ///Configuramos la etiqueta de no hay datos en la vista
    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    ///Configuramos el spinner en la vista
    private func setupSpinner() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    // MARK: - Setup
    ///Configuramos la collection view para que utilize la celda reutilizable y sus delegados
    private func setupCollectionView() {
        collectionMovies.delegate = self
        collectionMovies.dataSource = self

        let nib = UINib(nibName: "CardCellCollectionViewCell", bundle: nil)
        collectionMovies.register(
            nib,
            forCellWithReuseIdentifier: "CardCellCollectionViewCell"
        )
    }

    ///Mostramos el spinner
    private func showSpinner() {
        spinner.startAnimating()
        collectionMovies.isUserInteractionEnabled = false
    }
    ///Escondemos el spinner de la pantalla
    private func hideSpinner() {
        spinner.stopAnimating()
        collectionMovies.isUserInteractionEnabled = true
    }

    // MARK: - Data
    ///Precargamos las peliculas iniciales
    private func loadInitialMovies() {
        showSpinner()
        movieViewModel.loadMovies()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.reloadCollection()
            self.hideSpinner()
        }
    }
    ///Recargamos el collection y si no hay peliculas mostramos el emptylabel
    private func reloadCollection() {
        DispatchQueue.main.async {
            self.collectionMovies.reloadData()
            emptyLabel.isHidden = !self.movieViewModel.currentMovies
                .isEmpty
        }
    }

}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    ///Determinamos cuantos datos tendra el uicollectionview en este caso utilizamos las peliculas guardadas en currentmovies
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        movieViewModel.currentMovies.count
    }

    
    ///Configuramos el formato de la celda personalizada
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CardCellCollectionViewCell",
                for: indexPath
            ) as? CardCellCollectionViewCell
        else {
            return UICollectionViewCell()
        }

        let movie = movieViewModel.currentMovies[indexPath.item]
        let posterURL = movie.posterPath.flatMap {
            URL(string: "https://image.tmdb.org/t/p/w500\($0)")
        }
        cell.configure(
            titulo: movie.title,
            fecha: movie.releaseDate,
            posterURL: posterURL
        )
        return cell
    }
}

// MARK: - UICollectionViewDelegate
extension HomeViewController: UICollectionViewDelegate {

    ///Delegado que nos sirve para llevarnos ala pagina de peliculas detalle al seleccionar una pelicula en el uicollection
    func collectionView(
        _ collectionView: UICollectionView,
        didSelectItemAt indexPath: IndexPath
    ) {

        let movie = movieViewModel.currentMovies[indexPath.item]

        let storyboard = UIStoryboard(name: "MoviesDetailView", bundle: nil)

        let viewController =
            storyboard.instantiateViewController(
                withIdentifier: "MoviesDetailViewController"
            ) as! MoviesDetailViewController
        viewController.movie = movie
        self.navigationController?.pushViewController(
            viewController,
            animated: true
        )
    }

    ///Especificamos que cuando cargue una nueva celda cargue mas peliculas.
    func collectionView(
        _ collectionView: UICollectionView,
        willDisplay cell: UICollectionViewCell,
        forItemAt indexPath: IndexPath
    ) {
        let movie = movieViewModel.movies[indexPath.item]
        movieViewModel.loadMore(movie)

        if movieViewModel.isLoading {
            reloadCollection()
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {

    ///Especificamos el tamaño que va tomar el collection view cell en pantalla
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let padding: CGFloat = 10
        let isLandscape =
            collectionView.frame.width > collectionView.frame.height
        let itemsPerRow: CGFloat = isLandscape ? 3 : 2

        let availableWidth =
            collectionView.frame.width - (padding * (itemsPerRow + 1))
        let width = availableWidth / itemsPerRow
        let height = width * 1

        return CGSize(width: width, height: height)
    }

    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        10
    }
}

// MARK: - UISearchBarDelegate
extension HomeViewController: UISearchBarDelegate {

    ///Configuramos el delegate para la busqueda con un timer para buscar con delay
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()
        //Configuramos el timer con un intervalo de 0.5 segundos
        searchTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false
        ) { [weak self] _ in
            guard let self = self else { return }
            
            Task { @MainActor in
                self.showSpinner()
                
                // Si el texto de la busqueda esta vacio cargaremos las peliculas iniciales en caso contrario buscaremos la pelicula especifica
                if searchText.isEmpty {
                    self.movieViewModel.loadMovies()
                } else {
                    self.movieViewModel.loadSearchMovies(movie: searchText)
                }
                self.reloadCollection()
                self.hideSpinner()
            }
        }
    }

}
