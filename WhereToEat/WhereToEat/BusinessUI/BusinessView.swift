//
//  BusinessView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessView: View {
    private let business: Business
    @ObservedObject private var viewModel: BusinessViewModel
    
    init(business: Business, viewModel: BusinessViewModel) {
        self.business = business
        self.viewModel = viewModel
    }
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                VStack(spacing: .zero) {
                    Text(business.name)
                        .font(.largeTitle)
                        .bold()
                        .fontDesign(.serif)
                        .multilineTextAlignment(.center)
                    businessInfo
                    rating
                    AsyncImage(url: URL(string: business.image_url)) { phase in
                        switch phase {
                        case .empty:
                            ProgressView()
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: geometry.size.width / 2, height: geometry.size.height / 2, alignment: .center)
                                .padding()
                                .overlay(.quinary, in: .rect(cornerRadii: RectangleCornerRadii(), style: .continuous))
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                    .padding()
                }
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button {
                            viewModel.addBusiness(business: business)
                            viewModel.updateFavourite()
                        } label: {
                            viewModel.isFavourite ? Image(systemName: "star.fill") : Image(systemName: "star")
                        }
                    }
                }
            }
        }
    }
    
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
        .padding()
    }
    
    @ViewBuilder
    private var rating: some View {
        // TODO: There's gotta be a better way to do this, find it
        HStack {
            if business.rating == 0 {
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating > 0 && business.rating < 1 {
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating == 1 {
                Image(systemName: "star.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating > 1 && business.rating < 2 {
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating == 2 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating > 2 && business.rating < 3 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating == 3 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star")
                Image(systemName: "star")
            } else if business.rating > 3 && business.rating < 4 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
                Image(systemName: "star")
            } else if business.rating == 4 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star")
            } else if business.rating > 4 && business.rating < 5 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.leadinghalf.fill")
            } else if business.rating == 5 {
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
                Image(systemName: "star.fill")
            }
        }
        .foregroundColor(.yellow)
    }
}

#Preview {
    let viewModel = BusinessViewModel()
    return BusinessView(business: viewModel.createMockBusiness(), viewModel: viewModel)
}
