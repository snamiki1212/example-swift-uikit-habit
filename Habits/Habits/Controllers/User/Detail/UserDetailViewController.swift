//
//  UserDetailViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class UserDetailViewController: UIViewController {
    // IDs
    private let headerIdentifier = "HeaderView"
    private let headerKind = "SectionHeader"
    let cellId = "user-detail-collection-cell-id"
    
    var updateTimer: Timer?

    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        enum Section: Hashable, Comparable {
            case leading
            case category(_ category: Category)
            static func < (lhs: Section, rhs: Section) -> Bool {
                switch (lhs, rhs) {
                case (.leading, .category), (.leading, .leading):
                    return true
                case (.category, .leading):
                    return false
                case (category(let category1), category(let category2)):
                    return category1.name > category2.name
                }
            }
        }
        typealias Item = HabitCount
    }
    
    struct Model {
        var userStats: UserStatistics?
        var leadingStats: UserStatistics?
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    
    func update() {
        UserStatisticsRequest(userIDs: [user.id]).send { result in
            switch result {
            case .success(let userStats):
                self.model.userStats = userStats[0]
            case .failure:
                self.model.userStats = nil
            }
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
        HabitLeadStatisticsRequest(userID: user.id).send { result in
            switch result {
            case .success(let userStats):
                self.model.leadingStats = userStats
            case .failure:
                self.model.leadingStats = nil
            }
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }
    
    func updateCollectionView() {
        guard let userStatistics = model.userStats,
              let leadingStatistics = model.leadingStats
        else { return }
        
        var itemsBySection = userStatistics.habitCounts.reduce(
            into: [ViewModel.Section: [ViewModel.Item]]()) { partial, habitCount in
            let section: ViewModel.Section
            if leadingStatistics.habitCounts.contains(habitCount) {
                section = .leading
            } else {
                section = .category(habitCount.habit.category)
            }
            partial[section, default: []].append(habitCount)
        }
    
        itemsBySection = itemsBySection.mapValues { $0.sorted() }
    
        let sectionIDs = itemsBySection.keys.sorted()
    
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
    }
    
    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) {
           (collectionView, indexPath, habitStat) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellId, for: indexPath) as! PrimarySecondaryTextCollectionViewCell
    
            cell.primaryLabel.text = habitStat.habit.name
            cell.secondaryLabel.text = "\(habitStat.count)"
    
            return cell
        }
    
        dataSource.supplementaryViewProvider = { (collectionView,
           category, indexPath) in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: self.headerKind, withReuseIdentifier: self.headerIdentifier, for: indexPath) as! NamedSectionHeaderView
    
            let section = dataSource.snapshot().sectionIdentifiers[indexPath.section]
    
            switch section {
            case .leading:
                header.nameLabel.text = "Leading"
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
        item.contentInsets = NSDirectionalEdgeInsets(top: 12, leading: 12, bottom: 12, trailing: 12)

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
            elementKind: "header",
            alignment: .top
        )
           
        sectionHeader.pinToVisibleBounds = true

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0)
        section.boundarySupplementaryItems = [sectionHeader]
    
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1,
           repeats: true) { _ in
            self.update()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    var user: User!
    
    init(user: User) {
        super.init(nibName: nil, bundle: nil)
        self.user = user
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
        
        // for date source
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        update()
        
        // for labels
        userNameLabel.text = user.name
        bioLabel.text = user.bio
        
        // for vStack
        view.addSubview(vStack)
        NSLayoutConstraint.activate([
            vStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            vStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            vStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])

        // for collection view
        collectionView.register(
            NamedSectionHeaderView.self,
            forSupplementaryViewOfKind: headerKind,
            withReuseIdentifier: headerIdentifier
        )
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: vStack.bottomAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
        ])
        collectionView.backgroundColor = .white
        //
        ImageRequest(imageID: user.id).send { result in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.profileImageView.image = image
                }
            default: break
            }
        }
    }
}
