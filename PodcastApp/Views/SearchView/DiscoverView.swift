//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct DiscoverView: View {
  
  var viewModel: SearchViewModel
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView {
        LazyVGrid(columns: [GridItem(.fixed(geometry.size.width / viewModel.divisorForTileSize)),
                            GridItem(.fixed(geometry.size.width / viewModel.divisorForTileSize))]) {
          ForEach(viewModel.categories, id: \.self) { key in
            Button(action: {
              viewModel.searchFor(term: key)
            }) {
              ZStack {
                Rectangle()
                  .fill(viewModel.getLinearGradient(for: key))
                  .frame(width: geometry.size.width / viewModel.divisorForTileSize,
                         height: geometry.size.width / viewModel.divisorForTileSize)
                  .cornerRadius(10)
                Text(key)
                  .font(.title)
                  .fontWeight(.bold)
                  .foregroundColor(Color.white)
              }
            }
          }
        }
      }
    }
  }
}
