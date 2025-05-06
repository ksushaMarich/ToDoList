//
//  EditingPresenterTests.swift
//  ToDoList
//
//  Created by Ксюша on 06.05.2025.
//

import XCTest
@testable import ToDoList

class EditingPresenterTests: XCTestCase {
    
    var presenter: EditingPresenter!
    var mockInteractor: MockEditingInteractor!
    var mockRouter: MockEditingRouter!
    var mockView: MockEditingViewController!
    
    override func setUp() {
        super.setUp()
        mockInteractor = MockEditingInteractor()
        mockRouter = MockEditingRouter()
        mockView = MockEditingViewController()
        presenter = EditingPresenter(router: mockRouter, interactor: mockInteractor)
        presenter.view = mockView
    }
    
    func testViewDidLoaded() {
        presenter.viewDidLoaded()
        XCTAssertTrue(mockInteractor.viewDidLoadedCalled)
    }
    
    func testBackStackViewTapped() {
        presenter.backStackViewTapped(title: "New Title", date: "2025-05-07", todo: "New Todo")
        XCTAssertTrue(mockInteractor.backStackViewTappedCalled)
    }
    
    func testPopViewController() {
        presenter.popViewController()
        XCTAssertTrue(mockRouter.popViewControllerCalled)
    }
    
    func testGetDate() {
        let date = presenter.getDate()
        XCTAssertEqual(date, "2025-05-06")
    }
}

class MockEditingInteractor: EditingInteractorProtocol {
    var viewDidLoadedCalled = false
    var backStackViewTappedCalled = false
    
    func viewDidLoaded() {
        viewDidLoadedCalled = true
    }
    
    func backStackViewTapped(title: String, date: String, todo: String) {
        backStackViewTappedCalled = true
    }
    
    func getDate() -> String {
        return "2025-05-06"
    }
}

class MockEditingRouter: EditingRouterProtocol {
    var popViewControllerCalled = false
    
    func popViewController() {
        popViewControllerCalled = true
    }
}

class MockEditingViewController: EditingViewControllerProtocol {
    var setTaskCalled = false
    
    func setTask(with task: Task?) {
        setTaskCalled = true
    }
}
