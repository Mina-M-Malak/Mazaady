//
//  SearchViewModelTest.swift
//  MazaadyTests
//
//  Created by Mina Malak on 03/02/2023.
//

import XCTest
@testable import Mazaady

final class SearchViewModelTest: XCTestCase {
    
    var viewModel = SearchViewModel()
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }
    
    func testGetCategoriesSuccess() {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "categoriesMockData", withExtension: "json")
        do {
            let data = try Data(contentsOf: fileUrl!)
            let responseModel = try JSONDecoder().decode(Category.self, from: data)
            XCTAssert(true)
            XCTAssert(!responseModel.subcategories.isEmpty)
        }
        catch{
            XCTFail()
        }
    }
    
    func testPropertiesOptionsSuccess() {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "propertiesMockData", withExtension: "json")
        do {
            let data = try Data(contentsOf: fileUrl!)
            let responseModel = try JSONDecoder().decode(Property.self, from: data)
            XCTAssert(true)
            XCTAssert(!responseModel.options.isEmpty)
        }
        catch{
            XCTFail()
        }
    }
    
    func testPropertiesOptionsFailure() {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "propertiesMockData3", withExtension: "json")
        do {
            let data = try Data(contentsOf: fileUrl!)
            let responseModel = try JSONDecoder().decode(Property.self, from: data)
            XCTAssert(true)
            XCTAssert(!responseModel.options.isEmpty)
        }
        catch{
            XCTFail()
        }
    }
    
    func testPropertiesChildSuccess() {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "propertiesMockData", withExtension: "json")
        do {
            let data = try Data(contentsOf: fileUrl!)
            let responseModel = try JSONDecoder().decode(Property.self, from: data)
            XCTAssert(true)
            XCTAssert(!responseModel.options.filter({$0.child}).isEmpty)
        }
        catch{
            XCTFail()
        }
    }
    
    func testPropertiesChildFailure() {
        let bundle = Bundle(for: type(of: self))
        let fileUrl = bundle.url(forResource: "propertiesMockData", withExtension: "json")
        do {
            let data = try Data(contentsOf: fileUrl!)
            let responseModel = try JSONDecoder().decode(Property.self, from: data)
            XCTAssert(true)
            XCTAssert(responseModel.options.filter({$0.child}).isEmpty)
        }
        catch{
            XCTFail()
        }
    }
}
