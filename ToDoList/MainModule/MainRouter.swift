//
//  MainRouter.swift
//  ToDoList
//
//  Created by Ксения Маричева on 01.05.2025.
//

import UIKit

protocol MainRouterProtocol: AnyObject {
    func presentEditingViewController(with task: Task?)
}

class MainRouter {
    weak var view: MainViewControllerProtocol?
    
    private var presentationView: UIViewController? {
        view as? UIViewController
    }
}

extension MainRouter: MainRouterProtocol {
    static func build() -> MainViewController {
        let router = MainRouter()
        let interactor = MainInteractor()
        let presenter = MainPresenter(router: router, interactor: interactor)
        let viewController = MainViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.view = viewController
        return viewController
    }
    
    func presentEditingViewController(with task: Task?) {
        presentationView?.navigationController?.pushViewController(EditingRouter.build(task: task), animated: true)
    }
}
