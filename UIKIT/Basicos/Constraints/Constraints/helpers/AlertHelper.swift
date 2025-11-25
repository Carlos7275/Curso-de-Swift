import UIKit

class AlertHelper {
    
 
    static func showAlert(
        on viewController: UIViewController,
        title: String? = nil,
        message: String,
        style: UIAlertController.Style = .alert,
        duration: TimeInterval? = 1.5
    ) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        viewController.present(alert, animated: true)
        
        // Auto-dismiss si duration es definido
        if let duration = duration {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alert.dismiss(animated: true)
            }
        }
    }
}
