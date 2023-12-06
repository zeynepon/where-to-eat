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
        GeometryReader { geometry in
            NavigationStack {
                Text(business.name)
                    .font(.largeTitle)
                businessInfo
                AsyncImage(url: URL(string: business.image_url)) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image.resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: geometry.size.width / 2, height: geometry.size.height / 2, alignment: .center)
                            .padding()
                    case .failure:
                        Image(systemName: "photo")
                    @unknown default:
                        EmptyView()
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var businessInfo: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: .zero) {
                ForEach(business.categories, id: \.self) { category in
                    Text(category.title)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            .padding()
            Spacer()
            VStack(alignment: .trailing, spacing: .zero) {
                ForEach(business.location.display_address, id: \.self) { line in
                    Text(line)
                        .font(.footnote)
                        .foregroundStyle(.gray)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let viewModel = InitialMapViewModel()
    return BusinessView(business: viewModel.createMockBusiness())
}
