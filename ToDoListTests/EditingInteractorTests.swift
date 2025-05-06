//
//  EditingInteractorTests.swift
//  ToDoList
//
//  Created by Ксюша on 06.05.2025.
//

import XCTest
@testable import ToDoList

class EditingInteractorTests: XCTestCase {
    
    func testGetDate() {
        
        let currentDateString = "06/05/25"
        
        let interactor = EditingInteractor(task: nil)
        let dateString = interactor.getDate()
        
        XCTAssertEqual(currentDateString, dateString)
    }
}
