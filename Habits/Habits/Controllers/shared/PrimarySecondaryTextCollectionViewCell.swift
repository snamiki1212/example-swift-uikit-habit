//
//  PrimarySecondaryTextCollectionViewCell.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/03.
//

import UIKit

class PrimarySecondaryTextCollectionViewCell: UICollectionViewCell {
    var primaryLabel: UILabel = {
        let label = UILabel()
        label.text = "TODO:PRIMARY"
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var secondaryLabel: UILabel = {
        let label = UILabel()
        label.text = "TODO:SECONDARY"
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    init() {
        super.init(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        contentView.addSubview(primaryLabel)
        contentView.addSubview(secondaryLabel)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            contentView.heightAnchor.constraint(equalToConstant: 44),
            primaryLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            primaryLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            secondaryLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 8),
        ])
        contentView.backgroundColor = .blue
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}