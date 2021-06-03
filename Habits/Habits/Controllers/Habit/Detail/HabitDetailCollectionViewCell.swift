//
//  HabitDetailCollectionViewCell.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/03.
//

import UIKit

class HabitDetailCollectionViewCell: UICollectionViewCell {
    static let cellId = "habit-detail-collection-cell-id"
    
    var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "User Name"
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var countLabel: UILabel = {
        let label = UILabel()
        label.text = "Count"
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.heightAnchor.constraint(equalToConstant: 44).isActive = true
        contentView.addSubview(userNameLabel)
        contentView.addSubview(countLabel)
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            userNameLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
        ])
        contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
