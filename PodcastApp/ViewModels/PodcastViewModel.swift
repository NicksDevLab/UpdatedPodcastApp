//
//  PodcastViewModel.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import CoreData
import SwiftUI


final class PodcastViewModel: ObservableObject {
  
  static let shared = PodcastViewModel()
  
  @Published var podcastInfo = PodcastInfoStruct()
  @Published var podcastEpisodes: [Episode] = []
  @Published var imageData = Data()
  @Published var selectedEpisode: Episode?
  
  let subscribedService = SubscribeService.shared
  let imageRetriever = ImageRetrieverService.shared
  let audioPlayer = AudioPlayer.shared
  
  
  private let xmlParser = XmlParserService()
  
  private init() {}
  
  func playAudio(episode: Episode?) {
    audioPlayer.playPause(episode: episode, imageData: imageData, saveToPlayHistory: true)
  }
  
  func getPodcastInfo(fromUrlString: String, completion: @escaping () -> ()) {
    DispatchQueue.global().async {
      self.xmlParser.startParsing(feedUrl: fromUrlString) { [weak self] parsedInfo in
        DispatchQueue.main.async {
          self?.podcastInfo = parsedInfo?.0 ?? PodcastInfoStruct()
          self?.podcastEpisodes = parsedInfo?.1 ?? []
          completion()
        }
      }
    }
  }
  
  func retreiveImage(from urlString: String) {
    imageRetriever.getImage(imageUrl: urlString) { [weak self] retreivedImageData in
      self?.imageData = retreivedImageData
    }
  }
  
  func markEpisodesAsViewed(podcast: Podcast) {
    let request = Episode.fetchRequest()
    request.predicate = NSPredicate(format: "podcast.trackName == %@", podcast.trackName ?? "")
    do {
      let episodes = try PersistenceController.shared.container.viewContext.fetch(request)
      for episode in episodes {
        episode.hasBeenViewed = 1
      }
      try PersistenceController.shared.container.viewContext.save()
    } catch {
      print(error)
    }
//    getPodcastInfo(fromUrlString: podcast.feedUrl ?? "") {
//      
//    }
  }
  
  func clearStorage() {
    self.imageData = Data()
    self.podcastEpisodes = []
    self.podcastInfo = PodcastInfoStruct()
  }
}
