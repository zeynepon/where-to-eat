//
//  BusinessesView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessesView: View {
    var businesses: [Business]
    
    init(businesses: [Business]) {
        self.businesses = businesses
    }
    
    var body: some View {
        NavigationStack {
            ForEach(businesses, id: \.self) { business in
                NavigationLink {
                    BusinessView(business: business)
                } label: {
                    Text(business.name)
                }
            }
        }
    }
}

#Preview {
    let viewModel = InitialMapViewModel()
    return BusinessesView(businesses: [viewModel.createMockBusiness()])
}
