//
//  GFTabBarViewController.swift
//  GHFollowers
//
//  Created by Ankith on 07/01/24.
//

import UIKit

class GFTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().tintColor = .systemGreen
        viewControllers = [createSearchNavigationController(),createFavouriteNavigationController()]
        tabBar.tintColor = .systemGreen
    }
    
    func createSearchNavigationController()->UINavigationController{
        let viewController = SearchViewController()
        viewController.title = "Search"
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .search, tag: 0)
        
        return UINavigationController(rootViewController: viewController)
    }
    
    func createFavouriteNavigationController()->UINavigationController{
        let viewController = FavouriteListViewController()
        viewController.title = "Favourites"
        viewController.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites  , tag: 1)
        return UINavigationController(rootViewController: viewController)
    }

}
