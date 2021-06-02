//
//  PrimarySecondaryTextCollectionViewCell.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class PrimarySecondaryTextCollectionViewCell: UICollectionViewCell {
    let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(primaryTextLabel)
        primaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryTextLabel.topAnchor.constraint(equalTo: topAnchor),
            primaryTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            primaryTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            primaryTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
