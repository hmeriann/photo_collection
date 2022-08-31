//
//  SceneDelegate.swift
//  DAY03
//
//  Created by Zuleykha Pavlichenkova on 11.08.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        window?.makeKeyAndVisible()
        let navigationController = UINavigationController()
        navigationController.viewControllers = [ViewController()]
        window?.rootViewController = navigationController
    }
}

