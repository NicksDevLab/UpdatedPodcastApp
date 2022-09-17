//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//


import Foundation
import CoreData


extension Podcast {

  @nonobjc public class func fetchRequest() -> NSFetchRequest<Podcast> {
      return NSFetchRequest<Podcast>(entityName: "Podcast")
  }

  @NSManaged public var artistId: Int
  @NSManaged public var artistName: String?
  @NSManaged public var artistViewUrl: String?
  @NSManaged public var artworkUrl30: String?
  @NSManaged public var artworkUrl60: String?
  @NSManaged public var artworkUrl100: String?
  @NSManaged public var artworkUrl600: String?
  @NSManaged public var collectionCensoredName: String?
  @NSManaged public var collectionExplicitness: String?
  @NSManaged public var collectionHdPrice: Double
  @NSManaged public var collectionId: Int
  @NSManaged public var collectionName: String?
  @NSManaged public var collectionPrice: Double
  @NSManaged public var collectionViewUrl: String?
  @NSManaged public var contentAdvisoryRating: String?
  @NSManaged public var country: String?
  @NSManaged public var currency: String?
  @NSManaged public var feedUrl: String?
//  @NSManaged public var genreIds: NSSet?
//  @NSManaged public var genres: NSSet?
  @NSManaged public var id: UUID?
  @NSManaged public var imageData: Data?
  @NSManaged public var kind: String?
  @NSManaged public var primaryGenreName: String?
  @NSManaged public var releaseDate: String?
  @NSManaged public var trackCensoredName: String?
  @NSManaged public var trackCount: Int
  @NSManaged public var trackExplicitness: String?
  @NSManaged public var trackHdPrice: Double
  @NSManaged public var trackHdRentalPrice: Double
  @NSManaged public var trackId: Int
  @NSManaged public var trackName: String?
  @NSManaged public var trackPrice: Double
  @NSManaged public var trackRentalPrice: Double
  @NSManaged public var trackViewUrl: String?
  @NSManaged public var wrapperType: String?
  @NSManaged public var lastCheckedForNewEpisodes: Date?
//  @NSManaged public var episodes: NSSet?
  
}

// MARK: Generated accessors for episodes
extension Podcast {

  @objc(addEpisodesObject:)
  @NSManaged public func addToEpisodes(_ value: Episode)

  @objc(removeEpisodesObject:)
  @NSManaged public func removeFromEpisodes(_ value: Episode)

  @objc(addEpisodes:)
  @NSManaged public func addToEpisodes(_ values: NSSet)

  @objc(removeEpisodes:)
  @NSManaged public func removeFromEpisodes(_ values: NSSet)

}

extension Podcast: Identifiable {

}


