//
//  BusinessDetails.swift
//  WhereToEat
//
//  Created by Zeynep on 24/12/2024.
//

import Foundation

struct BusinessDetails: Decodable {
    var is_closed: Bool
    var photos: [URL?]
    var hours: Hours
}

struct Hours: Decodable {
    var open: [OpeningTime]
    var hours_type: String
    var is_open_now: Bool
}

struct OpeningTime: Decodable {
    var is_overnight: Bool
    var start: String
    var end: String
    var day: Int
}
