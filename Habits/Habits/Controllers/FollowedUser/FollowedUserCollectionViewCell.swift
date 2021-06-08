//
//  FollowedUserCollectionViewCell.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/07.
//

import UIKit

class FollowedUserCollectionViewCell:
    PrimarySecondaryTextCollectionViewCell {
    @IBOutlet var separatorLineView: UIView!
    @IBOutlet var separatorLineHeightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        separatorLineHeightConstraint.constant = 1 / UITraitCollection.current.displayScale
    }
}
