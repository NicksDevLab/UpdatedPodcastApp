//
//  XmlParserService.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation
import Network


final class XmlParserService: NSObject {
  
  private var xmlParser: XMLParser!
  private var isEpisode = false
  private var podcastInfo = PodcastInfoStruct()
  private var episode = Episode(entity: Episode.entity(), insertInto: PersistenceController.shared.container.viewContext)
  private var episodes: [Episode] = []
  private var currentElement = ""
  private var foundCharacters = ""
  
  private var episodeCount = 0
  
  private var regex: NSRegularExpression!
  
  typealias parsedXml = (PodcastInfoStruct, [Episode])?
  
  override init() {
    do {
      self.regex = try NSRegularExpression(pattern: "<.*?>", options: .caseInsensitive)
    } catch {
      print(error.localizedDescription)
    }
  }
  
  func startParsing(feedUrl: String, completionHandler: @escaping (parsedXml) -> Void) {
    if let url = URL(string: feedUrl) {
      podcastInfo = PodcastInfoStruct()
      episode = Episode(entity: Episode.entity(), insertInto: PersistenceController.shared.container.viewContext)
      episodes = []
      self.xmlParser = XMLParser(contentsOf: url)
      self.xmlParser.delegate = self
      self.xmlParser.parse()
      completionHandler((podcastInfo, episodes))
      episodeCount = 0
    }
  }
  
}



extension XmlParserService: XMLParserDelegate {
  
  func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
    if elementName == "item" {
      if episodeCount > 100 {
        isEpisode = false
        xmlParser.abortParsing()
      } else {
        isEpisode = true
        episodeCount += 1
      }
    }
    if elementName == "enclosure" {
      if let url = attributeDict["url"] {
        foundCharacters = url
      }
    }
    currentElement = elementName
  }
  
  func parser(_ parser: XMLParser, foundCharacters string: String) {
    
    if currentElement != "enclosure" {
      foundCharacters += string
      
      let range = NSMakeRange(0, foundCharacters.utf16.count)
      foundCharacters = regex.stringByReplacingMatches(in: foundCharacters, range: range, withTemplate: "")
    }
  }
  
  func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
    
    let trimmedString = foundCharacters.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if isEpisode {
      if elementName == "link" || elementName ==  "pubDate" || elementName == "title" || elementName ==  "description" ||
         elementName == "author" || elementName == "itunes:title" || elementName == "itunes:subtitle" ||
         elementName == "itunes:author" || elementName == "itunes:explicit" || elementName == "itunes:summary" ||
         elementName == "itunes:duration" || elementName == "itunes:episodeType" || elementName == "copyright" ||
         elementName == "guid" || elementName == "itunes:image" || elementName == "content:encoded" || elementName == "enclosure" ||
         elementName == "itunes:season" || elementName == "itunes:episode" || elementName == "itunes:keywords" ||
         elementName == "category" {
        episode.updateValue(value: trimmedString, for: elementName)
      }
//      switch currentElement {
//      case "link":
//        episode.link += trimmedString
//      case "pubDate":
//        episode.pubDate += trimmedString
//      case "title":
//        episode.title += trimmedString
//      case "description":
//        episode.episodeDescription += trimmedString
//      case "author":
//        episode.author += trimmedString
//      case "itunes:title":
//        episode.itunesTitle += trimmedString
//      case "itunes:subtitle":
//        episode.itunesSubtitle += trimmedString
//      case "itunes:author":
//        episode.itunesAuthor += trimmedString
//      case "itunes:explicit":
//        episode.itunesExplicit += trimmedString
//      case "itunes:summary":
//        episode.itunesSummary += trimmedString
//      case "itunes:duration":
//        episode.itunesDuration += trimmedString
//      case "itunes:episodeType":
//        episode.itunesEpisodeType += trimmedString
//      case "copyright":
//        episode.copyright += trimmedString
//      case "guid":
//        episode.guid += trimmedString
//      case "itunes:image":
//        episode.guid += trimmedString
//      case "content:encoded":
//        episode.contentEncoded += trimmedString
//      case "enclosure":
//        episode.enclosure += trimmedString
//      case "itunes:season":
//        episode.itunesSeason += trimmedString
//      case "itunes:episode":
//        episode.itunesEpisode += trimmedString
//      case "itunes:keywords":
//        episode.itunesKeywords += trimmedString
//      case "category":
//        episode.category += trimmedString
//      default:
//        print("")
//        print("***** Not Added ********* - \(currentElement) - \(trimmedString)")
//      }
    } else {
      switch currentElement {
      case "rss":
        podcastInfo.rss += trimmedString
      case "channel":
        podcastInfo.channel += trimmedString
      case "feedpress:locale":
        podcastInfo.feedPressLocale += trimmedString
      case "atom:link":
        podcastInfo.atoomLink += trimmedString
      case "media:category":
        podcastInfo.mediaCategory += trimmedString
      case "media:rating":
        podcastInfo.mediaRating += trimmedString
      case "media:description":
        podcastInfo.mediaDescription += trimmedString
      case "media:credit":
        podcastInfo.mediaCredit += trimmedString
      case "media:keywords":
        podcastInfo.mediaKeywords += trimmedString
      case "copyright":
        podcastInfo.copyright += trimmedString
      case "title":
        podcastInfo.title += trimmedString
      case "description":
        podcastInfo.description += trimmedString
      case "pubDate":
        podcastInfo.pubDate += trimmedString
      case "link":
        podcastInfo.link += trimmedString
      case "url":
        podcastInfo.url += trimmedString
      case "itunes:summary":
        podcastInfo.itunesSummary += trimmedString
      case "lastBuildDate":
        podcastInfo.lastBuildDate += trimmedString
      case "language":
        podcastInfo.language += trimmedString
      case "itunes:type":
        podcastInfo.itunesType += trimmedString
      case "itunes:author":
        podcastInfo.itunesAuthor += trimmedString
      case "itunes:explicit":
        podcastInfo.itunesExplicit += trimmedString
      case "itunes:image":
        podcastInfo.itunesImage += trimmedString
      case "itunes:new-feed-url":
        podcastInfo.itunesNewFeedUrl += trimmedString
      case "itunes:owner":
        podcastInfo.itunesOwner += trimmedString
      case "itunes:name":
        podcastInfo.itunesName += trimmedString
      case "itunes:email":
        podcastInfo.itunesEmail += trimmedString
      case "itunes:category":
        podcastInfo.itunesCategory += trimmedString
      case "generator":
        podcastInfo.generator += trimmedString
      case "itunes:subtitle":
        podcastInfo.itunesSubtitle += trimmedString
      case "itunes:keywords":
        podcastInfo.itunesKeywords += trimmedString
      case "content:encoded":
        podcastInfo.contentEncoded += trimmedString
      default:
        print("")
//        print("######## Not Added to PodcastInfo ######## - \(currentElement) - \(trimmedString)")
      }
    }
    
    foundCharacters = ""
    
    if elementName == "item" {
      episodes.append(episode)
      episode = Episode(entity: Episode.entity(), insertInto: PersistenceController.shared.container.viewContext)
      isEpisode = false
    }
  }
  
  func parserDidEndDocument(_ parser: XMLParser) {
    print(podcastInfo)
  }
}
