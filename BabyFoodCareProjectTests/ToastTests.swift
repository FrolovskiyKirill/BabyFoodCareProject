//
//  ToastTests.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 31.12.2024.
//

import XCTest
@testable import BabyFoodCareProject

// MARK: - ToastStyle Tests
final class ToastStyleTests: XCTestCase {
    
    // MARK: - Test 1: Negative style has correct background color
    func testNegativeStyleBackgroundColor() {
        let style = ToastStyle.negative
        XCTAssertEqual(style.backgroundColor, UIColor.systemRed)
    }
    
    // MARK: - Test 2: Neutral style has correct background color
    func testNeutralStyleBackgroundColor() {
        let style = ToastStyle.neutral
        XCTAssertEqual(style.backgroundColor, UIColor.black)
    }
    
    // MARK: - Test 3: Negative style has white text color
    func testNegativeStyleTextColor() {
        let style = ToastStyle.negative
        XCTAssertEqual(style.textColor, UIColor.white)
    }
    
    // MARK: - Test 4: Neutral style has white text color
    func testNeutralStyleTextColor() {
        let style = ToastStyle.neutral
        XCTAssertEqual(style.textColor, UIColor.white)
    }
    
    // MARK: - Test 5: Negative style has correct icon
    func testNegativeStyleIcon() {
        let style = ToastStyle.negative
        XCTAssertEqual(style.iconName, "exclamationmark.circle.fill")
    }
    
    // MARK: - Test 6: Neutral style has correct icon
    func testNeutralStyleIcon() {
        let style = ToastStyle.neutral
        XCTAssertEqual(style.iconName, "info.circle.fill")
    }
    
    // MARK: - Test 7: Positive style has correct icon
    func testPositiveStyleIcon() {
        let style = ToastStyle.positive
        XCTAssertEqual(style.iconName, "checkmark.circle.fill")
    }
    
    // MARK: - Test 8: All styles have valid SF Symbol icons
    func testAllStylesHaveValidIcons() {
        let styles: [ToastStyle] = [.negative, .neutral, .positive]
        
        for style in styles {
            let image = UIImage(systemName: style.iconName)
            XCTAssertNotNil(image, "Icon '\(style.iconName)' should be a valid SF Symbol")
        }
    }
}

// MARK: - ToastView Tests
final class ToastViewTests: XCTestCase {
    
    // MARK: - Test 1: ToastView initializes with correct style
    func testToastViewInitializesWithStyle() {
        let toastView = ToastView(style: .negative, message: "Error message")
        
        XCTAssertNotNil(toastView)
        XCTAssertEqual(toastView.backgroundColor, ToastStyle.negative.backgroundColor)
    }
    
    // MARK: - Test 2: ToastView has correct corner radius
    func testToastViewHasCorrectCornerRadius() {
        let toastView = ToastView(style: .neutral, message: "Info message")
        
        XCTAssertEqual(toastView.layer.cornerRadius, 12)
    }
    
    // MARK: - Test 3: ToastView has shadow
    func testToastViewHasShadow() {
        let toastView = ToastView(style: .positive, message: "Success message")
        
        XCTAssertEqual(toastView.layer.shadowOpacity, 0.15, accuracy: 0.01)
        XCTAssertEqual(toastView.layer.shadowRadius, 8)
    }
    
    // MARK: - Test 4: ToastView translatesAutoresizingMaskIntoConstraints is false
    func testToastViewUsesAutoLayout() {
        let toastView = ToastView(style: .neutral, message: "Test")
        
        XCTAssertFalse(toastView.translatesAutoresizingMaskIntoConstraints)
    }
    
    // MARK: - Test 5: ToastView onDismiss callback is settable
    func testToastViewOnDismissCallback() {
        let toastView = ToastView(style: .negative, message: "Test")
        var callbackCalled = false
        
        toastView.onDismiss = {
            callbackCalled = true
        }
        
        toastView.onDismiss?()
        
        XCTAssertTrue(callbackCalled)
    }
    
    // MARK: - Test 6: ToastView creates with different styles
    func testToastViewCreatesWithAllStyles() {
        let styles: [ToastStyle] = [.negative, .neutral, .positive]
        
        for style in styles {
            let toastView = ToastView(style: style, message: "Test message for \(style)")
            XCTAssertNotNil(toastView)
            XCTAssertEqual(toastView.backgroundColor, style.backgroundColor)
        }
    }
}

// MARK: - MockToastService Tests
@MainActor
final class MockToastServiceTests: XCTestCase {
    
    var mockService: MockToastService!
    
    override func setUp() {
        super.setUp()
        mockService = MockToastService()
    }
    
    override func tearDown() {
        mockService = nil
        super.tearDown()
    }
    
    // MARK: - Test 1: Initial state is correct
    func testInitialState() {
        let showToastCalled = mockService.showToastCalled
        let showToastCallCount = mockService.showToastCallCount
        let lastStyle = mockService.lastStyle
        let lastMessage = mockService.lastMessage
        let allMessages = mockService.allMessages
        
        XCTAssertFalse(showToastCalled)
        XCTAssertEqual(showToastCallCount, 0)
        XCTAssertNil(lastStyle)
        XCTAssertNil(lastMessage)
        XCTAssertTrue(allMessages.isEmpty)
    }
    
    // MARK: - Test 2: showToast updates state correctly
    func testShowToastUpdatesState() {
        mockService.showToast(style: .negative, message: "Error occurred")
        
        let showToastCalled = mockService.showToastCalled
        let showToastCallCount = mockService.showToastCallCount
        let lastStyle = mockService.lastStyle
        let lastMessage = mockService.lastMessage
        
        XCTAssertTrue(showToastCalled)
        XCTAssertEqual(showToastCallCount, 1)
        XCTAssertEqual(lastStyle, .negative)
        XCTAssertEqual(lastMessage, "Error occurred")
    }
    
    // MARK: - Test 3: Multiple calls increment counter
    func testMultipleCallsIncrementCounter() {
        mockService.showToast(style: .negative, message: "First")
        mockService.showToast(style: .neutral, message: "Second")
        mockService.showToast(style: .positive, message: "Third")
        
        let showToastCallCount = mockService.showToastCallCount
        XCTAssertEqual(showToastCallCount, 3)
    }
    
    // MARK: - Test 4: Last style and message are updated
    func testLastStyleAndMessageUpdated() {
        mockService.showToast(style: .negative, message: "First")
        mockService.showToast(style: .positive, message: "Last")
        
        let lastStyle = mockService.lastStyle
        let lastMessage = mockService.lastMessage
        
        XCTAssertEqual(lastStyle, .positive)
        XCTAssertEqual(lastMessage, "Last")
    }
    
    // MARK: - Test 5: All messages are stored
    func testAllMessagesStored() {
        mockService.showToast(style: .negative, message: "Error")
        mockService.showToast(style: .neutral, message: "Info")
        mockService.showToast(style: .positive, message: "Success")
        
        let allMessages = mockService.allMessages
        
        XCTAssertEqual(allMessages.count, 3)
        XCTAssertEqual(allMessages[0].style, .negative)
        XCTAssertEqual(allMessages[0].message, "Error")
        XCTAssertEqual(allMessages[1].style, .neutral)
        XCTAssertEqual(allMessages[1].message, "Info")
        XCTAssertEqual(allMessages[2].style, .positive)
        XCTAssertEqual(allMessages[2].message, "Success")
    }
    
    // MARK: - Test 6: Reset clears all state
    func testResetClearsState() {
        mockService.showToast(style: .negative, message: "Test")
        mockService.showToast(style: .positive, message: "Another")
        
        mockService.reset()
        
        let showToastCalled = mockService.showToastCalled
        let showToastCallCount = mockService.showToastCallCount
        let lastStyle = mockService.lastStyle
        let lastMessage = mockService.lastMessage
        let allMessages = mockService.allMessages
        
        XCTAssertFalse(showToastCalled)
        XCTAssertEqual(showToastCallCount, 0)
        XCTAssertNil(lastStyle)
        XCTAssertNil(lastMessage)
        XCTAssertTrue(allMessages.isEmpty)
    }
    
    // MARK: - Test 7: Can call showToast after reset
    func testCanCallAfterReset() {
        mockService.showToast(style: .negative, message: "Before reset")
        mockService.reset()
        mockService.showToast(style: .positive, message: "After reset")
        
        let showToastCalled = mockService.showToastCalled
        let showToastCallCount = mockService.showToastCallCount
        let lastStyle = mockService.lastStyle
        let lastMessage = mockService.lastMessage
        
        XCTAssertTrue(showToastCalled)
        XCTAssertEqual(showToastCallCount, 1)
        XCTAssertEqual(lastStyle, .positive)
        XCTAssertEqual(lastMessage, "After reset")
    }
}

// MARK: - ToastService Protocol Conformance Tests
@MainActor
final class ToastServiceProtocolTests: XCTestCase {
    
    // MARK: - Test 1: MockToastService conforms to protocol
    func testMockConformsToProtocol() {
        let service: ToastServiceProtocol = MockToastService()
        XCTAssertNotNil(service)
    }
    
    // MARK: - Test 2: Protocol method can be called
    func testProtocolMethodCanBeCalled() {
        let service: ToastServiceProtocol = MockToastService()
        
        // Should not throw or crash
        service.showToast(style: .neutral, message: "Protocol test")
        
        if let mock = service as? MockToastService {
            let showToastCalled = mock.showToastCalled
            XCTAssertTrue(showToastCalled)
        }
    }
}
