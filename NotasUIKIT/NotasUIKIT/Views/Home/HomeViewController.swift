//
//  HomeViewController.swift
//  NotasUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 05/11/25.
//

import CoreData
import UIKit

class HomeViewController: UIViewController, UITableViewDelegate,
    UITableViewDataSource, NSFetchedResultsControllerDelegate
{

    @IBOutlet weak var tbNotas: UITableView!
    var notas = [Notas]()
    var fetchedResultsController: NSFetchedResultsController<Notas>!

    override func viewDidLoad() {
        super.viewDidLoad()
        tbNotas.delegate = self
        tbNotas.dataSource = self
        mostrarNotas()

    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return notas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {
        let celda = tbNotas.dequeueReusableCell(
            withIdentifier: "celda",
            for: indexPath
        )
        let nota = notas[indexPath.row]

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        dateFormatter.timeStyle = .medium
        dateFormatter.locale = Locale.current

        var contenido = celda.defaultContentConfiguration()
        contenido.text = nota.titulo

        contenido.secondaryText = dateFormatter.string(
            from: nota.fecha ?? Date()
        )
        celda.contentConfiguration = contenido

        return celda

    }

    //FetchedResult
    func mostrarNotas() {
        let contexto = NotasModel.shared.obtenerContexto()
        let fetchRequest: NSFetchRequest<Notas> = Notas.fetchRequest()
        let ordenamiento = NSSortDescriptor(key: "titulo", ascending: true)

        fetchRequest.sortDescriptors = [ordenamiento]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: contexto,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
            notas = fetchedResultsController.fetchedObjects ?? []
            actualizarMensajeVacio()
        } catch let error as NSError {
            print("Error: " + error.localizedDescription)
        }
    }

    func controller(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>,
        didChange anObject: Any,
        at indexPath: IndexPath?,
        for type: NSFetchedResultsChangeType,
        newIndexPath: IndexPath?
    ) {
        switch type {
        case .insert:
            self.tbNotas.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            self.tbNotas.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            self.tbNotas.reloadRows(at: [indexPath!], with: .fade)
        default:
            self.tbNotas.reloadData()
        }
        self.notas = controller.fetchedObjects as! [Notas]
        actualizarMensajeVacio()  
    }

    func controllerWillChangeContent(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
        tbNotas.beginUpdates()

    }

    func controllerDidChangeContent(
        _ controller: NSFetchedResultsController<any NSFetchRequestResult>
    ) {
        tbNotas.endUpdates()
    }

    func tableView(
        _ tableView: UITableView,
        trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
    ) -> UISwipeActionsConfiguration? {

        let eliminar = UIContextualAction(
            style: .destructive,
            title: "Eliminar"
        ) { (_, _, _) in
            let contexto = NotasModel.shared.obtenerContexto()
            let notaAEliminar = self.fetchedResultsController.object(
                at: indexPath
            )
            NotasModel.shared.eliminarNota(
                nota: notaAEliminar,
                contexto: contexto
            )

        }

        eliminar.image = UIImage(systemName: "trash")

        return UISwipeActionsConfiguration(actions: [eliminar])
    }
    func tableView(
        _ tableView: UITableView,
        didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(withIdentifier: "enviar", sender: self)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar" {
            if let id = tbNotas.indexPathForSelectedRow {
                let fila = notas[id.row]
                let destino = segue.destination as! AddViewController
                destino.nota = fila
            }

        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // Des-selecciona la fila seleccionada, si existe
        if let indexPath = tbNotas.indexPathForSelectedRow {
            tbNotas.deselectRow(at: indexPath, animated: true)
        }
    }

    func actualizarMensajeVacio() {
        if notas.isEmpty {
            let mensaje = UILabel()
            mensaje.text = "No hay notas"
            mensaje.textColor = .gray
            mensaje.textAlignment = .center
            mensaje.font = UIFont.systemFont(ofSize: 18, weight: .medium)
            tbNotas.backgroundView = mensaje
            tbNotas.separatorStyle = .none
        } else {
            tbNotas.backgroundView = nil
            tbNotas.separatorStyle = .singleLine
        }
    }

}
