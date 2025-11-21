import UIKit

class HomeViewController: UIViewController {

    private let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "No se encontraron resultados"
        label.textAlignment = .center
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.isHidden = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    // MARK: - IBOutlets
    @IBOutlet weak var txtBusqueda: UISearchBar!
    @IBOutlet weak var collectionMovies: UICollectionView!

    // MARK: - Properties
    private let movieViewModel = MoviesViewModel()
    private var searchTimer: Timer?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupEmptyLabel()
        setupSpinner()
        txtBusqueda.delegate = self
        loadInitialMovies()

    }

    private func setupEmptyLabel() {
        view.addSubview(emptyLabel)
        NSLayoutConstraint.activate([
            emptyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    private func setupSpinner() {
        view.addSubview(spinner)
        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }
    // MARK: - Setup
    private func setupCollectionView() {
        collectionMovies.delegate = self
        collectionMovies.dataSource = self

        let nib = UINib(nibName: "CardCellCollectionViewCell", bundle: nil)
        collectionMovies.register(
            nib,
            forCellWithReuseIdentifier: "CardCellCollectionViewCell"
        )
    }

    private func showSpinner() {
        spinner.startAnimating()
        collectionMovies.isUserInteractionEnabled = false
    }

    private func hideSpinner() {
        spinner.stopAnimating()
        collectionMovies.isUserInteractionEnabled = true
    }

    // MARK: - Data
    private func loadInitialMovies() {
        showSpinner()
        movieViewModel.loadMovies()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.reloadCollection()
            self.hideSpinner()
        }
    }

    private func reloadCollection() {
        DispatchQueue.main.async {
            self.collectionMovies.reloadData()
            self.emptyLabel.isHidden = !self.movieViewModel.currentMovies
                .isEmpty
        }
    }

}

// MARK: - UICollectionViewDataSource
extension HomeViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        movieViewModel.currentMovies.count
    }

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

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTimer?.invalidate()

        searchTimer = Timer.scheduledTimer(
            withTimeInterval: 0.5,
            repeats: false
        ) { [weak self] _ in
            guard let self = self else { return }
            Task { @MainActor in
                self.showSpinner()
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
