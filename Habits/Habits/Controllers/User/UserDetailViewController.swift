//
//  UserDetailViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class UserDetailViewController: UIViewController {

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        title = user.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}
