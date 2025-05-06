//
//  CoreDataService.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import UIKit
import CoreData

public final class CoreDataManager: NSObject {
    
    public static let shared = CoreDataManager()
    
    private let appDelegate: AppDelegate = UIApplication.shared.delegate as! AppDelegate
    private let saveQueue = DispatchQueue(label: "com.yourapp.saveQueue", qos: .userInitiated)
    
    
    private var context: NSManagedObjectContext {
        appDelegate.persistentContainer.viewContext
    }
    
    func saveTodo(todo: Todo, completion: @escaping () -> Void) {
        
        saveQueue.async {
            self.context.perform {
                let task = Task(context: self.context)
                task.title = todo.title
                task.todo = todo.todo
                task.date = todo.date
                task.completed = todo.completed
                
                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Ошибка при сохранении: \(error)")
                }
            }
        }
    }
    
    func saveTask(title: String, date: String, todo: String, completed: Bool = false, completion: @escaping () -> Void) {
        
        saveQueue.async {
            self.context.perform {
                let task = Task(context: self.context)
                task.title = title
                task.todo = todo
                task.date = date
                task.completed = false
                
                do {
                    try self.context.save()
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Ошибка при сохранении: \(error)")
                }
            }
        }
    }
    
    func fetchTasks(completion: @escaping ([Task]) -> Void) {
        
        saveQueue.async {
            self.context.perform {
                let tasks: [Task]
                
                do {
                    tasks = try self.context.fetch(Task.fetchRequest())
                    DispatchQueue.main.async {
                        completion(tasks)
                    }
                } catch {
                    print("Ошибка при загрузке задач: \(error)")
                    tasks = []
                }
            }
        }
    }
    
    func deleteTasks(completion: @escaping () -> Void) {
        fetchTasks { tasks in
            
            self.saveQueue.async {
                self.context.perform {
                    tasks.forEach { self.context.delete($0) }
                    
                    do {
                        try self.context.save()
                        DispatchQueue.main.async {
                            completion()
                        }
                    } catch {
                        print("Ошибка при сохранении контекста: \(error)")
                    }
                }
            }
        }
    }
        
    func deleteTask(_ task: Task, completion: @escaping () -> Void) {
        
        self.saveQueue.async {
            self.context.perform { [self] in
                let objectID = task.objectID
                
                do {
                    if let existingTask = try context.existingObject(with: objectID) as? Task {
                        context.delete(existingTask)
                        try context.save()
                    }
                    DispatchQueue.main.async {
                        completion()
                    }
                } catch {
                    print("Не удалось удалить задачу: \(error.localizedDescription)")
                }
            }
        }
    }
            
    func updateTask(originalTask: Task, newTitle: String?, newTodo: String?, newDate: String?, newCompleted: Bool?,  completion: @escaping () -> Void) {
        
        self.saveQueue.async {
            self.context.perform {
                
                let objectID = originalTask.objectID
                
                do {
                    if let task = try self.context.existingObject(with: objectID) as? Task {
                        if let newTitle = newTitle {
                            task.title = newTitle
                        }
                        if let newTodo = newTodo {
                            task.todo = newTodo
                        }
                        if let newDate = newDate {
                            task.date = newDate
                        }
                        if let newCompleted = newCompleted {
                            task.completed = newCompleted
                        }
                        
                        try self.context.save()
                        
                        DispatchQueue.main.async {
                            completion()
                        }
                    }
                } catch {
                    print("Не удалось найти задачу по objectID: \(error.localizedDescription)")
                }
            }
        }
    }
}

