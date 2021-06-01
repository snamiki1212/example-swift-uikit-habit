//
//  MainTabBarController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class MainTabBarController: UITabBarController {

    let homeVC: UINavigationController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .contacts, tag: 0)
        let nav = UINavigationController(rootViewController: vc)
        
        // TODO:
        vc.view.backgroundColor = .blue
        return nav
    }()
    
    let habitVC: UINavigationController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 1)
        let nav = UINavigationController(rootViewController: vc)
        
        // TODO:
        vc.view.backgroundColor = .yellow
        return nav
    }()
    
    let peopleVC: UINavigationController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 2)
        let nav = UINavigationController(rootViewController: vc)
        
        // TODO:
        vc.view.backgroundColor = .red
        return nav
    }()
    
    let logHabbitVC: UINavigationController = {
        let vc = UIViewController()
        vc.tabBarItem = UITabBarItem(tabBarSystemItem: .more, tag: 3)
        let nav = UINavigationController(rootViewController: vc)
        
        // TODO:
        vc.view.backgroundColor = .systemPink
        return nav
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewControllers = [
            homeVC,
            habitVC,
            peopleVC,
            logHabbitVC,
        ]
    }
}
