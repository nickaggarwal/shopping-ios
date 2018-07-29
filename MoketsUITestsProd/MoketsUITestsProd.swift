//
//  MoketsUITestsProd.swift
//  MoketsUITestsProd
//
//  Created by Agarwal, Nilesh on 7/8/18.
//  Copyright © 2018 Panacea-soft. All rights reserved.
//

import XCTest

class MoketsUITestsProd: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
        

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testLogin() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let app = XCUIApplication()
        sleep(10)
        let button = app.navigationBars["Mokets"].children(matching: .button).element
        button.tap()
        app.tables/*@START_MENU_TOKEN@*/.staticTexts["Profile"]/*[[".cells.staticTexts[\"Profile\"]",".staticTexts[\"Profile\"]"],[[[-1,1],[-1,0]]],[0]]@END_MENU_TOKEN@*/.tap()
        let emailTextField = app.textFields["Email"]
        emailTextField.tap()
        emailTextField.typeText("nick.aggarwal@gmail.com")
        let passwordSecureTextField = app.secureTextFields["Password"]
        passwordSecureTextField.tap()
        passwordSecureTextField.typeText("2jan1992")
        app.buttons["Submit"].tap()
        
    }
    
}
