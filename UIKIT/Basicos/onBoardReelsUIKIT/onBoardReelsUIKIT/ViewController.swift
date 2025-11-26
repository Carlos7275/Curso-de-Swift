import UIKit

class ViewController: UIViewController,
    UICollectionViewDelegate,
    UICollectionViewDataSource,
    UICollectionViewDelegateFlowLayout
{
    var datos: [[String: String]] = [
        [
            "descripcion":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
            "imagen": "info",
        ],
        [
            "descripcion":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
            "imagen": "document",
        ],

        [
            "descripcion":
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
            "imagen": "pencil",
        ],
    ]

    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var collectionCarrousel: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()

        // inicializa el pageControl aquí
        pageControl.numberOfPages = datos.count
        pageControl.currentPage = 0
    }

    private func setupCollectionView() {
        collectionCarrousel.delegate = self
        collectionCarrousel.dataSource = self

        let nib = UINib(nibName: "CarrouselViewCell", bundle: nil)
        collectionCarrousel.register(
            nib,
            forCellWithReuseIdentifier: "CarrouselViewCell"
        )

        // Opcional: asegúrate de que no haya inset que cambien el offset
        collectionCarrousel.contentInsetAdjustmentBehavior = .never
        collectionCarrousel.showsHorizontalScrollIndicator = false
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        if let layout = collectionCarrousel.collectionViewLayout
            as? UICollectionViewFlowLayout
        {
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 0
            layout.itemSize = collectionCarrousel.bounds.size
        }

        collectionCarrousel.isPagingEnabled = true
        collectionCarrousel.showsHorizontalScrollIndicator = false
        collectionCarrousel.collectionViewLayout.invalidateLayout()
    }
    // MARK: - DataSource

    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        return datos.count
    }

    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard
            let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: "CarrouselViewCell",
                for: indexPath
            ) as? CarrouselViewCell
        else {
            return UICollectionViewCell()
        }
        let dato = datos[indexPath.item]

        cell.configure(
            descripcion: dato["descripcion"] ?? "",
            image: dato["imagen"] ?? ""
        )
        return cell
    }

    // MARK: - Layout delegate (si no quieres usar viewDidLayoutSubviews)
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        return collectionView.bounds.size
    }

    // MARK: - Page control sync

    // Método más estable: actualizar cuando termina el scroll de desaceleración
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageControl(from: scrollView)
    }

    private func updatePageControl(from scrollView: UIScrollView) {
        let pageWidth = scrollView.bounds.width
        guard pageWidth > 0 else { return }

        // Usamos round para evitar problemas con offsets fraccionarios
        let rawPage = scrollView.contentOffset.x / pageWidth
        let page = Int(round(rawPage))

        // Protegemos el índice dentro del rango
        let safePage = max(0, min(page, datos.count - 1))

        if pageControl.currentPage != safePage {
            pageControl.currentPage = safePage
        }
    }
    @IBAction func pageChanged(_ sender: UIPageControl) {
        let page = sender.currentPage
        let indexPath = IndexPath(item: page, section: 0)

        collectionCarrousel.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
    }
    @IBAction func btnIrFinalCarrousel(_ sender: UIButton) {
        let lastIndex = datos.count - 1
        let indexPath = IndexPath(item: lastIndex, section: 0)

        collectionCarrousel.scrollToItem(
            at: indexPath,
            at: .centeredHorizontally,
            animated: true
        )
        pageControl.currentPage = lastIndex

    }
}
