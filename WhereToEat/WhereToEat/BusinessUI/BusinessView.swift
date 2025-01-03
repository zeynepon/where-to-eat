//
//  BusinessView.swift
//  WhereToEat
//
//  Created by Zeynep on 11/11/23.
//

import SwiftUI

struct BusinessView: View {
    let business: Business
    
    @StateObject private var viewModel: BusinessViewModel
    @State private var isShowingWebView = false
    
    init(business: Business, viewModel: BusinessViewModel) {
        self.business = business
        self._viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: .zero) {
                businessName
                businessInfo
                rating
                ScrollView(.horizontal) {
                    Group {
                        switch viewModel.businessDetailsLoadingState {
                        case .loading, .none:
                            redactedPhotosView(width: geometry.size.width / 2, height: geometry.size.height / 2)
                        case .success:
                            photosView(with: viewModel.businessDetails?.photos,
                                       width: geometry.size.width / 2,
                                       height: geometry.size.height / 2)
                        case .failure(let error):
                            noImagesView(errorMessage: error.description,
                                         width: geometry.size.height / 2,
                                         height: geometry.size.width / 2)
                        }
                    }
                    .padding()
                }
                Spacer()
                yelpLink
            }
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        viewModel.toggleFavourite()
                    } label: {
                        viewModel.isFavourite ? Image(systemName: "star.fill") : Image(systemName: "star")
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .task {
                await viewModel.getBusinessDetails()
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
    
    private var businessName: some View {
        Text(business.name)
            .font(.largeTitle)
            .bold()
            .fontDesign(.serif)
            .multilineTextAlignment(.center)
            .fixedSize(horizontal: false, vertical: true)
    }
    
    @ViewBuilder
    private var rating: some View {
        // TODO: There's gotta be a better way to do this, find it
        // https://jacobzivandesign.com/technology/five-star-rating/
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
    
    private var yelpLink: some View {
        Button {
            isShowingWebView.toggle()
        } label: {
            HStack(spacing: 4) {
                Text(String(localized: "View in "))
                Image("yelpLogo")
                    .resizable()
                    .frame(width: 51.20, height: 24.92)
                    .padding(.bottom, 6)
            }
        }
        .padding(.vertical)
        .fullScreenCover(isPresented: $isShowingWebView, content: {
            VStack(spacing: .zero) {
                HStack {
                    Spacer()
                    Button {
                        isShowingWebView = false
                    } label: {
                        Image(systemName: "xmark")
                            .padding()
                            .bold()
                    }
                }
                WebView(url: business.url)
            }
        })
    }
    
    private func noImagesView(errorMessage: String, width: CGFloat, height: CGFloat) -> some View {
        ZStack {
            roundedRectangle(width: width, height: height)
            Text(errorMessage)
                .bold()
        }
        .padding([.vertical, .trailing])
    }
    
    private func photosView(with photos: [URL]?, width: CGFloat, height: CGFloat) -> some View {
        HStack {
            if let photos {
                ForEach(photos, id: \.self) { photoURL in
                    AsyncImage(url: photoURL) { phase in
                        switch phase {
                        case .empty:
                            roundedRectangle(width: width, height: height)
                        case .success(let image):
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: width, height: height, alignment: .center)
                                .padding()
                                .overlay(.quinary, in: .rect(cornerRadii: RectangleCornerRadii(), style: .continuous))
                        case .failure:
                            Image(systemName: "photo")
                        @unknown default:
                            EmptyView()
                        }
                    }
                }
            }
        }
    }
    
    private func redactedPhotosView(width: CGFloat, height: CGFloat) -> some View {
        HStack {
            roundedRectangle(width: width, height: height)
            roundedRectangle(width: width, height: height)
            roundedRectangle(width: width, height: height)
        }
    }
    
    private func roundedRectangle(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(.redactedBackground)
            .frame(width: width, height: height, alignment: .center)
            .padding()
    }
}

#Preview {
    let viewModel = BusinessViewModel(business: BusinessViewModel.createMockBusiness(), favoritesViewModel: FavoritesViewModel())
    return BusinessView(business: viewModel.business, viewModel: viewModel)
}
