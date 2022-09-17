//
//  PodcastHeaderView.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct PodcastHeaderView: View {
  
  let podcast: Podcast
  @ObservedObject var viewModel = PodcastViewModel.shared
  
  private let divisorForImage: CGFloat = 2.5
  private let imageCornerRaduis: CGFloat = 5
  
  var body: some View {
    ZStack(alignment: .top) {
      Color(UIColor.secondarySystemBackground)
      VStack(alignment: .leading) {
        HStack(alignment: .top) {

          Image(uiImage: UIImage(data: viewModel.imageData) ?? UIImage())
            .resizable()
            .frame(width: 175, height: 175)
            .redacted(reason: viewModel.imageData == Data() ? .placeholder : [])
            .cornerRadius(imageCornerRaduis)

          VStack(alignment: .center) {
            Text(podcast.trackName ?? "No Name")
              .font(.headline).fontWeight(.bold)
            Text(podcast.artistName != nil ? podcast.artistName! : String(""))
              .font(.subheadline).fontWeight(.light)
            Spacer()
            HStack(alignment: .center) {
              Spacer()
              PlayButton(displayText: "Play", episode: viewModel.podcastEpisodes.first)
              Spacer()
              SubscribeButton(podcast: podcast)
              Spacer()
            }
          }
          .frame(height: 175)
        }
        ScrollView {
          ExpandableText(text: viewModel.podcastInfo.description)
        }
        .padding([.top], 10)
      }
      .padding(5)
      
    }
    .frame(minHeight: 225)
    .cornerRadius(10)
  }
  
}


struct PlayButton: View {
  
  @ObservedObject var viewModel = PodcastViewModel.shared
  
  let displayText: String
  let episode: Episode?
  
  var body: some View {
    Button(action: {
      viewModel.selectedEpisode = episode
      viewModel.playAudio(episode: episode)
    }) {
      ZStack {
        Rectangle()
          .frame(width: 80, height: 35)
          .foregroundColor(Color.blue)
          .cornerRadius(10)
        Rectangle()
          .frame(width: 78, height: 33)
          .foregroundColor(Color(UIColor.systemBackground))
          .cornerRadius(9)
        Text(displayText)
          .foregroundColor(Color.blue)
      }
    }
  }
}


struct SubscribeButton: View {
  
  @ObservedObject var viewModel = PodcastViewModel.shared
  let podcast: Podcast
  
  var body: some View {
    Button(action: {
      viewModel.subscribedService.manageSubscription(for: podcast)
    }) {
      ZStack {
        Rectangle()
          .frame(width: 80, height: 35)
          .foregroundColor(viewModel.subscribedService.isSubscribed(id: podcast.id!) ?
                           Color.orange : Color.green)
          .cornerRadius(10)
        Rectangle()
          .frame(width: 78, height: 33)
          .foregroundColor(Color(UIColor.systemBackground))
          .cornerRadius(9)
        Text(viewModel.subscribedService.isSubscribed(id: podcast.id!) ?
             "Unfollow" : "Follow")
        .foregroundColor(viewModel.subscribedService.isSubscribed(id: podcast.id!) ?
                           Color.orange : Color.green)
      }
    }
  }
}
