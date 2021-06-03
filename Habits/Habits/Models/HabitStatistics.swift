//
//  HabitStatistics.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/03.
//

import Foundation

struct HabitStatistics {
    let habit: Habit
    let userCounts: [UserCount]
}

extension HabitStatistics: Codable { }
