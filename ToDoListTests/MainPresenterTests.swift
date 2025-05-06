//
//  MainPresenterTests.swift
//  ToDoList
//
//  Created by Ксюша on 06.05.2025.
//
import XCTest
@testable import ToDoList

class MainPresenterTests: XCTestCase {
    
    var presenter: MainPresenter!
    var mockViewController: MockMainViewController!
    var mockInteractor: MockMainInteractor!
    var mockRouter: MockMainRouter!
    
    override func setUp() {
        super.setUp()
        mockViewController = MockMainViewController()
        mockInteractor = MockMainInteractor()
        mockRouter = MockMainRouter()
        
        presenter = MainPresenter(router: mockRouter, interactor: mockInteractor)
        presenter.view = mockViewController
    }
    
    func testViewDidLoaded_callsInteractor() {
        presenter.viewDidLoaded()
        XCTAssertTrue(mockInteractor.viewDidLoadCalled)
    }
    
    func testViewDidAppear_callsInteractor() {
        presenter.viewDidAppear()
        XCTAssertTrue(mockInteractor.viewDidAppearCalled)
    }
    
    func testTextEntered_callsInteractorSearch() {
        presenter.textEntered("Test")
        XCTAssertTrue(mockInteractor.searchCalled)
    }
    
    func testEditingImageViewTapped_callsInteractor() {
        presenter.editingImageViewTapped()
        XCTAssertTrue(mockInteractor.editingImageViewTappedCalled)
    }
    
    func testPresentEditingViewController_callsRouter() {
        presenter.presentEditingViewController(with: nil)
        XCTAssertTrue(mockRouter.presentEditingViewControllerCalled)
    }
}

class MockMainViewController: MainViewControllerProtocol {
    var tasks: [Task] = []
    
    func prepare() {}
}

class MockMainInteractor: MainInteractorProtocol {
    var viewDidLoadCalled = false
    var viewDidAppearCalled = false
    var toggleIsCompletedCalled = false
    var searchCalled = false
    var deleteTaskCalled = false
    var editingImageViewTappedCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func viewDidAppear() {
        viewDidAppearCalled = true
    }
    
    func toggleIsCompleted(for task: Task) {
        toggleIsCompletedCalled = true
    }
    
    func search(with text: String) {
        searchCalled = true
    }
    
    func deleteTask(_ task: Task) {
        deleteTaskCalled = true
    }
    
    func editingImageViewTapped() {
        editingImageViewTappedCalled = true
    }
    
    func editignActionTapped(with task: Task) {}
}

class MockMainRouter: MainRouterProtocol {
    var presentEditingViewControllerCalled = false
    
    func presentEditingViewController(with task: Task?) {
        presentEditingViewControllerCalled = true
    }
}
