//
//  UserCount.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/03.
//

import Foundation

struct UserCount {
    let user: User
    let count: Int
}

extension UserCount: Codable { }

extension UserCount: Hashable { }
