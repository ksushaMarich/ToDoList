//
//  EditinInteractor.swift
//  ToDoList
//
//  Created by Ксения Маричева on 04.05.2025.
//

protocol EditingInteractorProtocol: AnyObject {
    func backStackViewTapped(title: String, date: String, todo: String)
    func viewDidLoaded()
    func getDate() -> String
}

class EditingInteractor {
    weak var presenter: EditingPresenterProtocol?
    
    private var task: Task?
    
    init(task: Task?) {
        self.task = task
    }
}

extension EditingInteractor: EditingInteractorProtocol {
    
    func viewDidLoaded() {
        presenter?.setTask(with: task)
    }
    
    func backStackViewTapped(title: String, date: String, todo: String) {
        guard !title.isEmpty || !todo.isEmpty else {
            presenter?.popViewController()
            return
        }
        if let task {
            CoreDataManager.shared.updateTask(originalTask: task, newTitle: title, newTodo: todo, newDate: date, newCompleted: task.completed) {
                self.presenter?.popViewController()
            }
        } else {
            CoreDataManager.shared.saveTask(title: title, date: date, todo: todo, completed: false) {
                self.presenter?.popViewController()
            }
        }
    }
    
    func getDate() -> String {
        DateService.getMoscowDate()
    }
}
