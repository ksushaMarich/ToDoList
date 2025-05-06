//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Ксюша on 06.05.2025.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }
    
    @NSManaged public var completed: Bool
    @NSManaged public var date: String?
    @NSManaged public var title: String?
    @NSManaged public var todo: String?

}

extension Task : Identifiable {

}
