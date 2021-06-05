//
//  CombinedStatistics.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/04.
//

import Foundation

struct CombinedStatistics {
    let userStatistics: [UserStatistics]
    let habitStatistics: [HabitStatistics]
}

extension CombinedStatistics: Codable { }
