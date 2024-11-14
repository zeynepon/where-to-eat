//
//  WhereToEatApp.swift
//  WhereToEat
//
//  Created by Zeynep on 11/1/23.
//

// icon: <a target="_blank" href="https://icons8.com/illustrations/illustration/636007d77ae331000128d831">App</a> icon by <a target="_blank" href="https://icons8.com">Icons8</a>

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        let db = Firestore.firestore()
        return true
    }
}

@main
struct WhereToEatApp: App {
    // register app delegate for Firebase setup
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            let favouritesViewModel = FavouritesViewModel()
            let mapViewModel = MapViewModel(network: Network())
            LaunchView(mapViewModel: mapViewModel, favouritesViewModel: favouritesViewModel)
        }
    }
}
