import UIKit

class AddViewController: UIViewController {

    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtDescripcion: UITextView!
    @IBOutlet weak var dpFecha: UIDatePicker!
    @IBOutlet weak var btnGuardar: UIButton!

    var nota: Notas?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = nota != nil ? "Editar Nota" : "Agregar Nota"

        txtTitulo.text = nota?.titulo
        txtDescripcion.text = nota?.descripcion
        dpFecha.date = nota?.fecha ?? Date()

        // Configurar validación
        configurarValidaciones()
        actualizarEstadoBoton()
    }

    @IBAction func btnGuardarAction(_ sender: UIButton) {
        guard let titulo = txtTitulo.text,
            let descripcion = txtDescripcion.text
        else { return }

        if nota != nil {
            NotasModel.shared.editarNota(
                titulo: titulo,
                descripcion: descripcion,
                fecha: dpFecha.date,
                nota: nota!
            )
        } else {
            NotasModel.shared.guardarNota(
                titulo: titulo,
                descripcion: descripcion,
                fecha: dpFecha.date
            )
        }

        navigationController?.popViewController(animated: true)
    }

    // MARK: - Validaciones

    func configurarValidaciones() {
        btnGuardar.isEnabled = false
        btnGuardar.backgroundColor = .gray

        txtTitulo.addTarget(
            self,
            action: #selector(textFieldDidChange),
            for: .editingChanged
        )
        txtDescripcion.delegate = self
    }

    @objc func textFieldDidChange(_ sender: UITextField) {
        actualizarEstadoBoton()
    }

    func actualizarEstadoBoton() {
        let tituloValido =
            !(txtTitulo.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            .isEmpty ?? true)
        let descripcionValida =
            !(txtDescripcion.text.trimmingCharacters(
                in: .whitespacesAndNewlines
            ).isEmpty)

        if tituloValido && descripcionValida {
            btnGuardar.isEnabled = true
            btnGuardar.backgroundColor = .systemBlue
        } else {
            btnGuardar.isEnabled = false
            btnGuardar.backgroundColor = .gray
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Limpiar campos
        txtTitulo.text = ""
        txtDescripcion.text = ""
        dpFecha.date = Date()
        nota = nil

        // Deshabilitar botón guardar
        btnGuardar.isEnabled = false
        btnGuardar.backgroundColor = .gray
    }
}

// MARK: - UITextViewDelegate
extension AddViewController: UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        actualizarEstadoBoton()
    }
}
