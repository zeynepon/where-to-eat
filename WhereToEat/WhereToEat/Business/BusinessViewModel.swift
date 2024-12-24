//
//  BusinessViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 1/14/24.
//

import Foundation

public class BusinessViewModel: ObservableObject {
    enum BusinessDetailsLoadingState {
        case loading
        case success
        case failure(error: NetworkError)
    }
    
    let business: Business
    private(set) var businessDetails: BusinessDetails?
    private let favoritesViewModel: FavoritesViewModel
    private let network: NetworkProtocol
    
    @Published private(set) var businessDetailsLoadingState: BusinessDetailsLoadingState?
    @Published private(set) var isFavourite: Bool
    @Published private(set) var shouldShowBusinessDetailsError: Bool = false
    
    init(business: Business, favoritesViewModel: FavoritesViewModel, network: NetworkProtocol = Network()) {
        self.business = business
        self.favoritesViewModel = favoritesViewModel
        self.network = network
        self.isFavourite = favoritesViewModel.isFavorite(business)
    }
    
    @MainActor
    func getBusinessDetails() async {
        businessDetailsLoadingState = .loading
        do {
            businessDetails = try await network.fetchBusinessDetails(businessAlias: business.alias)
            businessDetailsLoadingState = .success
        } catch let error {
            if let networkError = error as? NetworkError {
                businessDetailsLoadingState = .failure(error: networkError)
            }
        }
    }
    
    func toggleFavourite() {
        if !isFavourite {
            favoritesViewModel.addFavorite(business)
            isFavourite = true
        } else {
            favoritesViewModel.removeFavorite(business)
            isFavourite = false
        }
    }
}

extension BusinessViewModel {
    static func createMockBusiness() -> Business {
        Business(name: "Borough Market",
                 alias: "borough-market-london-3",
                 image_url: "https://s3-media1.fl.yelpcdn.com/bphoto/r_vCRy6Cc3i425lsoawvrA/o.jpg",
                 is_closed: false,
                 url: URL(string: "https://www.yelp.com/biz/borough-market-london-3?adjust_creative=RcwV6drVskI_uxj8EFdA6Q&utm_campaign=yelp_api_v3&utm_medium=api_v3_business_search&utm_source=RcwV6drVskI_uxj8EFdA6Q"),
                 review_count: 1843,
                 categories: [Category(title: "Farmers Market"), Category(title: "Beer, Wine & Spirits")],
                 rating: 4.5,
                 coordinates: Coordinate(latitude : 51.5051427191678, longitude : -0.0909365332063361),
                 price: "££",
                 location: Location(address1: "8 Southwark Street",
                                    city: "London",
                                    zip_code: "SE1 1TL",
                                    country: "GB",
                                    display_address: ["8 Southwark Street", "London SE1 1TL", "United Kingdom"]),
                 phone: "+442030262283",
                 display_phone: "+44 20 3026 2283",
                 distance: 3230.9293288880117)
    }
}
