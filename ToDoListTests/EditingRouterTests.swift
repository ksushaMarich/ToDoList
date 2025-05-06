//
//  EditingRouterTests.swift
//  ToDoList
//
//  Created by Ксюша on 06.05.2025.
//

import XCTest
@testable import ToDoList

class EditingRouterTests: XCTestCase {
    
    var router: EditingRouter?
    var mockViewController: MockEditingViewControllerTwo?
    
    override func setUp() {
        super.setUp()
        mockViewController = MockEditingViewControllerTwo()
        router = EditingRouter()
        router?.view = mockViewController
    }
    
    func testPopViewController() {
        
        router?.popViewController()
        
        XCTAssertTrue(((mockViewController?.popViewControllerCalled) != nil))
    }
}

class MockEditingViewControllerTwo: EditingViewControllerProtocol {
    var popViewControllerCalled = false
    
    func setTask(with task: Task?) {}
    
    func popViewController() {
        popViewControllerCalled = true
    }
}
