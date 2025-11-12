import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var lblResultado: UILabel!
    var esResultadoMostrado = false

    override func viewDidLoad() {
        super.viewDidLoad()
        lblResultado.text = "0"
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let cadena = sender.titleLabel?.text,
              var texto = lblResultado.text else { return }

        switch cadena {

        case "AC":
            lblResultado.text = "0"
            esResultadoMostrado = false

        case "⌫":
            if texto.count > 1 {
                texto.removeLast()
                lblResultado.text = texto
            } else {
                lblResultado.text = "0"
            }
            esResultadoMostrado = false

        case "+/-":
            let texto = lblResultado.text ?? ""

            // Si el resultado ya se mostró, invertir todo
            if esResultadoMostrado {
                if let n = Double(texto) {
                    lblResultado.text = String(-n)
                }
                esResultadoMostrado = false
                return
            }

            // Encontrar el último número
            var i = texto.endIndex
            while i > texto.startIndex {
                let prev = texto.index(before: i)
                if "+-x/%".contains(texto[prev]) {
                    break
                }
                i = prev
            }

            let ultimoNumero = texto[i..<texto.endIndex]
            var nuevoNumero = String(ultimoNumero)

            // Si ya tiene '-', quitarlo; si no, agregarlo
            if nuevoNumero.hasPrefix("-") {
                nuevoNumero.removeFirst()
            } else {
                nuevoNumero = "-" + nuevoNumero
            }

            lblResultado.text = String(texto[..<i]) + nuevoNumero
            esResultadoMostrado = false


        case "=":
            let resultado = Calculadora().evaluar(texto)
            lblResultado.text = resultado.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(resultado))
                : String(resultado)
            esResultadoMostrado = true

        default:
            if esResultadoMostrado && "0123456789".contains(cadena) {
                lblResultado.text = cadena
            } else if esResultadoMostrado && "+-x/%".contains(cadena) {
                lblResultado.text?.append(cadena)
            } else if texto == "0" && "0123456789".contains(cadena) {
                lblResultado.text = cadena
            } else if let ultimo = texto.last,
                      "+-x/%".contains(ultimo),
                      "+-x/%".contains(Character(cadena)) {
                texto.removeLast()
                lblResultado.text = texto + cadena
            } else if cadena == "." {
                let ultimoNumero = texto.split(whereSeparator: { "+-x/%".contains($0) }).last ?? ""
                if !ultimoNumero.contains(".") { lblResultado.text?.append(".") }
            } else {
                lblResultado.text?.append(cadena)
            }
            esResultadoMostrado = false
        }
    }
}
