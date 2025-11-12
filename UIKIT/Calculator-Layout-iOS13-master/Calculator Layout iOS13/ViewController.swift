import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var lblResultado: UITextField!
    var esResultadoMostrado = false

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configuración base
        lblResultado.inputView = UIView()  // sin teclado
        lblResultado.text = "0"
        lblResultado.autocorrectionType = .no
        lblResultado.spellCheckingType = .no
        lblResultado.autocapitalizationType = .none
        lblResultado.smartInsertDeleteType = .no
        lblResultado.textAlignment = .right
        lblResultado.textColor = .white
        lblResultado.font = UIFont.systemFont(ofSize: 40)
        lblResultado.delegate = self

        // Gestos de swipe
        let swipeIzquierda = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipe(_:))
        )
        swipeIzquierda.direction = .left

        let swipeDerecha = UISwipeGestureRecognizer(
            target: self,
            action: #selector(handleSwipe(_:))
        )
        swipeDerecha.direction = .right

        lblResultado.addGestureRecognizer(swipeIzquierda)
        lblResultado.addGestureRecognizer(swipeDerecha)

        lblResultado.isUserInteractionEnabled = true  // asegúrate de tener esto
    }

    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case .left:
            moverCursor(offset: -1)
        case .right:
            moverCursor(offset: 1)
        default:
            break
        }
    }

    func moverCursor(offset: Int) {
        guard let selectedRange = lblResultado.selectedTextRange else { return }
        guard
            let newPosition = lblResultado.position(
                from: selectedRange.start,
                offset: offset
            )
        else { return }
        lblResultado.selectedTextRange = lblResultado.textRange(
            from: newPosition,
            to: newPosition
        )
    }

    func cursorIndex(in textField: UITextField) -> String.Index? {
        guard
            let text = textField.text,
            let selectedRange = textField.selectedTextRange
        else { return nil }

        let cursorPosition = textField.offset(
            from: textField.beginningOfDocument,
            to: selectedRange.start
        )

        // Evitar índices fuera de rango
        guard cursorPosition >= 0 && cursorPosition <= text.utf16.count else {
            return nil
        }

        return String.Index(utf16Offset: cursorPosition, in: text)
    }

    func textField(
        _ textField: UITextField,
        shouldChangeCharactersIn range: NSRange,
        replacementString string: String
    ) -> Bool {
        // Retorna false para bloquear toda entrada de teclado
        return false
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        guard let cadena = sender.titleLabel?.text,
            let texto = lblResultado.text
        else { return }

        switch cadena {

        case "AC":
            lblResultado.text = "0"
            esResultadoMostrado = false

        case "⌫":
            guard var texto = lblResultado.text, !texto.isEmpty else { return }

            if esResultadoMostrado {
                lblResultado.text = "0"
            } else {
                if let cursor = cursorIndex(in: lblResultado),
                    cursor > texto.startIndex
                {
                    // Eliminar el carácter anterior al cursor
                    let anterior = texto.index(before: cursor)
                    texto.remove(at: anterior)
                    lblResultado.text = texto.isEmpty ? "0" : texto
                } else {
                    // Si no hay cursor o está al inicio, borrar el último carácter
                    if !texto.isEmpty {
                        texto.removeLast()
                        lblResultado.text = texto.isEmpty ? "0" : texto
                    }
                }

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
            lblResultado.text =
                resultado.truncatingRemainder(dividingBy: 1) == 0
                ? String(Int(resultado))
                : String(resultado)
            esResultadoMostrado = true

        default:
            if var texto = lblResultado.text {
                if let cursor = cursorIndex(in: lblResultado) {
                    func insertar(_ nuevo: String) {
                        texto.insert(contentsOf: nuevo, at: cursor)
                        lblResultado.text = texto
                        // Mover el cursor al final del texto insertado
                        if let nuevaPos = lblResultado.position(
                            from: lblResultado.beginningOfDocument,
                            offset: cursor.utf16Offset(in: texto) + nuevo.count
                        ) {
                            lblResultado.selectedTextRange =
                                lblResultado.textRange(
                                    from: nuevaPos,
                                    to: nuevaPos
                                )
                        }
                    }

                    let cadenaChar = Character(cadena)

                    if esResultadoMostrado && "0123456789".contains(cadena) {
                        lblResultado.text = cadena

                    } else if esResultadoMostrado && "+-x/%".contains(cadena) {
                        lblResultado.text = (lblResultado.text ?? "") + cadena

                    } else if texto == "0" && "0123456789".contains(cadena) {
                        lblResultado.text = cadena

                    } else if let ultimo = texto.last,
                        "+-x/%".contains(ultimo),
                        "+-x/%".contains(cadenaChar)
                    {
                        texto.removeLast()
                        lblResultado.text = texto + cadena

                    } else if cadena == "." {
                        let ultimoNumero =
                            texto.split(whereSeparator: { "+-x/%".contains($0) }
                            ).last ?? ""
                        if !ultimoNumero.contains(".") {
                            insertar(".")
                        }

                    } else {
                        insertar(cadena)
                    }

                    esResultadoMostrado = false
                }
            }

            esResultadoMostrado = false
        }
    }
}
