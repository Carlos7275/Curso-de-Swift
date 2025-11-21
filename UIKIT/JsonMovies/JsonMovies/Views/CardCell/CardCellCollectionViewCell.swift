import UIKit

class CardCellCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imagen: UIImageView!
    @IBOutlet weak var lblTitulo: UILabel!
    @IBOutlet weak var lblFecha: UILabel!
    
    private var dataTask: URLSessionDataTask?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupAppearance()
    }
    
    private func setupAppearance() {
        // Card style
        self.backgroundColor = UIColor.secondarySystemBackground
        self.layer.cornerRadius = 16
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.15
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowRadius = 5
        self.layer.masksToBounds = false
        
        // Imagen estilo SwiftUI
        imagen.contentMode = .scaleAspectFill
        imagen.clipsToBounds = true
        imagen.layer.cornerRadius = 12
    }
    
    func configure(titulo: String, fecha: String, posterURL: URL?) {
        lblTitulo.text = titulo
        lblFecha.text = fecha
        
        // Cancelar cualquier descarga previa
        dataTask?.cancel()
        imagen.image = UIImage(named: "placeholder")
        
        guard let url = posterURL else { return }
        
        // Descargar imagen manualmente
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil else { return }
            DispatchQueue.main.async {
                self.imagen.image = UIImage(data: data)
            }
        }
        dataTask?.resume()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        dataTask?.cancel()
        imagen.image = UIImage(named: "placeholder")
    }
}
