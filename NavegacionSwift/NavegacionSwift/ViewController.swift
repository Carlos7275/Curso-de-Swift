//
//  ViewController.swift
//  NavegacionSwift
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import UIKit

class ViewController: UIViewController {

    let hola = "Saludos desde ViewController"
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue .identifier == "routerMain"{
            let destino = segue.destination as? SecondViewController
            destino?.saludo = hola
        }
    }
    
    @IBAction func regresarInicio(segue:UIStoryboardSegue){
        
    }

}

