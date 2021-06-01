//
//  MainTabBarController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class MainTabBarController: UITabBarController {

    let homeVC: UINavigationController = {
        let vc: UICollectionViewController = {
            let vc = HomeCollectionViewController()
            let image = UIImage(systemName: "house.fill")
            vc.tabBarItem = UITabBarItem(title: "Home", image: image, tag: 0)
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let habitVC: UINavigationController = {
        let vc: UICollectionViewController = {
            let vc = HabitCollectionViewController()
            let image = UIImage(systemName: "star.fill")
            vc.tabBarItem = UITabBarItem(title: "Habits", image: image, tag: 1)
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let userVC: UINavigationController = {
        let vc: UICollectionViewController = {
            let vc = UserCollectionViewController()
            let image = UIImage(systemName: "person.2.fill")
            vc.tabBarItem = UITabBarItem(title: "People", image: image, tag: 2)
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let logHabbitVC: UINavigationController = {
        let vc: UICollectionViewController = {
            let vc = LogHabitCollectionViewController()
            let image = UIImage(systemName: "checkmark.square.fill")
            vc.tabBarItem = UITabBarItem(title: "Log Habits", image: image, tag: 1)
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            homeVC,
            habitVC,
            userVC,
            logHabbitVC,
        ]
    }
}
