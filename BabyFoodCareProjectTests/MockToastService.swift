//
//  MockToastService.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 31.12.2024.
//

import Foundation
@testable import BabyFoodCareProject

final class MockToastService: ToastServiceProtocol {
    
    // MARK: Properties
    private(set) var showToastCalled = false
    private(set) var showToastCallCount = 0
    private(set) var lastStyle: ToastStyle?
    private(set) var lastMessage: String?
    private(set) var allMessages: [(style: ToastStyle, message: String)] = []
    
    // MARK: ToastServiceProtocol
    func showToast(style: ToastStyle, message: String) {
        showToastCalled = true
        showToastCallCount += 1
        lastStyle = style
        lastMessage = message
        allMessages.append((style: style, message: message))
    }
    
    // MARK: Test Helpers
    func reset() {
        showToastCalled = false
        showToastCallCount = 0
        lastStyle = nil
        lastMessage = nil
        allMessages.removeAll()
    }
}
