//
//  Coordinator.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

import SwiftUI

protocol Coordinator {
    var network: any NetworkProtocol { get }
}
