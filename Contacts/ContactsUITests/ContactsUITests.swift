//
//  ContactsUITests.swift
//  ContactsUITests
//
//  Created by Mushtaque Ahmed on 30/01/2020.
//  Copyright © 2020 Mushtaque Ahmed. All rights reserved.
//

import XCTest

class ContactsUITests: XCTestCase {
    var app: XCUIApplication!

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testAddContact() {
        // UI tests must launch the application that they test.
        
        let app = XCUIApplication()
        let contactNavigationBar = app.navigationBars["Contact"]
        contactNavigationBar.buttons["Add"].tap()
        
        let tablesQuery = app.tables
        tablesQuery.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element.tap()
        
        let textField = tablesQuery.cells.containing(.staticText, identifier:"Last Name").children(matching: .textField).element
        textField.tap()
        textField.tap()
        
        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"mobile").children(matching: .textField).element
        textField2.tap()
        textField2.tap()
        
        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"email").children(matching: .textField).element
        textField3.tap()
        textField3.tap()
        contactNavigationBar.buttons["Save"].tap()
       

        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testEditContact() {
        
        let app = XCUIApplication()
        let tablesQuery = app.tables
        tablesQuery/*@START_MENU_TOKEN@*/.staticTexts["AAA1 AAA1"]/*[[".cells.staticTexts[\"AAA1 AAA1\"]",".staticTexts[\"AAA1 AAA1\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        
        let contactNavigationBar = app.navigationBars["Contact"]
        contactNavigationBar.buttons["Edit"].tap()
        tablesQuery.cells.containing(.staticText, identifier:"Last Name").children(matching: .textField).element.tap()
        
        let textField = tablesQuery.cells.containing(.staticText, identifier:"First Name").children(matching: .textField).element
        textField.tap()
        textField.tap()
        
        let textField2 = tablesQuery.cells.containing(.staticText, identifier:"mobile").children(matching: .textField).element
        textField2.tap()
        textField2.tap()
        
        let textField3 = tablesQuery.cells.containing(.staticText, identifier:"email").children(matching: .textField).element
        textField3.tap()
        textField3.tap()
        textField3.tap()
        contactNavigationBar.buttons["Save"].tap()
                
    }
    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
