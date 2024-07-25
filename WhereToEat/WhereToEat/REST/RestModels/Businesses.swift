//
//  Businesses.swift
//  WhereToEat
//
//  Created by Zeynep on 11/5/23.
//

import Foundation

public protocol DataTypeProtocol: Codable {}

public struct Businesses: Codable, DataTypeProtocol {
    public var businesses: [Business]
}

public struct Business: Codable, Hashable {
    public var name: String
    public var image_url: URL?
    public var is_closed: Bool
    public var url: URL?
    public var review_count: Int
    public var categories: [Category]
    public var rating: Float
    public var coordinates: Coordinate
    public var price: String?
    public var location: Location
    public var phone: String
    public var display_phone: String
    public var distance: Double
    
    public static func == (lhs: Business, rhs: Business) -> Bool {
        return lhs.name == rhs.name &&
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

public struct Category: Codable, Hashable {
    public var title: String
}

public struct Coordinate: Codable, Hashable {
    public var latitude: Double
    public var longitude: Double
}

public struct Location: Codable, Hashable {
    public var address1: String
    public var address2: String?
    public var address3: String?
    public var city: String
    public var zip_code: String
    public var country: String
    public var display_address: [String]
}
