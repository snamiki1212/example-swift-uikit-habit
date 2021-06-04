//
//  UserCollectionViewCell.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/02.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
    let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // border
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.black.cgColor
        contentView.layer.cornerRadius = 10
        
        // label
        contentView.addSubview(primaryTextLabel)
        primaryTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            primaryTextLabel.topAnchor.constraint(equalTo: topAnchor),
            primaryTextLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            primaryTextLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            primaryTextLabel.bottomAnchor.constraint(equalTo: bottomAnchor),
            primaryTextLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            primaryTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
