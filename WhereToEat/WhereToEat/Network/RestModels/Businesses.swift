//
//  Businesses.swift
//  WhereToEat
//
//  Created by Zeynep on 11/5/23.
//

import Foundation

struct Businesses: Codable {
    var businesses: [Business]
}

struct Business: Codable, Hashable {
    var name: String
    var alias: String
    var image_url: String?
    var is_closed: Bool
    var url: URL?
    var review_count: Int
    var categories: [Category]
    var rating: Float
    var coordinates: Coordinate
    var price: String?
    var location: Location
    var phone: String
    var display_phone: String
    var distance: Double
    
    static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.name == rhs.name &&
        lhs.alias == rhs.alias &&
        lhs.image_url == rhs.image_url &&
        lhs.is_closed == rhs.is_closed &&
        lhs.url == rhs.url &&
        lhs.review_count == rhs.review_count &&
        lhs.categories == rhs.categories &&
        lhs.rating == rhs.rating &&
        lhs.coordinates == rhs.coordinates &&
        lhs.price == rhs.price &&
        lhs.location == rhs.location &&
        lhs.phone == rhs.phone &&
        lhs.display_phone == rhs.display_phone &&
        lhs.distance == rhs.distance
    }
}

struct Category: Codable, Hashable {
    var title: String
}

struct Coordinate: Codable, Hashable {
    var latitude: Double
    var longitude: Double
}

struct Location: Codable, Hashable {
    var address1: String
    var address2: String?
    var address3: String?
    var city: String
    var zip_code: String
    var country: String
    var display_address: [String]
}
