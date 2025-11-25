//
//  SecondViewController.swift
//  NavegacionSwift
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import UIKit

class SecondViewController: UIViewController {

    @IBOutlet weak var lblResultado: UILabel!
    var saludo :String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
       
        lblResultado.text = saludo
        
    }
    

    @IBAction func btnRegresar(_ sender: UIButton) {
//        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }
    

}
