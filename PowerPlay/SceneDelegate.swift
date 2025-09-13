import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = SplashViewController()
        window?.makeKeyAndVisible()

        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let navigationController = UINavigationController(rootViewController: ProductListViewController())
            
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithOpaqueBackground()
            navBarAppearance.backgroundColor = UIColor(red: 23/255, green: 37/255, blue: 84/255, alpha: 1.0)
            navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            navigationController.navigationBar.standardAppearance = navBarAppearance
            navigationController.navigationBar.scrollEdgeAppearance = navBarAppearance
            navigationController.navigationBar.tintColor = .white
            
            self.window?.rootViewController = navigationController
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}
