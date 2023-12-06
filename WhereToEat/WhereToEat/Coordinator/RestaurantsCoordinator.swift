//
//  RestaurantsCoordinator.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

final class RestaurantsCoordinator: Coordinator {
    typealias view = BusinessesView
    
    let restClient: any RestClientProtocol
    private var searchText: String = ""
    
    init(restClient: any RestClientProtocol) {
        self.restClient = restClient
    }
    
    func instantiate() -> BusinessesView? {
        guard let viewModel = restClient as? InitialMapViewModel else { return nil }
        return BusinessesView(viewModel: viewModel, searchText: searchText)
    }
    
    func setUpBusinessesView(searchText: String) -> BusinessesView? {
        self.searchText = searchText
        return instantiate()
    }
}
