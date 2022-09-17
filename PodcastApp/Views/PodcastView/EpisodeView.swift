//
//  EpisodeView.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/11/22.
//

import SwiftUI



struct EpisodeView: View {
  
  @ObservedObject var viewModel = PodcastViewModel.shared
  
  var body: some View {
    
    GeometryReader { geometry in
      VStack {
        Image(uiImage: UIImage(data: viewModel.imageData) ?? UIImage())
          .resizable()
          .frame(width: geometry.size.width / 1.3, height: geometry.size.width / 1.3)
          .cornerRadius(5)
          .padding([.top], 10)
          .redacted(reason: viewModel.imageData == Data() ? .placeholder : [])
        HStack {
          Text(viewModel.selectedEpisode?.itunesTitle ?? "No Title")
          Text(viewModel.selectedEpisode?.formattedPubDate ?? "No Date")
        }
        ScrollView {
          Text(viewModel.selectedEpisode?.episodeDescription ?? "No Description")
        }
        HStack {
//          PlayButton(displayText: "Play", episode: episode, imageData: imageData ?? Data())
//          DownloadButton(displayText: "Download", episode: episode, imageData: imageData!)
        }
      }
      .padding([.leading, .trailing], 10)
    }
    .onAppear {
      
    }
  }
}

struct DownloadButton: View {
  
  @ObservedObject var viewModel = PodcastViewModel.shared
  
  let displayText: String
  let episode: Episode
  let imageData: Data
  
  var body: some View {
    Button(action: {
      //Download task
    }) {
      ZStack {
        Rectangle()
          .frame(width: 80, height: 35)
          .foregroundColor(Color.green)
          .cornerRadius(10)
        Rectangle()
          .frame(width: 78, height: 33)
          .foregroundColor(Color(UIColor.systemBackground))
          .cornerRadius(9)
        Text(displayText)
          .foregroundColor(Color.green)
      }
    }
  }
}

extension Image {
  static func withSystemName(_ systemName: String) -> some View {
    return Image(systemName: systemName)
            .resizable()
            .frame(width: 30, height: 30)
  }
}
