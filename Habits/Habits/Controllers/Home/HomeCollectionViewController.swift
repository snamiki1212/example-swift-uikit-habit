//
//  HomeCollectionViewController.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import UIKit

private let reuseIdentifier = "HOME_Cell"

class HomeCollectionViewController: UICollectionViewController {

    init(){
        super.init(collectionViewLayout: UICollectionViewFlowLayout()) // TODO: use compositional-layout
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .blue
        self.collectionView!.register(LeaderboardHabitCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        dataSource = createDataSource()
        collectionView.dataSource = dataSource
        collectionView.collectionViewLayout = createLayout()
    }


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
    
        return cell
    }
    
    typealias DataSourceType = UICollectionViewDiffableDataSource<ViewModel.Section, ViewModel.Item>
    
    enum ViewModel {
        enum Section: Hashable {
            case leaderboard
            case followedUsers
        }
    
        enum Item: Hashable {
            case leaderboardHabit(name: String, leadingUserRanking: String?,
               secondaryUserRanking: String?)
            case followedUser(_ user: User, message: String)
            func hash(into hasher: inout Hasher) {
                switch self {
                case .leaderboardHabit(let name, _, _):
                    hasher.combine(name)
                case .followedUser(let User, _):
                    hasher.combine(User)
                }
            }

            static func ==(_ lhs: Item, _ rhs: Item) -> Bool {
                switch (lhs, rhs) {
                case (.leaderboardHabit(let lName, _, _), .leaderboardHabit(let
                   rName, _, _)):
                    return lName == rName
                case (.followedUser(let lUser, _), .followedUser(let rUser,
                   _)):
                    return lUser == rUser
                default:
                    return false
                }
            }
        }
    }
    
    struct Model {
        var usersByID = [String: User]()
        var habitsByName = [String: Habit]()
        var habitStatistics = [HabitStatistics]()
        var userStatistics = [UserStatistics]()
    
        var currentUser: User {
            return Settings.shared.currentUser
        }
    
        var users: [User] {
            return Array(usersByID.values)
        }
    
        var habits: [Habit] {
            return Array(habitsByName.values)
        }
    
        var followedUsers: [User] {
            return Array(usersByID.filter { Settings.shared.followedUserIDs.contains($0.key) }.values)
        }
    
        var favoriteHabits: [Habit] {
            return Settings.shared.favoriteHabits
        }
    
        var nonFavoriteHabits: [Habit] {
            return habits.filter { !favoriteHabits.contains($0) }
        }
    }
    
    var model = Model()
    var dataSource: DataSourceType!
    
    var updateTimer: Timer?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
        updateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            self.update()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        updateTimer?.invalidate()
        updateTimer = nil
    }
    
    func update() {
        CombinedStatisticsRequest().send { result in
            switch result {
            case .success(let combinedStatistics):
                self.model.userStatistics = combinedStatistics.userStatistics
                self.model.habitStatistics = combinedStatistics.habitStatistics
            case .failure:
                self.model.userStatistics = []
                self.model.habitStatistics = []
            }
            DispatchQueue.main.async {
                self.updateCollectionView()
            }
        }
    }
    
    static let formatter: NumberFormatter = {
        var f = NumberFormatter()
        f.numberStyle = .ordinal
        return f
    }()
    
    func ordinalString(from number: Int) -> String {
        return Self.formatter.string(from: NSNumber(integerLiteral: number + 1))!
    }

    
    
    func updateCollectionView() {
        var sectionIDs = [ViewModel.Section]()
        let leaderboardItems = model.habitStatistics.filter { statistic in
            return model.favoriteHabits.contains { $0.name ==
               statistic.habit.name }
        }
        .sorted { $0.habit.name < $1.habit.name }
        .reduce(into: [ViewModel.Item]()) { partial, statistic in
            // Rank the user counts from highest to lowest.
            let rankedUserCounts = statistic.userCounts.sorted { $0.count > $1.count }

            // Find the index of the current user's count, keeping in mind that it won't exist if the user hasn't logged that habit yet.
            let myCountIndex = rankedUserCounts.firstIndex { $0.user.id == self.model.currentUser.id }

            var leadingRanking: String?
            var secondaryRanking: String?
            
            
            func userRankingString(from userCount: UserCount) -> String {
                var name = userCount.user.name
                var ranking = ""
                if userCount.user.id == self.model.currentUser.id {
                    name = "You"
                    ranking = " (\(ordinalString(from: myCountIndex!)))"
                }
                return "\(name) \(userCount.count)" + ranking
            }
            
            // Examine the number of user counts for the statistic:
            switch rankedUserCounts.count {
            case 0:
                // If 0, set the leader label to "Nobody Yet!" and leave the secondary label `nil`.
                leadingRanking = "Nobody yet!"
            case 1:
                // If 1, set the leader label to the only user and count.
                let onlyCount = rankedUserCounts.first!
                leadingRanking = userRankingString(from: onlyCount)
            default:
                // Otherwise, do the following:
                // Set the leader label to the user count at index 0.
                leadingRanking = userRankingString(from: rankedUserCounts[0])
                // Check whether the index of the current user's count exists and is not 0.
                if let myCountIndex = myCountIndex, myCountIndex != rankedUserCounts.startIndex {
                    // If true, the user's count and ranking should be displayed in the secondary label.
                    secondaryRanking = userRankingString(from: rankedUserCounts[myCountIndex])
                } else {
                    // If false, the second-place user count should be displayed.
                    secondaryRanking = userRankingString(from: rankedUserCounts[1])
                }
            }
            
            let leaderboardItem = ViewModel.Item.leaderboardHabit(
                name: statistic.habit.name,
                leadingUserRanking: leadingRanking,
                secondaryUserRanking: secondaryRanking
            )
            
            partial.append(leaderboardItem)
        }
        sectionIDs.append(.leaderboard)
        let itemsBySection = [ViewModel.Section.leaderboard: leaderboardItems]
        
        dataSource.applySnapshotUsing(sectionIDs: sectionIDs, itemsBySection: itemsBySection)
    }

    func createDataSource() -> DataSourceType {
        let dataSource = DataSourceType(collectionView: collectionView) { (collectionView, indexPath, item) -> UICollectionViewCell? in
            switch item {
            case .leaderboardHabit(let name, let leadingUserRanking, let secondaryUserRanking):
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "LeaderboardHabit", for: indexPath) as! LeaderboardHabitCollectionViewCell
                cell.habitNameLabel.text = name
                cell.leaderLabel.text = leadingUserRanking
                cell.secondaryLabel.text = secondaryUserRanking
                return cell
            default:
                return nil
            }
        }
        return dataSource
    }
    
    func createLayout() -> UICollectionViewCompositionalLayout {
        let layout = UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            switch self.dataSource.snapshot().sectionIdentifiers[sectionIndex] {
            case .leaderboard:
                let leaderboardItemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(0.3)
                )
                let leaderboardItem = NSCollectionLayoutItem(layoutSize: leaderboardItemSize)
    
                let verticalTrioSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.75),
                    heightDimension: .fractionalWidth(0.75)
                )
                let leaderboardVerticalTrio = NSCollectionLayoutGroup.vertical(
                    layoutSize: verticalTrioSize,
                    subitem: leaderboardItem,
                    count: 3
                )
                leaderboardVerticalTrio.interItemSpacing = .fixed(10)
    
                let leaderboardSection = NSCollectionLayoutSection(group: leaderboardVerticalTrio)
                leaderboardSection.interGroupSpacing = 20
                leaderboardSection.contentInsets = NSDirectionalEdgeInsets(
                    top: 20,
                    leading: 0,
                    bottom: 0,
                    trailing: 0
                )
    
                leaderboardSection.orthogonalScrollingBehavior = .continuous
                leaderboardSection.contentInsets = NSDirectionalEdgeInsets(
                    top: 12,
                    leading: 20,
                    bottom: 20,
                    trailing: 20
                )
                return leaderboardSection
            default:
                return nil
            }
        }
        return layout
    }
}
