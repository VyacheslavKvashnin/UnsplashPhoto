//
//  ViewController.swift
//  UnsplashPhoto
//
//  Created by Вячеслав Квашнин on 04.06.2022.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mainVC = UINavigationController(rootViewController: MainViewController())
        let favoriteVC = UINavigationController(rootViewController: FavoriteViewController())
        mainVC.title = "Photos"
        favoriteVC.title = "Favorite"
        
        setViewControllers([mainVC, favoriteVC], animated: true)
        setIconInTabBar()
    }
    
    private func setIconInTabBar() {
        guard let items = tabBar.items else { return }
        let image = ["photo.on.rectangle", "heart.fill"]
        for i in 0 ..< items.count {
            items[i].image = UIImage(systemName: image[i])
        }
    }
}
// new
