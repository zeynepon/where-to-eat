//
//  BusinessViewModel.swift
//  WhereToEat
//
//  Created by Zeynep on 1/14/24.
//

import Foundation
import FirebaseFirestore

public class BusinessViewModel: ObservableObject {
    let db = Firestore.firestore()
    @Published public private(set) var isFavourite: Bool = false
    
    public func addBusiness(business: Business) {
        db.collection("businesses").addDocument(data: ["name": business.name])
    }
    
    public func updateFavourite() {
        isFavourite.toggle()
    }
}

public extension BusinessViewModel {
    func createMockBusiness() -> Business {
        Business(name: "Borough Market",
                 image_url: URL(string: "https://s3-media1.fl.yelpcdn.com/bphoto/r_vCRy6Cc3i425lsoawvrA/o.jpg"),
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
