//
//  ViewController.swift
//  Constraints
//

import UIKit
import Foundation

class ViewController: UIViewController {

    // MARK: - Properties
    let validator = FormValidator()
    private var tableDataSource = PersonTableDataSource()
    private var editingIndex: Int? = nil

    // MARK: - Outlets
    @IBOutlet weak var txtFullName: UITextField! {
        didSet {
            txtFullName.tintColor = .lightGray
            txtFullName.setIcon(UIImage(systemName: "person.crop.circle")!)
            txtFullName.delegate = self
        }
    }
    @IBOutlet weak var txtHeight: UITextField! {
        didSet {
            txtHeight.tintColor = .lightGray
            txtHeight.setIcon(UIImage(systemName: "ruler")!)
            txtHeight.delegate = self
        }
    }
    @IBOutlet weak var dpBirthday: UIDatePicker!
    @IBOutlet weak var tbPersons: UITableView!
    @IBOutlet weak var spHeight: UIStepper! {
        didSet {
            spHeight.minimumValue = 0.5
            spHeight.maximumValue = 2.5
            spHeight.stepValue = 0.01
        }
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTable()
        registerValidations()
        loadPersons()
    }

    // MARK: - Setup
    private func setupTable() {
        tbPersons.dataSource = tableDataSource
        tbPersons.delegate = tableDataSource
        
        tableDataSource.didSelect = { [weak self] index in
            self?.handleSelection(at: index)
        }
    }

    private func registerValidations() {
        validator.register(field: txtFullName, rules: [required, maxLength(60)])
        validator.register(field: txtHeight, rules: [required, isDecimal, validHeight])
        validator.register(field: dpBirthday, rules: [required, validBirthday()])
    }

    // MARK: - Actions
    @IBAction func btnAdd(_ sender: Any) {
        guard validator.validateAll() else { return }
        
        let person = Person(fullname: txtFullName.text!,
                            height: Double(txtHeight.text!) ?? 0,
                            birthDay: dpBirthday.date )
        
        if let index = editingIndex {
            tableDataSource.update(person, at: index)
            editingIndex = nil
        } else {
            tableDataSource.add(person)
        }
        
        tbPersons.reloadData()
        cleanForm()
        AlertHelper.showAlert(on: self, message: "Person saved")
        savePersons()

    }

    @IBAction func spHeightChanged(_ sender: UIStepper) {
        txtHeight.text = String(format: "%.2f", sender.value)
    }

    // MARK: - Helpers
    private func handleSelection(at index: Int) {
        if editingIndex == index {
            cleanForm()
            editingIndex = nil
            tbPersons.deselectRow(at: IndexPath(row: index, section: 0), animated: true)
        } else {
            let person = tableDataSource.persons[index]
            fillForm(with: person)
            editingIndex = index
        }
    }

    private func fillForm(with person: Person) {
        txtFullName.text = person.fullname
        txtHeight.text = String(format: "%.2f", person.height)
        dpBirthday.date = person.birthDay as Date
        spHeight.value = person.height
    }

    private func cleanForm() {
        txtFullName.text = ""
        txtHeight.text = ""
        dpBirthday.date = Date()
        spHeight.value = 0
    }
    func savePersons() {
        let encoder = JSONEncoder()
        if let data = try? encoder.encode(tableDataSource.persons) {
            UserDefaults.standard.set(data, forKey: "persons")
        }
    }

    func loadPersons() {
        if let data = UserDefaults.standard.data(forKey: "persons") {
            let decoder = JSONDecoder()
            if let savedPersons = try? decoder.decode([Person].self, from: data) {
                tableDataSource.persons = savedPersons
            }
        }
    }

}



// MARK: - UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if textField == txtHeight {
            return TextFieldValidator.allowDecimalInput(currentText: textField.text, replacementString: string)
        }
        return true
    }
}
 
