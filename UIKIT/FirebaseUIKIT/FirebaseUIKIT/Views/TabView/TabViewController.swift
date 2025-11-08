import UIKit

class TabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewControllers = setUpViewControllers()
        self.setViewControllers(viewControllers, animated: false)
        setUpAppearance()
    }

    // MARK: - Setup Tabs
    private func setUpViewControllers() -> [UINavigationController] {

        let uiEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: -5, right: 0)

        // Home
        let homeStoryboard = UIStoryboard(name: "HomeView", bundle: nil)
        let homeVC = homeStoryboard.instantiateInitialViewController() as! HomeViewController
        homeVC.tabBarItem = UITabBarItem(title: "Inicio",
                                         image: UIImage(systemName: "house"),
                                         selectedImage: UIImage(systemName: "house.fill"))
        homeVC.tabBarItem.imageInsets = uiEdgeInsets
        let navHome = UINavigationController(rootViewController: homeVC)

        // Diario (desde otro storyboard)
        let diarioStoryboard = UIStoryboard(name: "DiarioView", bundle: nil)
        let diariosVC = diarioStoryboard.instantiateInitialViewController() as! DiarioViewController
        
        
        diariosVC.tabBarItem = UITabBarItem(title: "Mis escritos",
                                            image: UIImage(systemName: "book"),
                                            selectedImage: UIImage(systemName: "book.fill"))
        diariosVC.tabBarItem.imageInsets = uiEdgeInsets
        let navDiarios = generateNavController(vc: diariosVC, title:"Mis Escritos")
        
        let perfil = PerfilViewController()
        let navPerfil = generateNavController(vc: perfil, title: "Perfil")
        
        perfil.tabBarItem = UITabBarItem(title: "Perfil",
                                            image: UIImage(systemName: "person"),
                                            selectedImage: UIImage(systemName: "person.fill"))
        perfil.tabBarItem.imageInsets = uiEdgeInsets
        
        

        return [navHome, navDiarios,navPerfil]
    }



    // MARK: - Navigation Controllers
    private func generateNavController(vc: UIViewController, title: String) -> UINavigationController {
        let navController = UINavigationController(rootViewController: vc)
        vc.navigationItem.title = title


        return navController
    }

 

    // MARK: - Tab & Nav appearance
    private func setUpAppearance() {
        UITabBar.appearance().tintColor = UIColor.systemBlue
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray

        if #available(iOS 15.0, *) {
            let tabAppearance = UITabBarAppearance()
            tabAppearance.configureWithOpaqueBackground()
            tabAppearance.backgroundColor = .white
            UITabBar.appearance().standardAppearance = tabAppearance
            UITabBar.appearance().scrollEdgeAppearance = tabAppearance

            let navAppearance = UINavigationBarAppearance()
            navAppearance.configureWithOpaqueBackground()
            navAppearance.backgroundColor = .white
            navAppearance.titleTextAttributes = [.foregroundColor: UIColor.black]
            UINavigationBar.appearance().standardAppearance = navAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = navAppearance
        }
    }
}
