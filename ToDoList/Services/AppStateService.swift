//
//  Caretaker.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import Foundation

enum AppStateKey: String {
    case isDataSaved
}

final class AppStateService {

    static let shared = AppStateService()
    private let defaults = UserDefaults.standard

    private init() {}

    func set(_ value: Bool, for key: AppStateKey) {
        defaults.set(value, forKey: key.rawValue)
    }

    func get(for key: AppStateKey) -> Bool {
        defaults.bool(forKey: key.rawValue)
    }

    func remove(key: AppStateKey) {
        defaults.removeObject(forKey: key.rawValue)
    }
}
