//
//  PodcastInfoStruct.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation


struct PodcastInfoStruct: Codable, Hashable {
  var rss: String = ""
  var channel: String = ""
  var feedPressLocale: String = ""
  var atoomLink: String = ""
  var image: String = ""
  var mediaCategory: String = ""
  var mediaRating: String = ""
  var mediaDescription: String = ""
  var mediaCredit: String = ""
  var mediaKeywords: String = ""
  var itunesKeywords: String = ""
  var copyright: String = ""
  var title: String = ""
  var description: String = ""
  var pubDate: String = ""
  var link: String = ""
  var url: String = ""
  var itunesSummary: String = ""
  var lastBuildDate: String = ""
  var language: String = ""
  var itunesType: String = ""
  var itunesAuthor: String = ""
  var itunesExplicit: String = ""
  var itunesImage: String = ""
  var itunesNewFeedUrl: String = ""
  var itunesOwner: String = ""
  var itunesName: String = ""
  var itunesEmail: String = ""
  var itunesCategory: String = ""
  var generator: String = ""
  var itunesSubtitle: String = ""
  var contentEncoded: String = ""
}
