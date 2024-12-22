//
//  SearchViewRepresentable.swift
//  WhereToEat
//
//  Created by Zeynep on 22/12/2024.
//

import SwiftUI

struct SearchViewRepresentable: UIViewRepresentable {
    typealias UIViewType = UISearchBar
    
    @Binding var searchText: String
    private let viewModel: SearchViewModel
    
    init(searchText: Binding<String>, viewModel: SearchViewModel) {
        self._searchText = searchText
        self.viewModel = viewModel
    }
    
    func makeUIView(context: Context) -> UISearchBar {
        let searchBar = UISearchBar()
        searchBar.delegate = context.coordinator
        searchBar.searchBarStyle = .minimal
        
        return searchBar
    }
    
    func updateUIView(_ uiView: UISearchBar, context: Context) {
        uiView.text = searchText
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(searchText: $searchText, viewModel: viewModel)
    }
    
    class Coordinator: NSObject, UISearchBarDelegate {
        @Binding var searchText: String
        private let viewModel: SearchViewModel
        
        init(searchText: Binding<String>, viewModel: SearchViewModel) {
            self._searchText = searchText
            self.viewModel = viewModel
        }

        func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            self.searchText = searchText
        }
        
        func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            searchBar.endEditing(true)
            viewModel.evaluateSearchState(searchText: searchText)
        }
    }
}
