//
//  WhereToEatApp.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

import SwiftUI
import SwiftData

@main
struct WhereToEatApp: App {
    var body: some Scene {
        WindowGroup {
            let viewModel = InitialMapViewModel()
            MapView(viewModel: viewModel)
        }
    }
}
