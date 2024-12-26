//
//  FavoritesViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 08/09/2024.
//

import Foundation

class FavoritesViewModel: ObservableObject {
    private let userDefaults: UserDefaults
    private let userDefaultsKey: String
    @Published var favorites: [Business]
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.userDefaultsKey = "Favorites"
        
        var favorites: [Business]?
        if let data = userDefaults.data(forKey: userDefaultsKey) {
            favorites = try? PropertyListDecoder().decode([Business].self, from: data)
        }
        self.favorites = favorites ?? []
    }
    
    public func addFavorite(_ business: Business) {
        favorites.append(business)
        setUserDefaults()
    }
    
    public func isFavorite(_ business: Business) -> Bool {
        favorites.contains(business)
    }
    
    public func remove(at offsets: IndexSet) {
        favorites.remove(atOffsets: offsets)
        setUserDefaults()
    }
    
    public func removeFavorite(_ business: Business) {
        favorites.removeAll(where: { $0 == business })
        setUserDefaults()
    }
    
    private func setUserDefaults() {
        if let encoded = try? PropertyListEncoder().encode(favorites) {
            userDefaults.set(encoded, forKey: userDefaultsKey)
        }
    }
}
