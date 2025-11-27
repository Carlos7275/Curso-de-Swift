//
//  SplashScreenViewController.swift
//  ChatApp
//
//  Created by CARLOS FERNANDO SANDOVAL LIZARRAGA on 26/11/25.
//

import UIKit

class SplashViewController: UIViewController {
    let messageViewModel = MessagesViewModel.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "username") != nil {
            messageViewModel.showChatApp = true
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !messageViewModel.showChatApp {
            goToPage(name: "UserView")
        } else {
            goToPage(name: "ChatView")
        }

    }

    // MARK: - Funciones de navegación

    func goToPage(name: String) {
        // 1. Cargar storyboard por nombre
        let storyboard = UIStoryboard(name: name, bundle: nil)

        // 2. Obtener el ViewController inicial
        guard let vc = storyboard.instantiateInitialViewController() else {
            print("❌ No se encontró el Initial View Controller en \(name)")
            return
        }

        // 3. Obtener la ventana activa (SceneDelegate)
        guard
            let windowScene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
            let window = windowScene.windows.first
        else {
            print("❌ No se encontró la ventana principal")
            return
        }

        // 4. Cambiar el root view controller
        window.rootViewController = vc
        window.makeKeyAndVisible()

        // 5. (Opcional) animación suave
        UIView.transition(
            with: window,
            duration: 0.3,
            options: .transitionCrossDissolve,
            animations: nil
        )
    }

    // MARK: - Función helper moderna para iOS 15+
    private func setRootViewController(_ vc: UIViewController) {
        DispatchQueue.main.async {  // asegurar hilo principal
            // Intenta obtener ventana desde view.window
            if let windowScene = self.view.window?.windowScene,
                let window = windowScene.windows.first
            {
                window.rootViewController = vc
                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: nil
                )
            }
            // Fallback usando connectedScenes
            else if let scene = UIApplication.shared.connectedScenes.first
                as? UIWindowScene,
                let window = scene.windows.first
            {
                window.rootViewController = vc
                UIView.transition(
                    with: window,
                    duration: 0.3,
                    options: .transitionCrossDissolve,
                    animations: nil
                )
            } else {
                print(
                    "No se pudo encontrar la ventana para cambiar rootViewController"
                )
            }
        }
    }

}
