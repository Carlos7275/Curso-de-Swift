//
//  MoviesDetailViewController.swift
//  JsonMovies
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 20/11/25.
//

import UIKit

class MoviesDetailViewController: UIViewController, UICollectionViewDelegate,
    UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{

    // MARK: - IBOutlets
    @IBOutlet weak var coleccionImagenes: UICollectionView!  // Carrusel de imágenes
    @IBOutlet weak var imagen: UIImageView!  // Imagen principal
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblTituloOriginal: UILabel!
    @IBOutlet weak var lblPuntuacion: UILabel!
    @IBOutlet weak var lblVotos: UILabel!
    @IBOutlet weak var lblFechaEstreno: UILabel!
    @IBOutlet weak var lblDescripcion: UILabel!
    @IBOutlet weak var lblAceptacion: UILabel!

    // MARK: - Properties
    var movie: Movies?
    var images: [String] = []

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = movie?.title

        setupImages()
        setupCollectionView()
        setData()
       
    }
    ///Configuramos las imagenes que vendran en el carrusel en este caso son las imagenes del poster y la imagen trasera.
    private func setupImages(){
        images = [
            movie?.posterPath ?? "",
            movie?.backdropPath ?? "",
        ].filter { !$0.isEmpty }
    }

    // MARK: - Configuración del Carrusel
    ///Configuramos el collection view del carrousel con sus delegados y sus celdas personalizadas
    private func setupCollectionView() {
        coleccionImagenes.delegate = self
        coleccionImagenes.dataSource = self
        
        //Se configura la celda personalizada que tendra el collection view
        let nib = UINib(nibName: "CarrouselCellView", bundle: nil)
        coleccionImagenes.register(nib, forCellWithReuseIdentifier: "CarrouselCellView")
        // Se configura el layout del collection view
        if let layout = coleccionImagenes.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 2
            layout.minimumInteritemSpacing = 0
            layout.sectionInset = .zero
        }

        coleccionImagenes.showsHorizontalScrollIndicator = false
    }


    // MARK: - UICollectionViewDataSource
    ///Se especifica cuantas imagenes tendra el carrousel
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return images.count
    }

    ///Se especifica el formato de la celda personalizada
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CarrouselCellView",
                for: indexPath
            ) as? CarrouselCellView
        else {
            return UICollectionViewCell()
        }

        let path = images[indexPath.item]

        // Carga asincrónica de la imagen
        if let url = URL(string: "https://image.tmdb.org/t/p/w780\(path)") {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        cell.imagen.image = UIImage(data: data)
                    }
                }
            }
        } else {
            cell.imagen.image = UIImage(systemName: "photo")
        }

        // Estilos de la celda
        cell.imagen.contentMode = .scaleAspectFill
        cell.imagen.clipsToBounds = true
        cell.imagen.layer.cornerRadius = 12

        return cell
    }
    
    ///Se especifica el tamaño de la celda
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        let height = collectionView.frame.height * 1.1 // 20% más alto que el collectionView
        let width = height * 1.2 // relación de aspecto 3:2
        return CGSize(width: width, height: height)
    }


    // MARK: - Configuración de Labels e Imagen Principal
    ///Establecemos los datos alos componentes de la vista
    func setData() {
        // Imagen principal
        if let posterPath = movie?.posterPath,
            let url = URL(
                string: "https://image.tmdb.org/t/p/w342\(posterPath)"
            )
        {
            DispatchQueue.global().async {
                if let data = try? Data(contentsOf: url) {
                    DispatchQueue.main.async {
                        self.imagen.image = UIImage(data: data)
                        self.imagen.layer.cornerRadius =  25

                    }
                }
            }
        } else {
            imagen.image = UIImage(systemName: "photo")
        }

        // Título principal
        lblTitulo.text = movie?.title
        lblTitulo.font = UIFont.boldSystemFont(ofSize: 20)
        lblTitulo.textColor = .label

        // Título original
        lblTituloOriginal.text = movie?.originalTitle ?? ""
        lblTituloOriginal.font = UIFont.systemFont(ofSize: 16)
        lblTituloOriginal.textColor = .secondaryLabel

        // Puntuación
        lblPuntuacion.text = String(
            format: "⭐️ %.1f / 10",
            movie?.voteAverage ?? 0
        )
        lblPuntuacion.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        lblPuntuacion.textColor = .label

        // Votos
        lblVotos.text = "Votos: \(movie?.voteCount ?? 0)"
        lblVotos.font = UIFont.systemFont(ofSize: 16)
        lblVotos.textColor = .secondaryLabel

        // Popularidad
        lblAceptacion.text = "Popularidad: \(Int(movie?.popularity ?? 0))"
        lblAceptacion.font = UIFont.systemFont(ofSize: 16)
        lblAceptacion.textColor = .secondaryLabel

        // Fecha de estreno
        lblFechaEstreno.text = "📅 Fecha de estreno: \(movie?.releaseDate ?? "")"
        lblFechaEstreno.font = UIFont.systemFont(ofSize: 16)

        // Descripción
        lblDescripcion.text =
            (movie?.overview.isEmpty ?? true)
            ? "Sin descripción disponible." : movie?.overview
        lblDescripcion.font = UIFont.systemFont(ofSize: 16)
        lblDescripcion.textColor = .label
        lblDescripcion.numberOfLines = 0
    }
}
