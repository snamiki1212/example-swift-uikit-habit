//
//  HabitCollectionViewCell.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

// TODO: REMOVE?
class HabitCollectionViewCell: UICollectionViewCell {
    // TODO: create class PrimarySecondaryTextCollectionViewCell
    let primaryTextLabel: UILabel = {
        let label = UILabel()
        label.text = "test"
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(primaryTextLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}