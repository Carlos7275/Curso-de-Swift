//
//  ViewController.swift
//  Constraints
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 30/10/25.
//

import UIKit

class ViewController: UIViewController,UITableViewDataSource, UITableViewDelegate,UITextFieldDelegate{
    
    let validator = FormValidator()
    
    @IBOutlet weak var txtFullName: UITextField!{
        didSet{
            txtFullName.tintColor = UIColor.lightGray
            txtFullName.setIcon(UIImage(systemName: "person.crop.circle")!)
        }
    }
    @IBOutlet weak var txtHeight: UITextField!{
        didSet{
            txtHeight.tintColor = UIColor.lightGray
            
            txtHeight.setIcon(UIImage(systemName: "ruler")!)
        }
    }
    @IBOutlet weak var dpBirthday: UIDatePicker!
    @IBOutlet weak var tbPersons: UITableView!
    
    @IBOutlet weak var spHeight: UIStepper!
    var editingIndex: Int? = nil
    var cancelButton: UIButton?

    
    
    var persons: [Person] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        tbPersons.dataSource = self
        tbPersons.delegate = self
        txtHeight.delegate = self
        
        spHeight.minimumValue = 0.5
        spHeight.maximumValue = 2.5
        spHeight.stepValue = 0.01
        spHeight.value = 0

       
        
        validator.register(field: txtFullName, rules: [required, maxLength(60)])
        validator.register(field: txtHeight, rules: [required,isDecimal,validHeight])
        validator.register(field: dpBirthday, rules: [required,validBirthday()])
        
    }
    
    //Counter persons in table
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    //Can delete a row
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    //Delete row in array and table
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //IF editingIndex is the same then delete edition mode
        if editingIndex == indexPath.row {
            tableView.deselectRow(at: indexPath, animated: true)
            editingIndex = nil
            cleanForm()
        } else {
            let person = persons[indexPath.row]
            txtFullName.text = person.fullname
            txtHeight.text = String(format: "%.2f", person.height)
            dpBirthday.date = person.birthDay as Date
            spHeight.value = person.height
            
            editingIndex = indexPath.row
        }
    }

    
    //Table Headers
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 40))
        headerView.backgroundColor = UIColor.systemGray6
        
        let totalWidth = tableView.frame.width
        let nameWidth = totalWidth * 0.4
        let heightWidth = totalWidth * 0.2
        let birthdayWidth = totalWidth * 0.4
        
        let nameLabel = UILabel(frame: CGRect(x: 5, y: 5, width: nameWidth-10, height: headerView.frame.height-10))
        nameLabel.text = "Full Name"
        nameLabel.font = .boldSystemFont(ofSize: 14)
        nameLabel.textColor = .black
        headerView.addSubview(nameLabel)
        
        let heightLabel = UILabel(frame: CGRect(x: nameWidth + 5, y: 5, width: heightWidth-10, height: headerView.frame.height-10))
        heightLabel.text = "Height"
        heightLabel.font = .boldSystemFont(ofSize: 14)
        heightLabel.textColor = .black
        headerView.addSubview(heightLabel)
        
        let birthdayLabel = UILabel(frame: CGRect(x: nameWidth + heightWidth + 5, y: 5, width: birthdayWidth-10, height: headerView.frame.height-10))
        birthdayLabel.text = "Birthday"
        birthdayLabel.font = .boldSystemFont(ofSize: 14)
        birthdayLabel.textColor = .black
        headerView.addSubview(birthdayLabel)
        
        return headerView
    }
    
    // Altura del header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //format table with data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping;
        
        let person = persons[indexPath.row]
        cell.textLabel?.text = person.fullname
        
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let birthdayString = formatter.string(from: person.birthDay as Date)
        cell.detailTextLabel?.text = "\(person.height) \t  \(birthdayString)"
        
        
        
        return cell
    }
    
    //Add Persons with Validation
    @IBAction func btnAdd(_ sender: Any) {
        
        guard validator.validateAll() else { return }
        
        let person = Person(fullname: txtFullName.text!,
                            height: Double(txtHeight.text!) ?? 0,
                            birthDay: dpBirthday.date as NSDate)
        
        if let index = editingIndex {
            // Estamos editando
            persons[index] = person
            editingIndex = -1
        } else {
            // Nuevo registro
            persons.append(person)
        }
        
        tbPersons.reloadData()
        cleanForm()
        
        let alert = UIAlertController(title: nil, message: "Person saved", preferredStyle: .actionSheet)
        present(alert, animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            alert.dismiss(animated: true, completion: nil)
        }
        
    }
    //Cleaning form
    func cleanForm(){
        txtFullName.text = ""
        txtHeight.text = ""
        dpBirthday.date = Date()
    }
    
    //Setting a Height in textField
    
    @IBAction func spHeightChanged(_ sender: UIStepper) {
        
        txtHeight.text = String(format: "%.2f", sender.value)
    }
    
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtHeight {
            let allowedCharacters = "0123456789."
            let characterSet = CharacterSet(charactersIn: allowedCharacters)
            let typedCharacterSet = CharacterSet(charactersIn: string)
            
            if !characterSet.isSuperset(of: typedCharacterSet) {
                return false
            }
            
            let currentText = textField.text ?? ""
            if currentText.contains(".") && string.contains(".") {
                return false
            }
        }
        return true
    }
    
    
    
}

