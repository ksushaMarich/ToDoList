//
//  MainPresenter.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

protocol MainPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func viewDidAppear()
    func prepareView()
    func setTasks(with tasks: [Task])
    func checkboxIsTapped(with task: Task)
    func textEntered(_ text: String)
    func deleteTask(_ task: Task)
    func editingImageViewTapped()
    func presentEditingViewController(with task: Task?)
    func editignActionTapped(with task: Task)
}

class MainPresenter {
    weak var view: MainViewControllerProtocol?
    
    var router: MainRouterProtocol
    var interactor: MainInteractorProtocol
    
    private var mainViewController: MainViewController? {
        view as? MainViewController
    }
    
    init(router: MainRouterProtocol, interactor: MainInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension MainPresenter: MainPresenterProtocol {
    
    func viewDidLoaded() {
        interactor.viewDidLoad()
    }
    
    func viewDidAppear() {
        interactor.viewDidAppear()
    }
    
    func prepareView() {
        view?.prepare()
    }
    
    func checkboxIsTapped(with task: Task) {
        interactor.toggleIsCompleted(for: task)
    }
    
    func setTasks(with tasks: [Task]) {
        mainViewController?.tasks = tasks
    }
    
    func textEntered(_ text: String) {
        interactor.search(with: text)
    }
    
    func deleteTask(_ task: Task) {
        interactor.deleteTask(task)
    }
    
    func editingImageViewTapped() {
        interactor.editingImageViewTapped()
    }
    
    func presentEditingViewController(with task: Task? = nil) {
        router.presentEditingViewController(with: task)
    }
    
    func editignActionTapped(with task: Task) {
        interactor.editignActionTapped(with: task)
    }
}
