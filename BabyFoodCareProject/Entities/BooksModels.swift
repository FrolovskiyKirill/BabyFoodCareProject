//
//  BooksModels.swift
//  BabyFoodCareProject
//
//  Created by Kirill Frolovskiy on 27.01.2024.
//

import Foundation

struct Authority: Codable {
    
    var id: Int
    var name: String
    var schemeType: Int
    
    public init(id: Int, name: String, schemeType: Int) {
        self.id = id
        self.name = name
        self.schemeType = schemeType
    }
    
    enum CodingKeys: String, CodingKey {
        case id = "LocalAuthorityId"
        case name = "Name"
        case schemeType = "SchemeType"
    }
}

struct AuthoritiesResponse: Codable {
    var authorities: [Authority]
}

struct Rating: Codable {

    let id: Int?
    let name: String
    let ratingKey: String
    let ratingKeyName: String
    let schemeId: Int
    enum CodingKeys: String, CodingKey {
        case id = "ratingId"
        case name = "ratingName"
        case ratingKey
        case ratingKeyName
        case schemeId = "schemeTypeId"
    }
}

struct RatingsResponse: Codable {
    let ratings: [Rating]
}

struct Establishment: Codable {

    let id: Int?
    let rating: String
    let ratingKey: String
    enum CodingKeys: String, CodingKey {
        case id = "FHRSID"
        case rating = "RatingValue"
        case ratingKey = "RatingKey"
    }
}

struct EstablishmentResponse: Codable {
    let establishments: [Establishment]
}
