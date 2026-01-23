import Foundation

final class ScoreStore {
    static let shared = ScoreStore()
    private init() {}

    private let defaults = UserDefaults.standard

    // Save / read username
    private let userKey = "poppy_username"

    func saveUsername(_ name: String) {
        defaults.set(name, forKey: userKey)
    }

    func getUsername() -> String {
        defaults.string(forKey: userKey) ?? ""
    }

    // Best score per level for a specific user
    private func key(for user: String, level: String) -> String {
        "bestScore_\(user.lowercased())_\(level)"
    }

    func getBestScore(user: String, level: String) -> Int {
        defaults.integer(forKey: key(for: user, level: level))
    }

    /// Returns (oldBest, newBest)
    @discardableResult
    func saveIfBest(user: String, level: String, score: Int) -> (Int, Int) {
        let old = getBestScore(user: user, level: level)
        if score > old {
            defaults.set(score, forKey: key(for: user, level: level))
            return (old, score)
        }
        return (old, old)
    }
}
//
//  ScoreStore.swift
//  colurgame
//
//  Created by  Dinansa Rithmini  on 2026-01-24.
//

