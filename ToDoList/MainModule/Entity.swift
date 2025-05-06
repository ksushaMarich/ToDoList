//
//  Entity,.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import Foundation

struct TodoResponse: Decodable {
    let todos: [Todo]
}

struct Todo: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    
    var title: String { "Task \(id)" }
    var date: String { DateService.getMoscowDate() }
}
