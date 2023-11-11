//
//  BusinessView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessView: View {
    private let business: Business
    
    init(business: Business) {
        self.business = business
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let viewModel = InitialMapViewModel()
    return BusinessView(business: viewModel.createMockBusiness())
}
