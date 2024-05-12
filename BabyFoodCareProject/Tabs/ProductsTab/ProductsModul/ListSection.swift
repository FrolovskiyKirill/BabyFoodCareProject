//
//  ListSection.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 12.05.2024.
//

import Foundation

enum ListSection {
    case main([ProductsModel])
    
    var items: [ProductsModel] {
        switch self {
        case .main(let items):
            return items
        }
    }
    
    var count: Int {
        items.count
    }
    
    var title: String {
        switch self {
        case .main(_):
            ""
        }
    }
}
