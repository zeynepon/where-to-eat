//
//  RestaurantsCoordinator.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

final class RestaurantsCoordinator: Coordinator {
    typealias view = BusinessListView
    
    let restClient: any RestClientProtocol
    private var searchText: String = ""
    
    init(restClient: any RestClientProtocol) {
        self.restClient = restClient
    }
    
    func instantiate() -> BusinessListView? {
        guard let viewModel = restClient as? InitialMapViewModel else { return nil }
        return BusinessListView(viewModel: viewModel, searchText: searchText)
    }
    
    func setUpBusinessesView(searchText: String) -> BusinessListView? {
        self.searchText = searchText
        return instantiate()
    }
}
