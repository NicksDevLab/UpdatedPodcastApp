//
//  EpisodeCellView.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct EpisodeCellView: View {
  
  @ObservedObject var viewModel = PodcastViewModel.shared
  @State private var showEpisode = false
  
  let episode: Episode
  
  private let divisorForViewHeight: CGFloat = 6
  
  
  var body: some View {
    ZStack {
      Color(UIColor.secondarySystemBackground)
      
      HStack {
      //TODO: Add new episode indicator.
        VStack(alignment: .leading) {
          Text(episode.title ?? "No Title")
            .font(.footnote)
            .fontWeight(.bold)
            .lineLimit(2)
          Spacer()
          Text(episode.episodeDescription ?? "No Description")
            .font(.caption)
            .lineLimit(3)
          Spacer()
          HStack {
            Text(episode.formattedPubDate)
              .font(.footnote)
              .fontWeight(.light)
            Spacer()
            Text(episode.formattedDuration)
              .font(.footnote)
          }
        }
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 85, maxHeight: .infinity, alignment: .topLeading)
      .padding(5)
    }
    .cornerRadius(10)
    .onTapGesture {
      self.viewModel.selectedEpisode = episode
      self.$showEpisode.wrappedValue.toggle()
    }
    .sheet(isPresented: $showEpisode) {
      EpisodeView()
    }
  }
  
}
