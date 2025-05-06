//
//  EditingRouter.swift
//  ToDoList
//
//  Created by Ксения Маричева on 04.05.2025.
//

import UIKit

protocol EditingRouterProtocol: AnyObject {
    func popViewController()
}

class EditingRouter {
    weak var view: EditingViewControllerProtocol?
    
    init() {}
    
    private var presentationView: UIViewController? {
        view as? UIViewController
    }
}

extension EditingRouter: EditingRouterProtocol {
    
    static func build(task: Task? = nil) -> EditingViewController {
        let router = EditingRouter()
        let interactor = EditingInteractor(task: task)
        let presenter = EditingPresenter(router: router, interactor: interactor)
        let viewController = EditingViewController()
        viewController.presenter = presenter
        presenter.view = viewController
        interactor.presenter = presenter
        router.view = viewController
        return viewController
    }
    
    public func popViewController() {
        presentationView?.navigationController?.popViewController(animated: true)
    }
}
