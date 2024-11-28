import UIKit
import Foundation

class HeroeDetailCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var transformationImageView: UIImageView!
    @IBOutlet weak var transformationNameLabel: UILabel!
    
    // MARK: - Configure Method
    func configure(with transformation: TransformationsModel) {
        // Configurar el nombre de la transformación
        transformationNameLabel.text = transformation.name
        
        // Cargar la imagen de manera remota
        if let url = URL(string: transformation.photo) {
            transformationImageView.loadImageRemote(url: url)
        }
    }
}
