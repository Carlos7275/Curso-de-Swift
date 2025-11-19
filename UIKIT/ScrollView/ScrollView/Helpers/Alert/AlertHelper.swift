import UIKit

class AlertHelper {

    static func showAlert(
        on viewController: UIViewController,
        title: String? = nil,
        message: String,
        style: UIAlertController.Style = .alert,
        duration: TimeInterval? = 1.5,
        completion: (() -> Void)? = nil
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )

        viewController.present(alert, animated: true)

        if let duration = duration {
            DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
                alert.dismiss(animated: true) {
                    completion?() // 
                }
            }
        }
    }

    static func showRetryAlert(
        on viewController: UIViewController,
        title: String? = nil,
        message: String,
        retryTitle: String = "Reintentar",
        showCancel: Bool = false,
        onRetry: @escaping () -> Void
    ) {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let retryAction = UIAlertAction(title: retryTitle, style: .default) { _ in
            onRetry()
        }
        alert.addAction(retryAction)

        if showCancel {
            let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel)
            alert.addAction(cancelAction)
        }

        alert.view.isUserInteractionEnabled = true
        viewController.present(alert, animated: true)
    }

}
