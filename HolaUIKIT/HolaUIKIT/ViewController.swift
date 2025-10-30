//
//  ViewController.swift
//  HolaUIKIT
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import UIKit

class ViewController: UIViewController {

    let name = "Carlos Fernando Sandoval Lizarraga"
    let birthDay = DateComponents(year: 2001, month: 2, day: 14)
    let height: Double = 1.72
    let career = "Software Engineer"
    
    @IBOutlet weak var lblProfession: UILabel!
    @IBOutlet weak var lblHeight: UILabel!
    @IBOutlet weak var lblBirth: UILabel!
    @IBOutlet weak var lblAge: UILabel!
    @IBOutlet weak var lblName: UILabel!
    
    @IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Adjusting image radius 
        imageView.layer.cornerRadius = imageView.bounds.height / 2;
        imageView.layer.borderColor = UIColor.label.cgColor

       
        //Setting the data in labels
        lblName.text = name
        lblHeight.text = "\(height) m"
        lblBirth.text = Calendar.current.date(from: birthDay)
            .map { DateFormatter.localizedString(from: $0, dateStyle: .long, timeStyle: .none) } ?? ""
    
        lblAge.text = "\(DateUtils.calculateAge(birthDay: birthDay)) years"
        lblProfession.text = career
       

    }


}

