//
//  UserDetailViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class UserDetailViewController: UIViewController {
    let cellId = "user-detail-collection-cell-id"

    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        title = user.name
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let profileImageView: UIImageView = {
        let img = UIImage(systemName: "person.fill")
        let iv = UIImageView(image: img)
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.heightAnchor.constraint(equalTo: iv.widthAnchor, multiplier: 1.0).isActive = true
        return iv
    }()
    
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "TODO:USER_NAME"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "TODO:BIO"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    lazy var hStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [profileImageView, userNameLabel])
        profileImageView.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 0.3).isActive = true
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .horizontal
        stack.alignment = .center
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    lazy var vStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [hStack, bioLabel])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .fill
        stack.spacing = 20
        return stack
    }()
    
    lazy var collectionView: UICollectionView = {
        let frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        let layout = UICollectionViewLayout()
        let cv = UICollectionView(frame: frame, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(PrimarySecondaryTextCollectionViewCell.self, forCellWithReuseIdentifier: cellId)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        let safeArea = view.layoutMarginsGuide
        
        // for vStack
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])

        // for collection view
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        collectionView.backgroundColor = .red
    }
}
