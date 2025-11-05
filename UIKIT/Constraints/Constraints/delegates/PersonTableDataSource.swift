
import UIKit

class PersonTableDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var persons: [Person] = []
    var didSelect: ((Int) -> Void)?  // Callback cuando se selecciona un índice

    // Número de filas
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func add(_ person: Person) {
           persons.append(person)
       }

       func update(_ person: Person, at index: Int) {
           guard index >= 0 && index < persons.count else { return }
           persons[index] = person
       }

       func remove(at index: Int) {
           guard index >= 0 && index < persons.count else { return }
           persons.remove(at: index)
       }

    // Configuración de celda
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        let person = persons[indexPath.row]

        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = .byWordWrapping
        cell.textLabel?.text = person.fullname

        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        let birthdayString = formatter.string(from: person.birthDay as Date)
        cell.detailTextLabel?.text = "\(person.height) m \t \(birthdayString)"

        return cell
    }

    // Header
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
        headerView.addSubview(nameLabel)

        let heightLabel = UILabel(frame: CGRect(x: nameWidth + 5, y: 5, width: heightWidth-10, height: headerView.frame.height-10))
        heightLabel.text = "Height"
        heightLabel.font = .boldSystemFont(ofSize: 14)
        headerView.addSubview(heightLabel)

        let birthdayLabel = UILabel(frame: CGRect(x: nameWidth + heightWidth + 5, y: 5, width: birthdayWidth-10, height: headerView.frame.height-10))
        birthdayLabel.text = "Birthday"
        birthdayLabel.font = .boldSystemFont(ofSize: 14)
        headerView.addSubview(birthdayLabel)

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    // Selección
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelect?(indexPath.row)
    }

    // Eliminar
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            persons.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
}
