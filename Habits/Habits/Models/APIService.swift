//
//  APIService.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import Foundation

struct HabitRequest: APIRequest {
    typealias Response = [String: Habit]
    var habitName: String?
    var path: String { "/habits" }
}
