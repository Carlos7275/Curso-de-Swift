//
//  EjemploCollectionViewController.swift
//  DifflableDataSource
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/12/25.
//

import UIKit

class EjemploCollectionViewController: UIViewController,
    UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
{

    typealias DataSource = UICollectionViewDiffableDataSource<Section, Message>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Message>

    @IBOutlet weak var collectionView: UICollectionView!
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        applySnapshot()
        updateEmptyView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot()
    }
    // MARK: - DataSource
    func makeDataSource() -> DataSource {
        let reuseIdentifier = "ExampleCollectionViewCell"

        return UICollectionViewDiffableDataSource(
            collectionView: collectionView
        ) { collectionView, indexPath, message in
            let cell =
                collectionView.dequeueReusableCell(
                    withReuseIdentifier: reuseIdentifier,
                    for: indexPath
                ) as! ExampleCollectionViewCell

            cell.configure(
                message: message.text,
                image: message.systemImageName
            )

            cell.layer.cornerRadius = 10
            cell.layer.masksToBounds = true
            cell.layer.borderWidth = 1
            cell.layer.borderColor = UIColor.lightGray.cgColor

            return cell
        }
    }

    // MARK: - Snapshot
    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
        updateEmptyView()
    }

    // MARK: - Setup CollectionView
    func setupCollectionView() {
        collectionView.delegate = self
        collectionView.isPagingEnabled = true  // Paginado 1 celda por página

        collectionView.register(
            UINib(nibName: "ExampleCollectionViewCell", bundle: nil),
            forCellWithReuseIdentifier: "ExampleCollectionViewCell"
        )

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.sectionInset = .zero
        collectionView.collectionViewLayout = layout

        collectionView.showsHorizontalScrollIndicator = false
    }

    // MARK: - FlowLayout
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        // Una celda ocupa todo el ancho del collectionView
        let width = collectionView.frame.width
        let height = collectionView.frame.height
        return CGSize(width: width, height: height)
    }

    // MARK: - Context Menu (solo eliminar)
    func collectionView(
        _ collectionView: UICollectionView,
        contextMenuConfigurationForItemAt indexPath: IndexPath,
        point: CGPoint
    ) -> UIContextMenuConfiguration? {

        guard let message = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }

        return UIContextMenuConfiguration(
            identifier: indexPath as NSCopying,
            previewProvider: nil
        ) { [weak self] _ -> UIMenu? in
            guard let self = self else { return nil }

            let delete = UIAction(
                title: "Eliminar",
                image: UIImage(systemName: "trash"),
                attributes: .destructive
            ) { _ in
                if let index = items.firstIndex(of: message) {
                    items.remove(at: index)
                }
                self.applySnapshot()
            }

            return UIMenu(title: "", children: [delete])
        }
    }

    // MARK: - Empty View
    private func updateEmptyView() {
        if items.isEmpty {
            collectionView.backgroundView = emptyView

            // Centrar el stack en la collectionView
            NSLayoutConstraint.activate([
                emptyView.centerXAnchor.constraint(
                    equalTo: collectionView.centerXAnchor
                ),
                emptyView.centerYAnchor.constraint(
                    equalTo: collectionView.centerYAnchor
                ),
            ])
        } else {
            collectionView.backgroundView = nil
        }
    }
}
