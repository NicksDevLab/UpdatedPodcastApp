//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation
import CoreData


extension Episode {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Episode> {
        return NSFetchRequest<Episode>(entityName: "Episode")
    }

    @NSManaged public var author: String?
    @NSManaged public var category: String?
    @NSManaged public var contentEncoded: String?
    @NSManaged public var copyright: String?
    @NSManaged public var dateTimePlayed: Date?
    @NSManaged public var enclosure: String?
    @NSManaged public var episodeDescription: String?
    @NSManaged public var episodeLegnth: String?
    @NSManaged public var episodeType: String?
    @NSManaged public var episodeUrl: String?
    @NSManaged public var guid: String?
    @NSManaged public var imageData: Data?
    @NSManaged public var itunesAuthor: String?
    @NSManaged public var itunesDuration: String?
    @NSManaged public var itunesEpisode: String?
    @NSManaged public var itunesEpisodeType: String?
    @NSManaged public var itunesExplicit: String?
    @NSManaged public var itunesImage: String?
    @NSManaged public var itunesKeywords: String?
    @NSManaged public var itunesSeason: String?
    @NSManaged public var itunesSubtitle: String?
    @NSManaged public var itunesSummary: String?
    @NSManaged public var itunesTitle: String?
    @NSManaged public var lastPlayedLocation: Double
    @NSManaged public var link: String?
    @NSManaged public var mediaPlayer: String?
    @NSManaged public var pubDate: String?
    @NSManaged public var title: String?
    @NSManaged public var hasBeenViewed: NSNumber?
    @NSManaged public var hasBeenPlayed: NSNumber?
    @NSManaged public var podcast: Podcast?

}

extension Episode : Identifiable {

}

extension Episode {
  
  func updateValue(value: String, for property: String) {
    var actualPropertyName = property
    if actualPropertyName.contains(":") {
      let indexOfLetterToCapitalize = actualPropertyName.index(after: actualPropertyName.firstIndex(of: ":")!)
      let capitalizedCharacter = actualPropertyName[indexOfLetterToCapitalize].uppercased()
      actualPropertyName.replaceSubrange(indexOfLetterToCapitalize...indexOfLetterToCapitalize, with: capitalizedCharacter)
      actualPropertyName.remove(at: actualPropertyName.firstIndex(of: ":")!)
    }
    if actualPropertyName == "description" {
      if self.value(forKey: "episodeDescription") == nil {
        self.setValue(value, forKey: "episodeDescription")
      } else {
        let previousValue = self.value(forKey: "episodeDescription") as! String
        self.setValue(previousValue+value, forKey: "episodeDescription")
      }
    } else {
      if let oldValue = self.value(forKey: actualPropertyName) as? String {
        self.setValue(oldValue+value, forKey: actualPropertyName)
      } else {
        self.setValue(value, forKey: actualPropertyName)
      }
    }
  }
  
  var formattedPubDate: String {
    get {
      let dateFormatter = DateFormatter()
      dateFormatter.locale = Locale(identifier: "en_US_POSIX")
      dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss Z"
      if let date = dateFormatter.date(from: self.pubDate ?? "") {
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy"
        let string = dateFormatter.string(from: date)
        return string
      }
      return ""
    }
  }
  
  var formattedDuration: String {
    
    guard let duration = self.itunesDuration else { return "" }
    
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .abbreviated
    formatter.zeroFormattingBehavior = .dropAll
    formatter.allowedUnits = [.hour, .minute]
    
    let components = duration.split(separator: ":", maxSplits: 3, omittingEmptySubsequences: false)
    
    if components.count == 1 {
      return formatter.string(from: Double(duration) ?? 0.0) ?? ""
    } else if components.count == 2 {
      let components = DateComponents(minute: Int(components[0]), second: Int(components[1]))
      return formatter.string(from: components)!
    } else if components.count == 3 {
      let components = DateComponents(hour: Int(components[0]), minute: Int(components[1]), second: Int(components[2]))
      return formatter.string(from: components)!
    } else {
      return ""
    }
    
  }
  
  var episodeDurationAsDouble: Double {
    
    if let components = self.itunesDuration?.split(separator: ":", maxSplits: 3, omittingEmptySubsequences: false) {
    
      if components.count == 1 {
        return Double(self.itunesDuration ?? "0") ?? 0
      } else if components.count == 2 {
        let components = DateComponents(minute: Int(components[0]), second: Int(components[1]))
        let seconds = Double(components.second ?? 0)
        let minutesToSeconds = Double(components.minute ?? 0) * 60
        return seconds + minutesToSeconds
      } else if components.count == 3 {
        let components = DateComponents(hour: Int(components[0]), minute: Int(components[1]), second: Int(components[2]))
        let seconds = Double(components.second ?? 0)
        let minutesToSeconds = Double(components.minute ?? 0) * 60
        let hoursToSecondds = Double(components.hour ?? 0) * 60 * 60
        return seconds + minutesToSeconds + hoursToSecondds
      }
    }
    return 0
  }
}
