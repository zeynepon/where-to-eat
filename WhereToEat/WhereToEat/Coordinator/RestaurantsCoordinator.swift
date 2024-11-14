//
//  RestaurantsCoordinator.swift
//  WhereToEat
//
//  Created by Zeynep on 12/1/23.
//

final class RestaurantsCoordinator: Coordinator {
    typealias view = BusinessListView
    
    let network: any NetworkProtocol
    
    init(network: any NetworkProtocol) {
        self.network = network
    }
}
