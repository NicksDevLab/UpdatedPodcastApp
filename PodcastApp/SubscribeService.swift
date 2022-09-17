//
//  SubscribeService.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation
import CoreData


final class SubscribeService: ObservableObject {
  
  static let shared = SubscribeService()
  
  private let persistence = PersistenceController.shared
  
  @Published var subscribedList: [Podcast] = []
  
  private init() {
    self.getLatestSubscibeList()
  }
  
  func manageSubscription(for podcast: Podcast) {
    if isSubscribed(id: podcast.id!) {
      unFollowPodcast(podcast: podcast)
    } else {
      followPodcast(podcast: podcast)
    }
  }
  
  private func unFollowPodcast(podcast: Podcast) {
    do {
      let requestResults = try persistence.container.viewContext.fetch(Podcast.fetchRequest())
      for each in requestResults {
        if each.collectionId == podcast.collectionId {
          persistence.container.viewContext.delete(each)
        }
      }
    } catch {
      print("Error fetching Podcasts in SubsribeService - Error: ", error)
    }
    getLatestSubscibeList()
  }
  
  private func followPodcast(podcast: Podcast) {
    
    let context = persistence.container.viewContext
    let item = NSEntityDescription.insertNewObject(forEntityName: "Podcast", into: context) as! Podcast
    item.trackName = podcast.trackName
    item.artworkUrl600 = podcast.artworkUrl600
    item.artworkUrl100 = podcast.artworkUrl100
    item.feedUrl = podcast.feedUrl
    item.wrapperType = podcast.wrapperType
    item.kind = podcast.kind
    item.collectionId = Int(podcast.collectionId)
    item.collectionCensoredName = podcast.collectionCensoredName
    item.trackCensoredName = podcast.trackCensoredName
    item.collectionViewUrl = podcast.collectionViewUrl
    item.trackViewUrl = podcast.trackViewUrl
    item.artworkUrl30 = podcast.artworkUrl30
    item.artworkUrl60 = podcast.artworkUrl60
    item.collectionPrice = podcast.collectionPrice
    item.trackPrice = podcast.trackPrice
    item.trackRentalPrice = podcast.trackRentalPrice
    item.collectionHdPrice = podcast.collectionHdPrice
    item.trackHdPrice = podcast.trackHdPrice
    item.trackHdRentalPrice = podcast.trackHdRentalPrice
    item.releaseDate = podcast.releaseDate
    item.collectionExplicitness = podcast.collectionExplicitness
    item.trackExplicitness = podcast.trackExplicitness
    item.trackCount = Int(podcast.trackCount)
    item.country = podcast.country
    item.currency = podcast.currency
    item.primaryGenreName = podcast.primaryGenreName
    item.contentAdvisoryRating = podcast.contentAdvisoryRating
    item.lastCheckedForNewEpisodes = Date()
    item.imageData = podcast.imageData ?? Data()
    item.id = podcast.id
    
    persistence.saveContext()

    getLatestSubscibeList()
  }
  
  
  func getLatestSubscibeList() {
    let context = persistence.container.viewContext
    let request = Podcast.fetchRequest()
    do {
      self.subscribedList = try context.fetch(request)
    } catch {
      print("Error fetching Podcast - Error: ", error)
    }
  }
  
  
  func isSubscribed(id: UUID) -> Bool {
    for each in subscribedList {
      if each.id == id {
        return true
      }
    }
    return false
  }
  
  
  func delete(indexSet: IndexSet) {
    let context = persistence.container.viewContext
    let request = Podcast.fetchRequest()
    do {
      let items = try context.fetch(request)
      for index in indexSet {
        let podcast = items[index]
        context.delete(podcast)
        persistence.saveContext()
      }
    } catch {
      print("Error fetching Podcast - Error: ", error)
    }
  }
}
