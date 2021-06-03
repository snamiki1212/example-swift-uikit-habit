//
//  HabitDetailViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

class HabitDetailViewController: UIViewController {
    
    var updateTimer: Timer?

    var habit: Habit!
    
    var habitNameLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.largeTitle)
        label.text = "HABIT"
        return label
    }()
    
    var categoryLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.numberOfLines = 1
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        label.text = "CATEGORY"
        return label
    }()
    
    var infoLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        label.text = "INFO"
        return label
    }()
    
    lazy var headInnerStack: UIStackView = {
        let hStack = UIStackView(arrangedSubviews: [habitNameLabel, categoryLabel])
        hStack.axis = .horizontal
        hStack.spacing = 12
        hStack.alignment = .firstBaseline
        hStack.distribution = .equalSpacing
        return hStack
    }()
    
    lazy var headerStack: UIStackView = {
        let vStack = UIStackView(arrangedSubviews: [headInnerStack, infoLabel])
        vStack.axis = .vertical
        vStack.alignment = .fill
        vStack.distribution = .fill
        vStack.spacing = 16
        vStack.translatesAutoresizingMaskIntoConstraints = false
        return vStack
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewLayout()
        let cv = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(HabitDetailCollectionViewCell.self, forCellWithReuseIdentifier: HabitDetailCollectionViewCell.cellId)
        return cv
    }()

    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        enum Section: Hashable {
            case leaders(count: Int)
            case remaining
        }
    
        enum Item: Hashable, Comparable {
            case single(_ stat: UserCount)
            case multiple(_ stats: [UserCount])
    
            static func < (_ lhs: Item, _ rhs: Item) -> Bool {
                switch (lhs, rhs) {
                case (.single(let lCount), .single(let rCount)):
                    return lCount.count < rCount.count
                case (.multiple(let lCounts), .multiple(let rCounts)):
                    return lCounts.first!.count < rCounts.first!.count
                case (.single, .multiple):
                    return false
                case (.multiple, .single):
                    return true
                }
            }
        }
    }
    
    struct Model {
        var habitStatistics: HabitStatistics?
        var userCounts: [UserCount] {
            habitStatistics?.userCounts ?? []
        }
    }
    
    var dataSource: DataSourceType!
    var model = Model()
    
    func update() {
        HabitStatisticsRequest(habitNames: [habit.name]).send { result in
            switch result {
            case .success(let statistics):
                if statistics.count > 0 {
                    self.model.habitStatistics = statistics[0]
                } else {
                    self.model.habitStatistics = nil
                }
            default:
                self.model.habitStatistics = nil
            }
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }
    
    func updateCollectionView() {
        let items = (self.model.habitStatistics?.userCounts.map { ViewModel.Item.single($0) } ?? []).sorted(by: >)
    
        dataSource.applySnapshotUsing(sectionIDs: [.remaining], itemsBySection: [.remaining: items])
    }
    
    func createDataSource() -> DataSourceType {
        return DataSourceType(collectionView: collectionView) { (collectionView, indexPath, grouping) -> UICollectionViewCell? in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HabitDetailCollectionViewCell.cellId, for: indexPath) as! HabitDetailCollectionViewCell
    
            switch grouping {
            case .single(let userStat):
                cell.userNameLabel.text = userStat.user.name
                cell.countLabel.text = "\(userStat.count)"
            default:
                break
            }
    
            return cell
        }
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .fractionalHeight(1)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(
            top: 12,
            leading: 12,
            bottom: 12,
            trailing: 12
        )
    
        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1),
            heightDimension: .absolute(44)
        )
        let group = NSCollectionLayoutGroup.horizontal(
            layoutSize: groupSize,
            subitem: item,
            count: 1
        )
    
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(
            top: 20,
            leading: 0,
            bottom: 20,
            trailing: 0
        )
    
        return UICollectionViewCompositionalLayout(section: section)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
        updateTimer = Timer.scheduledTimer( withTimeInterval: 1, repeats: true) { _ in
            self.update()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    init?(nibName: String?, bundle: Bundle?, habit: Habit){
        super.init(nibName: nibName, bundle: bundle)
        self.habit = habit
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        // basic
        super.viewDidLoad()
        view.backgroundColor = .white
        let safeArea = view.layoutMarginsGuide
        
        // collection data
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
        update()
        
        // habit
        habitNameLabel.text = habit.name
        categoryLabel.text = habit.category.name
        infoLabel.text = habit.info
        
        // for headerStack
        view.addSubview(headerStack)
        NSLayoutConstraint.activate([
            headerStack.topAnchor.constraint(equalTo: safeArea.topAnchor, constant: 20),
            headerStack.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor, constant: 16),
            headerStack.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor, constant: -16),
        ])
        
        // for collectionView
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.bottomAnchor.constraint(equalTo: safeArea.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: safeArea.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: safeArea.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: headerStack.bottomAnchor, constant: 20),
        ])
        
    }
}
