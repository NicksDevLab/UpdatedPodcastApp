//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI
import CoreData

struct SearchBar: UIViewRepresentable {
  
  @Binding var searchText: String
  
  var viewModel: SearchViewModel
  
  
  
  class Coordinator: NSObject, UISearchBarDelegate {
    
    @Binding var text: String
    
    var viewModel: SearchViewModel
    // Used the PersistanceController singlton because I couldn't use
    // @Environment(\.managedObjectContext) inside Coordinator.
    private let persistance = PersistenceController.shared
    
    init(text: Binding<String>, viewModel: SearchViewModel) {
      _text = text
      self.viewModel = viewModel
    }
    
//    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//      searchBar.showsCancelButton = true
//    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
      text = searchText
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
      searchBar.endEditing(true)
      searchBar.showsCancelButton = false
      
      // Save the search term using CoreData for search history in SettingsView.
      let context = persistance.container.viewContext
      let item = NSEntityDescription.insertNewObject(forEntityName: "SearchItem", into: context) as! SearchItem
      item.term = searchBar.text
      item.date = Date()
      persistance.saveContext()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
      searchBar.endEditing(true)
      viewModel.returnedPodcasts = []
      searchBar.text = ""
    }
  }
  
  
  
  func makeCoordinator() -> SearchBar.Coordinator {
    return Coordinator(text: $searchText, viewModel: viewModel)
  }
  
  func makeUIView(context: UIViewRepresentableContext<SearchBar>) -> UISearchBar {
    let searchBar = UISearchBar(frame: .zero)
    searchBar.delegate = context.coordinator
    searchBar.searchBarStyle = .minimal
    searchBar.showsCancelButton = true
    return searchBar
  }
  
  func updateUIView(_ uiView: UISearchBar, context: UIViewRepresentableContext<SearchBar>) {
    uiView.text = searchText
  }
  
}
