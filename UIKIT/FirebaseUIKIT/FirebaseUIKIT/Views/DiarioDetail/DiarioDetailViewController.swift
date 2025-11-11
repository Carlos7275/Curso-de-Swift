import UIKit

class DiarioDetailViewController: BaseViewController {

    // MARK: - Propiedades
    let validator = FormValidator()
    private let viewModel = DiariosViewModel()
    private var modo: ModoDiario

    // MARK: - Outlets
    @IBOutlet weak var txtTitulo: UITextField!
    @IBOutlet weak var txtContenido: UITextView!
    @IBOutlet weak var dpFecha: UIDatePicker!
    @IBOutlet weak var btnGuardar: UIButton!

    // MARK: - Init
    init(modo: ModoDiario) {
        self.modo = modo
        super.init(nibName: "DiarioDetailViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        estilizarContenido()
        crearFormulario()
        configurarModo()
    }

    func estilizarContenido() {
        txtContenido.layer.borderWidth = 1.0
        txtContenido.layer.borderColor = UIColor.gray.cgColor
        txtContenido.layer.cornerRadius = 8.0
    }
    // MARK: - Crear formulario
    private func crearFormulario() {
        validator.register(field: txtTitulo, rules: [required, maxLength(50)])
        validator.register(
            field: txtContenido,
            rules: [required, maxLength(1000)]
        )
        validator.register(field: dpFecha, rules: [required])
    }

    // MARK: - Configurar modo
    private func configurarModo() {
        switch modo {
        case .agregar:
            self.title = "Agregar Diario"
            btnGuardar.isHidden = false
        case .editar(let diario):
            self.title = "Editar Diario"
            cargarDatos(diario)
            btnGuardar.isHidden = false
        case .ver(let diario):
            self.title = "Ver Diario"
            cargarDatos(diario)
            hacerCamposNoEditables()
            btnGuardar.isHidden = true
            agregarBotonEditar()
        }
    }

    // MARK: - Cargar datos
    private func cargarDatos(_ diario: Diario) {
        txtTitulo.text = diario.titulo
        txtContenido.text = diario.contenido
        dpFecha.date = diario.fechaCreacion
    }

    private func hacerCamposNoEditables() {
        txtTitulo.isEnabled = false
        txtContenido.isEditable = false
        dpFecha.isEnabled = false
    }

    private func agregarBotonEditar() {
        let editarButton = UIBarButtonItem(
            title: "Editar",
            style: .plain,
            target: self,
            action: #selector(cambiarAModoEditar)
        )
        navigationItem.rightBarButtonItem = editarButton
    }

    @objc private func cambiarAModoEditar() {
        if case .ver(let diario) = modo {
            modo = .editar(diario)
            navigationItem.rightBarButtonItem = nil
            hacerCamposEditables()
            btnGuardar.isHidden = false
            self.title = "Editar Diario"
        }
    }

    private func hacerCamposEditables() {
        txtTitulo.isEnabled = true
        txtContenido.isEditable = true
        dpFecha.isEnabled = true
    }

    // MARK: - Guardar acción
    @IBAction func btnGuardarAction(_ sender: Any) {
        guard validator.validateAll() else { return }

        let diario = Diario(
            id: obtenerIDActual(),
            titulo: txtTitulo.text ?? "",
            contenido: txtContenido.text ?? "",
            fechaCreacion: dpFecha.date,
            favorito: false
        )

        switch modo {
        case .agregar:
            viewModel.agregar(diario) { [weak self] result in
                self?.mostrarResultado(result, mensajeExito: "Diario agregado")
            }
        case .editar:
            viewModel.modificar(diario) { [weak self] result in
                self?.mostrarResultado(
                    result,
                    mensajeExito: "Diario modificado"
                )
            }
        case .ver:
            break
        }
    }

    private func obtenerIDActual() -> String? {
        switch modo {
        case .editar(let diario), .ver(let diario):
            return diario.id
        case .agregar:
            return nil
        }
    }

    // MARK: - Mostrar resultado usando AlertHelper
    private func mostrarResultado(
        _ result: Result<Void, Error>,
        mensajeExito: String
    ) {
        switch result {
        case .success():
            AlertHelper.showAlert(on: self, message: mensajeExito) {
                self.navigationController?.popViewController(animated: true)
            }
        case .failure(let error):
            AlertHelper.showAlert(
                on: self,
                title: "Error",
                message: error.localizedDescription
            )
        }
    }
}
