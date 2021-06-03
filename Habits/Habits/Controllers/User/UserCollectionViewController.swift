//
//  UserCollectionViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

private let reuseIdentifier = "USER_Cell"

class UserCollectionViewController: UICollectionViewController {
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        typealias Section = Int
    
        struct Item: Hashable {
            let user: User
            let isFollowed: Bool
    
            func hash(into hasher: inout Hasher) {
                hasher.combine(user)
            }
    
            static func ==(_ lhs: Item, _ rhs: Item) -> Bool {
                return lhs.user == rhs.user
            }
        }
    }
    
    struct Model {
        var usersByID = [String:User]()
        var followedUsers: [User] {
            return Array(usersByID.filter { Settings.shared.followedUserIDs.contains($0.key) }.values)
        }
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    init(){
        super.init(collectionViewLayout: UICollectionViewLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .gray
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        self.collectionView!.register(UserCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        update()

        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 0
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
    
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let item = dataSource.itemIdentifier(for: indexPath) else { return }
        let vc = UserDetailViewController(user: item.user)
        navigationController?.pushViewController(vc, animated: true)
    }

    
    func update() {
        UserRequest().send { result in
            switch result {
            case .success(let users):
                self.model.usersByID = users
            case .failure:
                self.model.usersByID = [:]
            }
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }
    
    func updateCollectionView() {
        let users = model.usersByID.values.sorted().reduce( into: [ViewModel.Item]())
        { partial, user in
            partial.append(
                ViewModel.Item(user: user, isFollowed: model.followedUsers.contains(user))
            )
        }
        let itemsBySection = [0: users]
        dataSource.applySnapshotUsing(sectionIDs: [0], itemsBySection: itemsBySection)
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalHeight(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalWidth(0.45)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 2
        )
        group.interItemSpacing = .fixed(20)
    
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = 20
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 20,
            bottom: 20,
            trailing: 20
        )
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserCollectionViewCell
            cell.primaryTextLabel.text = item.user.name
            return cell
        }
    
        return dataSource
    }
}

