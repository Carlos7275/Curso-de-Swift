import UIKit

class CarrouselCellView: UICollectionViewCell {

    @IBOutlet weak var imagen: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupImageView()
    }
    
    private func setupImageView() {
        imagen.contentMode = .scaleAspectFill
        imagen.clipsToBounds = true
        imagen.layer.cornerRadius = self.frame.height * 0.2 // 20% de la altura
    }
    
    /// Configura la celda con la URL de la imagen
    func configure(with imagePath: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500\(imagePath)") else {
            imagen.image = UIImage(systemName: "photo")
            return
        }
        
        // Cargar imagen de forma asíncrona
        DispatchQueue.global().async {
            if let data = try? Data(contentsOf: url) {
                let image = UIImage(data: data)
                DispatchQueue.main.async {
                    self.imagen.image = image
                }
            } else {
                DispatchQueue.main.async {
                    self.imagen.image = UIImage(systemName: "photo")
                }
            }
        }
    }
}
