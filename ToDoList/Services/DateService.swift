//
//  DateService.swift
//  ToDoList
//
//  Created by Ксюша on 02.05.2025.
//

import Foundation

class DateService {
    static func getMoscowDate() -> String {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        dateFormatter.timeZone = TimeZone(identifier: "Europe/Moscow")

        return dateFormatter.string(from: Date())
    }
}
