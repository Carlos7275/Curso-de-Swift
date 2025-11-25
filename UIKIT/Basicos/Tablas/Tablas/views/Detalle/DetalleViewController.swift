//
//  DetalleViewController.swift
//  Tablas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import UIKit

class DetalleViewController: UIViewController {

    @IBOutlet weak var lblEmail: UILabel!
    @IBOutlet weak var lblNombre: UILabel!
    var datosLista:Persona?
    override func viewDidLoad() {
        super.viewDidLoad()
        lblNombre.text = datosLista?.nombre
        lblEmail.text = datosLista?.email
    }


}
