//
//  UserStatistics.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/03.
//

import Foundation

struct UserStatistics {
    let user: User
    let habitCounts: [HabitCount]
}

extension UserStatistics: Codable { }
