//
//  ColeccionViewController.swift
//  Tablas
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 04/11/25.
//

import UIKit

class ColeccionViewController: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource{
  
    
    @IBOutlet weak var coleccionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        coleccionView.delegate=self
        coleccionView.dataSource=self
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return lista.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = coleccionView.dequeueReusableCell(withReuseIdentifier:"celda", for: indexPath) as! CeldaCollectionViewCell
        
        let list = lista[indexPath.row]
        cell.lblNombre.text=list.nombre
        cell.imagen.image=UIImage(systemName: "person.crop.circle.fill")
        return cell
    }
    
    
    
    
}
