//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct SearchCellView: View {
  
  @ObservedObject var viewModel = SearchCellViewModel()
  
  var podcast: Podcast
  
  var body: some View {
    
    NavigationLink(destination: PodcastView(podcast: podcast)) {
      ZStack(alignment: .leading) {
        Color(UIColor.secondarySystemBackground)
        HStack(alignment: .center, spacing: 10) {
          Image(uiImage: UIImage(data: viewModel.imageData) ?? UIImage())
            .resizable()
            .frame(width: 75, height: 75)
            .cornerRadius(5)
            .padding([.leading], 10)
            .redacted(reason: viewModel.imageData == Data() ? .placeholder : [])
          Text(podcast.trackName!)
            .foregroundColor(Color.green)
            .font(.body)
            .padding([.trailing], 10)
        }
      }
    }
    .frame(height: 95)
    .cornerRadius(10)
    .padding([.leading, .trailing], 10)
    .onAppear {
      if viewModel.imageData == Data() {
        viewModel.getImageData(from: podcast.artworkUrl100 ?? "")
      }
    }
  }
}
