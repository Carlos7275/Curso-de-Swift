//
//  EjemploTableViewController.swift
//  DifflableDataSource
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/12/25.
//

import UIKit

class EjemploTableViewController: UIViewController, UITableViewDelegate {
    typealias DataSource = UITableViewDiffableDataSource<Section, Message>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, Message>

    @IBOutlet weak var tvData: UITableView!
    private lazy var dataSource = makeDataSource()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupTableView()
        applySnapshot()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        applySnapshot()
    }

    func makeDataSource() -> DataSource {
        let reuseIdentifier = "ExampleTableViewCell"

        return UITableViewDiffableDataSource(tableView: tvData) {
            tableView,
            indexPath,
            message in
            let cell =
                tableView.dequeueReusableCell(
                    withIdentifier: reuseIdentifier,
                    for: indexPath
                ) as! ExampleTableViewCell

            cell.configure(
                message: message.text,
                image: message.systemImageName
            )
            return cell
        }
    }

    func applySnapshot(animatingDifferences: Bool = true) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(items)
        updateEmptyView()
        dataSource.apply(snapshot, animatingDifferences: animatingDifferences)
    }

    func setupTableView() {

        tvData.delegate = self

        tvData.register(
            UINib(nibName: "ExampleTableViewCell", bundle: nil),
            forCellReuseIdentifier: "ExampleTableViewCell"
        )

        tvData.rowHeight = UITableView.automaticDimension
        tvData.rowHeight = 90

    }

    // Swipe para la derecha (trailing)
    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        guard let message = dataSource.itemIdentifier(for: indexPath) else {
            return nil
        }

        let deleteAction = UIContextualAction(
            style: .destructive,
            title: "Eliminar"
        ) { [weak self] _, _, completionHandler in
            guard let self = self else { return }

            if let index = items.firstIndex(of: message) {
                items.remove(at: index)
            }

            self.applySnapshot()
            completionHandler(true)
        }

        // Puedes agregar más acciones aquí
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true
        return configuration
    }

    private func updateEmptyView() {
        if items.isEmpty {
            tvData.backgroundView = emptyView

            // Centrar el stack en la collectionView
            NSLayoutConstraint.activate([
                tvData.centerXAnchor.constraint(
                    equalTo: tvData.centerXAnchor
                ),
                tvData.centerYAnchor.constraint(
                    equalTo: tvData.centerYAnchor
                ),
            ])
        } else {
            tvData.backgroundView = nil
        }
    }

}
