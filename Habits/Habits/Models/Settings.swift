//
//  Settings.swift
//  Habits
//
//  Created by shunnamiki on 2021/06/01.
//

import Foundation

struct Settings {
    static var shared = Settings()
    private let defaults = UserDefaults.standard
    
    let currentUser = User(
        id: "user0",
        name: "Aga Orlova",
        color: Color(
            hue: 0.75707988194531695,
            saturation: 0.81293901213002762,
            brightness: 0.92267943863794188
        ),
        bio: "My guiding principles: I'm thoughtful and I believe. Can't learn enough about cinema! Gamer; Engineer. My family is what gets me out of bed every day."
    )
    
    private func archiveJSON<T: Encodable>(value: T, key: String) {
        let data = try! JSONEncoder().encode(value)
        let string = String(data: data, encoding: .utf8)
        defaults.set(string, forKey: key)
    }
    
    private func unarchiveJSON<T: Decodable>(key: String) -> T? {
        guard let string = defaults.string(forKey: key),
            let data = string.data(using: .utf8) else {
                return nil
        }
        return try! JSONDecoder().decode(T.self, from: data)
    }

    enum Setting {
        static let favoriteHabits = "favoriteHabits"
        static let followedUserIDs = "followedUserIDs"
    }
    
    var favoriteHabits: [Habit] {
        get {
            return unarchiveJSON(key: Setting.favoriteHabits) ?? []
        }
        set {
            archiveJSON(value: newValue, key: Setting.favoriteHabits)
        }
    }
    var followedUserIDs: [String] {
        get {
            return unarchiveJSON(key: Setting.followedUserIDs) ?? []
        }
        set {
            archiveJSON(value: newValue, key: Setting.followedUserIDs)
        }
    }

    mutating func toggleFavorite(_ habit: Habit) {
        var favorites = favoriteHabits
        if favorites.contains(habit) {
            favorites = favorites.filter { $0 != habit }
        } else {
            favorites.append(habit)
        }
        favoriteHabits = favorites
    }
    
    
}

