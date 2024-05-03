//
//  Mockable.swift
//  BabyFoodCareProjectTests
//
//  Created by Kirill Frolovskiy on 16.03.2024.
//

import Foundation

protocol Mockable: AnyObject {
    var bundle: Bundle { get }
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> [T]
}

extension Mockable {
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    func loadJSON<T: Decodable>(filename: String, type: T.Type) -> [T] {
        guard let path = bundle.url(forResource: filename, withExtension: "json") else {
            fatalError("Failed to load JSON file.")
        }
        
        do {
            let data = try Data(contentsOf: path)
            let decodedobject = try JSONDecoder().decode([T].self, from: data)
            
            return decodedobject
        } catch {
            print("❌ \(error)")
            fatalError("Failed to decode the JSON.")
        }
    }
}

             
