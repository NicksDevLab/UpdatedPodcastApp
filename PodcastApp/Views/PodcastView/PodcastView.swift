//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI


struct PodcastView: View {
  
  let podcast: Podcast
  @StateObject private var viewModel = PodcastViewModel.shared
  
  @Environment(\.presentationMode) private var mode
  
  var body: some View {
    ScrollView([.vertical]) {

      PodcastHeaderView(podcast: podcast)
      .padding([.leading, .trailing], 10)

      if viewModel.podcastEpisodes == [] {
        LoadingSpinner()
      } else {
        ForEach(viewModel.podcastEpisodes, id: \.self) { episode in
          EpisodeCellView(episode: episode)
          .padding([.leading, .trailing], 10)
        }
      }
    }
    .navigationBarBackButtonHidden(true)
    .toolbar {
      PodcastViewToolbarContent(mode: mode)
    }
    .onAppear {
      viewModel.getPodcastInfo(fromUrlString: podcast.feedUrl ?? "") {
        viewModel.objectWillChange.send()
      }
      if podcast.imageData == nil {
        viewModel.retreiveImage(from: podcast.artworkUrl600 ?? "")
        podcast.imageData = viewModel.imageData
        viewModel.objectWillChange.send()
      }
    }
    .onDisappear {
      viewModel.clearStorage()
      viewModel.markEpisodesAsViewed(podcast: podcast)
    }
  }
  
}

