//
//  LoggedHabit.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/03.
//

import Foundation

struct LoggedHabit {
    let userID: String
    let habitName: String
    let timestamp: Date
}

extension LoggedHabit: Codable { }

