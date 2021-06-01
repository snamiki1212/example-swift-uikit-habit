//
//  MainTabBarController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class MainTabBarController: UITabBarController {

    let homeVC: UINavigationController = {
        let vc: UIViewController = {
            let vc = UIViewController()
            let image = UIImage(systemName: "house.fill")
            vc.tabBarItem = UITabBarItem(title: "Home", image: image, tag: 0)
            vc.view.backgroundColor = .blue // TODO:
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let habitVC: UINavigationController = {
        let vc: UIViewController = {
            let vc = UIViewController()
            let image = UIImage(systemName: "star.fill")
            vc.tabBarItem = UITabBarItem(title: "Habits", image: image, tag: 1)
            vc.view.backgroundColor = .yellow // TODO:
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let peopleVC: UINavigationController = {
        let vc: UIViewController = {
            let vc = UIViewController()
            let image = UIImage(systemName: "person.2.fill")
            vc.tabBarItem = UITabBarItem(title: "People", image: image, tag: 2)
            vc.view.backgroundColor = .red // TODO:
            return vc
        }()
        let nav = UINavigationController(rootViewController: vc)
        return nav
    }()
    
    let logHabbitVC: UINavigationController = {
        let vc: UIViewController = {
            let vc = UIViewController()
            let image = UIImage(systemName: "checkmark.square.fill")
            vc.tabBarItem = UITabBarItem(title: "Log Habits", image: image, tag: 1)
            vc.view.backgroundColor = .blue // TODO:
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
            peopleVC,
            logHabbitVC,
        ]
    }
}
