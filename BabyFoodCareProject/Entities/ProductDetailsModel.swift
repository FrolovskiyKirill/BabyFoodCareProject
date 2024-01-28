//
//  ProductDetailsModel.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 28.01.2024.
//

import Foundation

struct Welcome: Codable {
    let title: String
    let foodType: String
    let description: String
    let imageURL: String
    let foodTypeImageURL: String
    let monthFrom: Int
    let allergen: Bool
    let allergenDescription: String
    let howToServe: String
    let howToServeImageURL: [String]
    let calories: Int
    let protein: Int
    let fats: Int
    let carbs: Int
    let withWarning: Bool
    let warningNote: String
}
