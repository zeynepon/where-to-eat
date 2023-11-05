//
//  Businesses.swift
//  WhereToEat
//
//  Created by Zeynep on 11/5/23.
//

public struct Business: Codable {
    public var id: String
    public var name: String
    public var image_url: String
    public var is_closed: Bool
    public var url: String
    public var review_count: Int
    public var categories: Category
    public var rating: Float
    public var coordinates: Coordinate
    public var price: String
    public var location: Location
    public var phone: String
    public var display_phone: String
    public var distance: UInt64
}

public enum Price: String {
    case one = "£"
    case two = "££"
    case three = "£££"
    case four = "££££"
    case five = "£££££"
}

public struct Category: Codable {
    public var title: String
}

public struct Coordinate: Codable {
    public var latitude: Int64
    public var longitude: Int64
}

public struct Location: Codable {
    public var address1: String
    public var address2: String
    public var address3: String
    public var city: String
    public var zip_code: String
    public var country: String
    public var display_address: String
}
