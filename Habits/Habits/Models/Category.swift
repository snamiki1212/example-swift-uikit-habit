//
//  Category.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import Foundation

struct Category {
    let name: String
    let color: Color
}


extension Category: Codable { }

extension Category: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
    }

    static func == (lhs: Category, rhs: Category) -> Bool {
        return lhs.name == rhs.name
    }
}
