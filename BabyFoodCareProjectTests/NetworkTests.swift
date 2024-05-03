//
//  NetworkTests.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 21.03.2024.
//

import XCTest
import TinkoffMockStrapping
import SwiftyJSON
@testable import BabyFoodCareProject

class APIRequestDispatcherTests: XCTestCase {
    
    lazy var mockServer = MockNetworkServer()
    let sut: IAPIRequestDispatcher = APIRequestDispatcher()
    
    private var json: JSON {
        let productsModel = ["id": "8", "title": "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg", "foodType": "Vegetables", "description": "This is the description for my appetizer. It's yummy.", "imageURL": "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg", "foodTypeImageURL": "https://seanallen-course-backend.herokuapp.com/images/appetizers/asian-flank-steak.jpg", "monthFrom": "6", "allergen": "true", "withWarning": "true", "calories": "190", "protein": "10", "fats": "20", "carbs": "30"]
        let jsonArray = [productsModel]
        print(JSONSerialization.isValidJSONObject(jsonArray))
        
        let jsonData = try! JSONSerialization.data(withJSONObject: jsonArray, options: .fragmentsAllowed)
        print(jsonData)
        return JSON(jsonData)
    }
    
    override func setUp() {
        super.setUp()
        _ = mockServer.start()
    }

    override func tearDown() {
        super.tearDown()
        mockServer.stop()
    }
    
    func testRequest() async {
        let stubRequest = NetworkStubRequest(url: "https://davnopora.fun/kir/food", httpMethod: .GET)
        let stubResponse = NetworkStubResponse.json(json)
        
        let stub = NetworkStub(request: stubRequest, response: stubResponse)
        mockServer.setStub(stub)
        
        do {
            let products: [ProductsModel] = try await APIRequestDispatcher.request(apiRouter: .getProducts)
            XCTAssertEqual(mockServer.history.first?.request.httpMethod, NetworkStubMethod.GET)
        } catch {
            XCTFail("Test failed")
        }
    }
    
}



