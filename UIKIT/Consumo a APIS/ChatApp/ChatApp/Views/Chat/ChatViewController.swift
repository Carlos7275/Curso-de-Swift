//
//  ChatViewController.swift
//  ChatApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import Combine
import UIKit

class ChatViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource
{

    let messageViewModel = MessagesViewModel.shared
    var cancellables = Set<AnyCancellable>()

    @IBOutlet weak var txtMensaje: UITextField!
    @IBOutlet weak var tbChat: UITableView!

    let refreshable = UIRefreshControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title =
            UserDefaults.standard.string(forKey: "username") ?? "Usuario"
        setupTableView()
        listenMessages()
        listenErrors()
    }
    func listenErrors() {
        // Suscribirse a showError
        messageViewModel.$showError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] show in
                guard show, let self = self else { return }
                if let msg = self.messageViewModel.errorMessage {
                    AlertHelper.showAlert(
                        on: self,
                        title: "Error:",
                        message: msg
                    )
                }
            }
            .store(in: &cancellables)
    }

    func listenMessages() {
        messageViewModel.$messages
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.actualizarTabla()
            }
            .store(in: &cancellables)
    }
    func setupTableView() {
        tbChat.delegate = self
        tbChat.dataSource = self
        tbChat.refreshControl = refreshable
        refreshable.addTarget(
            self,
            action: #selector(didPullToRefresh),
            for: .valueChanged
        )

        tbChat.register(
            MessageViewCell.self,
            forCellReuseIdentifier: "MessageCell"
        )
        actualizarTabla()

    }

    @objc
    func didPullToRefresh() {
        actualizarTabla()
    }
    func actualizarTabla() {
        DispatchQueue.main.async {
            self.tbChat.reloadData()

            if !self.messageViewModel.messages.isEmpty {
                let lastIndex = IndexPath(
                    row: self.messageViewModel.messages.count - 1,
                    section: 0
                )
                self.tbChat.scrollToRow(
                    at: lastIndex,
                    at: .bottom,
                    animated: false
                )
            }

            // Detener animación del refresh control
            self.refreshable.endRefreshing()
        }
    }

    @IBAction func btnEnviarMensajeAction(_ sender: Any) {
        guard let mensaje = txtMensaje.text,
            !mensaje.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
        else {
            return
        }

        messageViewModel.enviarMensaje(mensaje: mensaje)

        txtMensaje.text = ""
        actualizarTabla()
    }
    @IBAction func btnSalirAction(_ sender: Any) {
        let defaults = UserDefaults.standard
        defaults.removeObject(forKey: "username")
        defaults.removeObject(forKey: "idUser")

        goToPage(name: "UserView", window: self.view!.window!)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return messageViewModel.messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: "MessageCell",
                for: indexPath
            ) as? MessageViewCell
        else {
            return UITableViewCell()
        }

        let message = messageViewModel.messages[indexPath.row]
        cell.configure(
            message: message.text,
            sender: message.username,
            dateTime: message.timestamp
        )
        cell.selectionStyle = .none

        return cell
    }

    // Opcional: para que la celda se ajuste automáticamente al contenido
    func tableView(
        _ tableView: UITableView,
        estimatedHeightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return 100
    }

    func tableView(
        _ tableView: UITableView,
        heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        return UITableView.automaticDimension
    }

}
