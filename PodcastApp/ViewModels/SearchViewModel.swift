//
//  SearchViewModel.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/10/22.
//

import SwiftUI

final class SearchViewModel: ObservableObject {
  
  @Published var isLoading = false
  @Published var returnedPodcasts: [Podcast] = []
  
  private let searchService = SearchService.shared
  private var searchWorkItem: DispatchWorkItem?
  
  private let tileCategories: [String : LinearGradient] = [
    "Sports" : LinearGradient(gradient: Gradient(colors: [.red, .orange]),
                              startPoint: .top, endPoint: .bottom),
    "News" : LinearGradient(gradient: Gradient(colors: [.green, .yellow]),
                            startPoint: .top, endPoint: .bottom),
    "Comedy" : LinearGradient(gradient: Gradient(colors: [.purple, .blue]),
                              startPoint: .top, endPoint: .bottom),
    "Religion" : LinearGradient(gradient: Gradient(colors: [.cyan, .gray]),
                                startPoint: .top, endPoint: .bottom),
    "Science" : LinearGradient(gradient: Gradient(colors: [.mint, .teal]),
                               startPoint: .top, endPoint: .bottom),
    "Technology" : LinearGradient(gradient: Gradient(colors: [.cyan, .indigo]),
                               startPoint: .top, endPoint: .bottom),
    "Politics" : LinearGradient(gradient: Gradient(colors: [.yellow, .blue]),
                               startPoint: .top, endPoint: .bottom),
    "Art" : LinearGradient(gradient: Gradient(colors: [.indigo, .pink]),
                               startPoint: .top, endPoint: .bottom),
    "Culture" : LinearGradient(gradient: Gradient(colors: [.red, .purple]),
                               startPoint: .top, endPoint: .bottom),
    "Military" : LinearGradient(gradient: Gradient(colors: [.green, .brown]),
                               startPoint: .top, endPoint: .bottom)
  ]
 
  lazy var categories: [String] = {
    self.tileCategories.keys.sorted()
  }()
  
  let divisorForTileSize: CGFloat = 2.3
  
  func getLinearGradient(for tileName: String) -> LinearGradient {
    return tileCategories[tileName] ??
           LinearGradient(gradient: Gradient(colors: [.black, Color(UIColor.lightGray)]),
                          startPoint: .bottomLeading, endPoint: .topTrailing)
  }
  
  func searchFor(term: String) {
    self.isLoading = true
    
    searchWorkItem?.cancel()
    
    // Wrapping the network call in a DispatchWorkItem to reduce the amount of requests while
    // the user is typing. This will cancel the previous pending request if the user
    // types another letter into the search bar within the specified time.
    searchWorkItem = DispatchWorkItem { [weak self] in
      DispatchQueue.main.async {
        self?.searchService.getSearchResults(forTerm: term) { results in
          self?.returnedPodcasts = results
          self?.isLoading = false
        }
      }
    }
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: searchWorkItem!)
  }
  
}
