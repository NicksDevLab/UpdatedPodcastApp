//
//  AudioPlayer.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/16/22.
//

import SwiftUI

class AudioPlayerViewModel: ObservableObject {
  
  @Published var audioPlayer = AudioPlayer.shared
  
}



struct AudioPlayerView: View {
  
  @ObservedObject var podcastViewModel = PodcastViewModel.shared
  @ObservedObject var viewModel = AudioPlayerViewModel()
  @State private var showEpisode = false
  
  var body: some View {
    VStack{
      HStack {
        Button(action: {
          self.podcastViewModel.imageData = self.viewModel.audioPlayer.imageData
          showEpisode.toggle()
        }) {
          Image(uiImage: UIImage(data: viewModel.audioPlayer.imageData) ?? UIImage())
            .resizable()
            .frame(width: 50, height: 50)
        }
        Spacer()
        PlayerButton(action: {viewModel.audioPlayer.playPause(episode: viewModel.audioPlayer.episode, imageData: viewModel.audioPlayer.imageData,
                                                    saveToPlayHistory: false)},
                     systemName: viewModel.audioPlayer.state == .notPlaying || viewModel.audioPlayer.state == .paused ? "play" : "pause")
        Spacer()
        PlayerButton(action: {viewModel.audioPlayer.seekByIncrement(direction: .backwardBy15Seconds)},
                     systemName: "gobackward.15")
        Spacer()
        PlayerButton(action: {viewModel.audioPlayer.seekByIncrement(direction: .forwardBy30Seconds)},
                     systemName: "goforward.30")
        Spacer()
        PlayerMenu()
      }
      PlayerSlider()
    }
    .padding([.leading, .trailing], 10)
    .frame(height: 100)
    .sheet(isPresented: $showEpisode) {
      EpisodeView()
    }
  }
}


struct PlayerButton: View {
  
  let action: () -> Void
  let systemName: String
  
  var body: some View {
    Button(action: action) {
      Image(systemName: systemName)
        .resizable()
        .frame(width: 20, height: 20)
        .foregroundColor(.green)
    }
  }
}


struct PlayerMenu: View {
  
  @EnvironmentObject var audioPlayer: AudioPlayer
  
  var body: some View {
    Menu(content: {
      Button(LocalizedStringKey("1.0")) {
        audioPlayer.setPlaybackSpeed(rate: 1.0)
      }
      Button(LocalizedStringKey("1.25")) {
        audioPlayer.setPlaybackSpeed(rate: 1.25)
      }
      Button(LocalizedStringKey("1.5")) {
        audioPlayer.setPlaybackSpeed(rate: 1.5)
      }
      Button(LocalizedStringKey("1.75")) {
        audioPlayer.setPlaybackSpeed(rate: 1.75)
      }
      Button(LocalizedStringKey("2.0")) {
        audioPlayer.setPlaybackSpeed(rate: 2.0)
      }
    }) {
      Label {
        Image(systemName: "ellipsis")
          .resizable()
          .frame(width: 20, height: 5)
      } icon: {
      }
    }
  }
}


struct PlayerSlider: View {
  
  @EnvironmentObject var audioPlayer: AudioPlayer
  
  var body: some View {
    HStack {
      Text(String(audioPlayer.getElapsedTime()))
        .font(.footnote)
        .frame(width: 50)
      Slider(value: $audioPlayer.currentProgress, in: (0...audioPlayer.episode.episodeDurationAsDouble), onEditingChanged: { didChange in
        audioPlayer.didSliderChange(didChange)
      })
      Text(audioPlayer.getTimeRemaining(duration: audioPlayer.episode.episodeDurationAsDouble))
        .font(.footnote)
        .frame(width: 50)
    }.foregroundColor(Color.green)
  }
}
