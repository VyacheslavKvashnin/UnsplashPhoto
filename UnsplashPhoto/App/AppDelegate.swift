//
//  AppDelegate.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow()
        let tabBarController = TabBarController()
        tabBarController.tabBar.backgroundColor = .systemBackground
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }
}

