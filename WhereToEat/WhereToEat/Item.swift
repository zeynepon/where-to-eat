//
//  Item.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
