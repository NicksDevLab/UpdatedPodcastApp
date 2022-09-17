//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation
import CoreData


extension SearchItem {
  
  @nonobjc public class func fetchRequest() -> NSFetchRequest<SearchItem> {
    return NSFetchRequest<SearchItem>(entityName: "SearchItem")
  }
  
  @NSManaged public var term: String?
  @NSManaged public var date: Date?
  @NSManaged public var uuid: UUID?
  
  func formatDate() -> String {
    let dateFormatter = DateFormatter()
    if let date = self.date {
      dateFormatter.dateStyle = .medium
      dateFormatter.timeStyle = .none
      dateFormatter.locale = Locale(identifier: "en_US")
      let formattedDate = dateFormatter.string(from: date)
      return formattedDate
    }
    return ""
  }
  
}

extension SearchItem : Identifiable {
//SearchItem must conform to Ientifiable Protocol
//for use with ForEach in SearchHistoryView.
}
