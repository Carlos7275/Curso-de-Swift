//
//  ViewController.swift
//  Tablas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 03/11/25.
//

import UIKit



class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
   
    
    @IBOutlet weak var tableView: UITableView!
   

    override func viewDidLoad() {
        super.viewDidLoad()
        let appearance = UINavigationBarAppearance()
           appearance.configureWithOpaqueBackground()
           appearance.backgroundColor = .red
           appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                             .foregroundColor: UIColor.white]
           
           navigationController?.navigationBar.tintColor = .white
           navigationController?.navigationBar.standardAppearance = appearance
           navigationController?.navigationBar.scrollEdgeAppearance = appearance
        tableView.delegate = self
        tableView.dataSource = self
            
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lista.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda",for:indexPath)
        let list = lista[indexPath.row]
       //deprecado  cell.textLabel = "titulo"
        var content  = cell.defaultContentConfiguration()
        content.text = list.nombre
        content.secondaryText = list.email

        content.image = UIImage(systemName: "person.crop.circle.fill")
        cell.contentConfiguration = content
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "enviar", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "enviar"{
            let vc = segue.destination as! DetalleViewController
            let index = tableView.indexPathForSelectedRow!.row
            vc.datosLista = lista[index]
        }
    }


}

