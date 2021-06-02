//
//  HabitCollectionViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

private let HABIT_CELL_ID = "habit-cell-id"
private let PRIMARY_SECONDARY_CELL_ID = "primary-secondary-cell-id"

private let sectionHeaderKind = "SectionHeader"
private let sectionHeaderIdentifier = "HeaderView"

class HabitCollectionViewController: UICollectionViewController {
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>

    enum ViewModel {
        enum Section: Hashable, Comparable {
            case favorites
            case category(_ category: Category)
            static func < (lhs: Section, rhs: Section) -> Bool {
                switch (lhs, rhs) {
                case (.category(let l), .category(let r)):
                    return l.name < r.name
                case (.favorites, _):
                    return true
                case (_, .favorites):
                    return false
                }
            }
        }
        typealias Item = Habit
    }
    
    

    struct Model {
        var habitsByName = [String: Habit]()
        var favoriteHabits: [Habit] {
            return Settings.shared.favoriteHabits
        }
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    
    func update() {
        HabitRequest().send { result in
            switch result {
            case .success(let habits):
                self.model.habitsByName = habits
            case .failure:
                self.model.habitsByName = [:]
            }
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) {
           (collectionView, indexPath, item) in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PRIMARY_SECONDARY_CELL_ID, for: indexPath) as! PrimarySecondaryTextCollectionViewCell
            cell.primaryTextLabel.text = item.name
            return cell
        }
        
        dataSource.supplementaryViewProvider = { (collectionView, kind, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(
                ofKind: sectionHeaderKind,
                withReuseIdentifier: sectionHeaderIdentifier,
                for: indexPath
            ) as! NamedSectionHeaderView
        
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
            
            switch section {
            case .favorites:
                header.nameLabel.text = "Favorites"
            case .category(let category):
                header.nameLabel.text = category.name
            }
        
            return header
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
    
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(36)
        )
        let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: sectionHeaderKind,
            alignment: .top
        )
        sectionHeader.pinToVisibleBounds = true
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 0,
            leading: 10,
            bottom: 0,
            trailing: 10
        )
        section.boundarySupplementaryItems = [sectionHeader]
    
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    func updateCollectionView() {
        var itemsBySection = model.habitsByName.values.reduce(into: [ViewModel.Section: [ViewModel.Item]]()) { partial, habit in
            let item = habit
        
            let section: ViewModel.Section
            if model.favoriteHabits.contains(habit) {
                section = .favorites
            } else {
                section = .category(habit.category)
            }
        
            partial[section, default: []].append(item)
        }
        itemsBySection = itemsBySection.mapValues { $0.sorted() }
        let sectionIDs = itemsBySection.keys.sorted()
        
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
    }
    
    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .yellow
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        self.collectionView!.register(PrimarySecondaryTextCollectionViewCell.self, forCellWithReuseIdentifier: PRIMARY_SECONDARY_CELL_ID)
        
        self.collectionView.register(NamedSectionHeaderView.self, forSupplementaryViewOfKind: sectionHeaderKind, withReuseIdentifier: sectionHeaderIdentifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }

    // MARK: UICollectionViewDataSource
    override func collectionView(_ collectionView: UICollectionView,
       contextMenuConfigurationForItemAt indexPath: IndexPath,
       point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { _ in
            let item = self.dataSource.itemIdentifier(for: indexPath)!
        
            let favoriteToggle = UIAction(
                title: self.model.favoriteHabits.contains(item)
                    ? "Unfavorite"
                    : "Favorite"
            ) { (action) in
                Settings.shared.toggleFavorite(item)
                self.updateCollectionView()
            }
        
            return UIMenu(
                title: "",
                image: nil,
                identifier: nil,
                options: [],
                children: [favoriteToggle]
            )
        }
        
        return config
    }
//
//    override func numberOfSections(in collectionView: UICollectionView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//
//    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of items
//        return 0
//    }
//
//    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
//
//        // Configure the cell
//
//        return cell
//    }


}
