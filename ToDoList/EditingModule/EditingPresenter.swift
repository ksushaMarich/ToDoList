//
//  EditingPresenter.swift
//  ToDoList
//
//  Created by Ксения Маричева on 04.05.2025.
//
protocol EditingPresenterProtocol: AnyObject {
    func viewDidLoaded()
    func setTask(with task: Task?)
    func backStackViewTapped(title: String, date: String, todo: String)
    func popViewController()
    func getDate() -> String
}

class EditingPresenter {
    weak var view: EditingViewControllerProtocol?
    
    var router: EditingRouterProtocol
    var interactor: EditingInteractorProtocol
    
    init(router: EditingRouterProtocol, interactor: EditingInteractorProtocol) {
        self.router = router
        self.interactor = interactor
    }
}

extension EditingPresenter: EditingPresenterProtocol {
    func setTask(with task: Task?) {
        view?.setTask(with: task)
    }
    
    func viewDidLoaded() {
        interactor.viewDidLoaded()
    }
    
    func backStackViewTapped(title: String, date: String, todo: String) {
        interactor.backStackViewTapped(title: title, date: date, todo: todo)
    }
    
    func popViewController() {
        router.popViewController()
    }
    
    func getDate() -> String {
        interactor.getDate()
    }
}
