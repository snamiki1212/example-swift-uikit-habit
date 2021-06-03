//
//  HabitDetailViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class HabitDetailViewController: UIViewController {
    
    var habitNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
        label.text = "HABIT"
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        label.text = "CATEGORY"
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.text = "INFO"
        return label
    }()
    
    lazy var headInnerStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [habitNameLabel, categoryLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .firstBaseline
        hStack.distribution = .equalSpacing
        return hStack
    }()
    
    lazy var headerStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [headInnerStack, infoLabel])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "HABIT_DETAIL" // TODO:
        view.backgroundColor = .white
        
        // style
        view.addSubview(headerStack)
        let safeArea = view.layoutMarginsGuide
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])
        
        
    }
}
