//
//  MainInteractor.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

protocol MainInteractorProtocol {
    func viewDidLoad()
    func viewDidAppear()
    func toggleIsCompleted(for task: Task)
    func search(with text: String)
    func deleteTask(_ task: Task)
    func editingImageViewTapped()
    func editignActionTapped(with task: Task)
}

class MainInteractor {
    weak var presenter: MainPresenterProtocol?
    
    func getCoreDataTasks(completion: @escaping ([Task]) -> Void) {
        CoreDataManager.shared.fetchTasks() { tasks in
            completion(tasks)
        }
    }
    
    private lazy var filteredTasks: [Task] = []
    
    private func filterTasks(with text: String, completion: @escaping ([Task]) -> Void) {
        
        getCoreDataTasks { tasks in
            completion(tasks.filter {
                guard let title = $0.title, let todo = $0.todo else { return false }
                return (title.lowercased().contains(text.lowercased()) ||
                todo.lowercased().contains(text.lowercased()))
            })
        }
    }
}

extension MainInteractor: MainInteractorProtocol {
    
    func viewDidLoad() {
        guard AppStateService.shared.get(for: .isDataSaved) else {
            
            AccessPermissionService.requestMicrophoneAccess()
            AccessPermissionService.requestSpeechRecognition()
            
            NetworkService.fetchTodos { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let todos):
                    for todo in todos {
                        CoreDataManager.shared.saveTodo(todo: todo) {
                            AppStateService.shared.set(true, for: .isDataSaved)
                            self.getCoreDataTasks { tasks in
                                self.filteredTasks = tasks
                                self.presenter?.setTasks(with: self.filteredTasks)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            return
        }
    }
    
    func viewDidAppear() {
        
        getCoreDataTasks { tasks in
            self.filteredTasks = tasks
            self.presenter?.setTasks(with: self.filteredTasks)
            self.presenter?.prepareView()
        }
    }
    
    func toggleIsCompleted(for task: Task) {
        CoreDataManager.shared.updateTask(originalTask: task, newTitle: nil, newTodo: nil, newDate: nil, newCompleted: !task.completed) {
            self.presenter?.setTasks(with: self.filteredTasks)
        }
    }
    
    func search(with text: String) {
        
        if text.isEmpty {
            getCoreDataTasks { tasks in
                self.filteredTasks = tasks
                self.presenter?.setTasks(with: self.filteredTasks)
            }
        } else {
            filterTasks(with: text) { tasks in
                self.filteredTasks = tasks
                self.presenter?.setTasks(with: self.filteredTasks)
            }
        }
    }
    
    func deleteTask(_ task: Task) {
        CoreDataManager.shared.deleteTask(task) {
            self.getCoreDataTasks { tasks in
                self.filteredTasks = tasks
                self.presenter?.setTasks(with: self.filteredTasks)
            }
        }
    }
    
    func editingImageViewTapped() {
        presenter?.presentEditingViewController(with: nil)
    }
    
    func editignActionTapped(with task: Task) {
        presenter?.presentEditingViewController(with: task)
    }
}
