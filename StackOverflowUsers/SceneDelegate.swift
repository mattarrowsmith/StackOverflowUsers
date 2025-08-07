//
//  SceneDelegate.swift
//  StackOverflowUsers
//
//  Created by Arrowsmith, Matthew on 04/08/2025.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let viewController = UserListViewController(nibName: "UserListViewController", bundle: nil)
        window.rootViewController = viewController
        self.window = window
        window.makeKeyAndVisible()
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        CoreDataStore().saveContext()
    }
}

