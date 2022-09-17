//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation
import CoreData

//final class JSONResponse: Decodable {
//  var resultCount: Int
//  var result: Podcast?
//
//  enum CodingKeys: String, CodingKey {
//    case resultCount
//    case result
//  }
//
//  init(from decoder: Decoder) throws {
//    let container = try decoder.container(keyedBy: CodingKeys.self)
//    resultCount = try container.decode(Int.self, forKey: .resultCount)
//    result = try container.decode(Podcast.self, forKey: .result)
//  }
//}

@objc(Podcast)
public final class Podcast: NSManagedObject {
  
//  public init(entity: NSEntityDescription, insertInto: NSManagedObjectContext) {
//    super.init(entity: entity, insertInto: insertInto)
//  }
  
//  public init(from decoder: Decoder) throws {
//    super.init(entity: Podcast.entity(), insertInto: PersistenceController.shared.container.viewContext)
//    self.id                 = UUID()
//    let values              = try decoder.container(keyedBy: CodingKeys.self)
//    artistId                = try values.decode(   Int.self, forKey: .artistId)
//    artistName              = try values.decodeIfPresent(String.self, forKey: .artistName)
//    artistViewUrl           = try values.decodeIfPresent(String.self, forKey: .artistViewUrl)
//    artworkUrl30            = try values.decodeIfPresent(String.self, forKey: .artworkUrl30)
//    artworkUrl60            = try values.decodeIfPresent(String.self, forKey: .artworkUrl60)
//    artworkUrl100           = try values.decodeIfPresent(String.self, forKey: .artworkUrl100)
//    artworkUrl600           = try values.decodeIfPresent(String.self, forKey: .artworkUrl600)
//    collectionCensoredName  = try values.decodeIfPresent(String.self, forKey: .collectionCensoredName)
//    collectionExplicitness  = try values.decodeIfPresent(String.self, forKey: .collectionExplicitness)
//    collectionHdPrice       = try values.decode(Double.self, forKey: .collectionHdPrice)
//    collectionId            = try values.decode(   Int.self, forKey: .collectionId)
//    collectionName          = try values.decodeIfPresent(String.self, forKey: .collectionName)
//    collectionPrice         = try values.decode(Double.self, forKey: .collectionPrice)
//    collectionViewUrl       = try values.decodeIfPresent(String.self, forKey: .collectionViewUrl)
//    contentAdvisoryRating   = try values.decodeIfPresent(String.self, forKey: .contentAdvisoryRating)
//    country                 = try values.decodeIfPresent(String.self, forKey: .country)
//    feedUrl                 = try values.decodeIfPresent(String.self, forKey: .feedUrl)
//    kind                    = try values.decodeIfPresent(String.self, forKey: .kind)
//    primaryGenreName        = try values.decodeIfPresent(String.self, forKey: .primaryGenreName)
//    releaseDate             = try values.decodeIfPresent(String.self, forKey: .releaseDate)
//    trackCensoredName       = try values.decodeIfPresent(String.self, forKey: .trackCensoredName)
//    trackCount              = try values.decode(   Int.self, forKey: .trackCount)
//    trackExplicitness       = try values.decodeIfPresent(String.self, forKey: .trackExplicitness)
//    trackHdPrice            = try values.decode(Double.self, forKey: .trackHdPrice)
//    trackHdRentalPrice      = try values.decode(Double.self, forKey: .trackHdRentalPrice)
//    trackId                 = try values.decode(   Int.self, forKey: .trackId)
//    trackName               = try values.decodeIfPresent(String.self, forKey: .trackName)
//    trackPrice              = try values.decode(Double.self, forKey: .trackPrice)
//    trackRentalPrice        = try values.decode(Double.self, forKey: .trackRentalPrice)
//    trackViewUrl            = try values.decodeIfPresent(String.self, forKey: .trackViewUrl)
//    wrapperType             = try values.decodeIfPresent(String.self, forKey: .wrapperType)
//  }
}


//extension Podcast: Decodable {
//  enum CodingKeys: String, CodingKey {
//    case artistId               = "artistId"
//    case artistName             = "artistName"
//    case artistViewUrl          = "artistViewUrl"
//    case artworkUrl30           = "artworkUrl30"
//    case artworkUrl60           = "artworkUrl60"
//    case artworkUrl100          = "artworkUrl100"
//    case artworkUrl600          = "artworkUrl600"
//    case collectionCensoredName = "collectionCensoredName"
//    case collectionExplicitness = "collectionExplicitness"
//    case collectionHdPrice      = "collectionHdPrice"
//    case collectionId           = "collectionId"
//    case collectionName         = "collectionName"
//    case collectionPrice        = "collectionPrice"
//    case collectionViewUrl      = "collectionViewUrl"
//    case contentAdvisoryRating  = "contentAdvisoryRating"
//    case country                = "country"
//    case currency               = "currency"
//    case feedUrl                = "feedUrl"
//    case kind                   = "kind"
//    case primaryGenreName       = "primaryGenreName"
//    case releaseDate            = "releaseDate"
//    case trackCensoredName      = "trackCensoredName"
//    case trackCount             = "trackCount"
//    case trackExplicitness      = "trackExplicitness"
//    case trackHdPrice           = "trackHdPrice"
//    case trackHdRentalPrice     = "trackHdRentalPrice"
//    case trackId                = "trackId"
//    case trackName              = "trackName"
//    case trackPrice             = "trackPrice"
//    case trackRentalPrice       = "trackRentalPrice"
//    case trackViewUrl           = "trackViewUrl"
//    case wrapperType            = "wrapperType"
////    case genreIds               = "genreIds"
////    case genres                 = "genres"
//  }
//}
