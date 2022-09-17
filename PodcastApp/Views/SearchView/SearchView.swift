//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct SearchView: View {
  
  @State private var searchText = ""
  @ObservedObject private var viewModel = SearchViewModel()

  var body: some View {
    NavigationView {
      VStack {
        SearchBar(searchText: $searchText, viewModel: viewModel)
          .onChange(of: searchText) { _ in
            viewModel.searchFor(term: searchText)
            viewModel.objectWillChange.send()
          }
        
        if viewModel.isLoading {
          Spacer()
          LoadingSpinner()
          Spacer()
        } else {
          if viewModel.returnedPodcasts == [] {
            DiscoverView(viewModel: viewModel)
          } else {
            ScrollView {
              ForEach(viewModel.returnedPodcasts, id: \.self) { each in
                SearchCellView(podcast: each)
              }
            }
          }
        }
      }
      .navigationTitle(LocalizedStringKey("Search"))
    }
    
    .navigationViewStyle(StackNavigationViewStyle())
  }
}

