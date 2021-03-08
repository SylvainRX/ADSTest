import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    guard let windowScene = (scene as? UIWindowScene) else { return }

    let window = UIWindow(frame: windowScene.coordinateSpace.bounds)
    self.window = window
    window.windowScene = windowScene

    let mainViewController = MainViewController.make()
    window.rootViewController = mainViewController
    window.makeKeyAndVisible()
  }
}
