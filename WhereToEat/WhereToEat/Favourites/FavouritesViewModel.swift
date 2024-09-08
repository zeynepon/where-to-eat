//
//  FavouritesViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 08/09/2024.
//

import Foundation

class FavouritesViewModel: ObservableObject {
    private let userDefaults: UserDefaults
    private let userDefaultsKey: String
    @Published var favourites: [Business]
    
    init(userDefaults: UserDefaults = UserDefaults.standard) {
        self.userDefaults = userDefaults
        self.userDefaultsKey = "Favourites"
        
        var favourites: [Business]?
        if let data = userDefaults.data(forKey: userDefaultsKey) {
            favourites = try? PropertyListDecoder().decode([Business].self, from: data)
        }
        self.favourites = favourites ?? []
    }
    
    public func addFavourite(_ business: Business) {
        favourites.append(business)
        setUserDefaults()
    }
    
    public func isFavourite(_ business: Business) -> Bool {
        favourites.contains(business)
    }
    
    public func remove(at offsets: IndexSet) {
        favourites.remove(atOffsets: offsets)
        setUserDefaults()
    }
    
    public func removeFavourite(_ business: Business) {
        favourites.removeAll(where: { $0 == business })
        setUserDefaults()
    }
    
    private func setUserDefaults() {
        if let encoded = try? PropertyListEncoder().encode(favourites) {
            userDefaults.set(encoded, forKey: userDefaultsKey)
        }
    }
}
