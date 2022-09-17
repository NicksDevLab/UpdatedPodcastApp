//
//  SearchService.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation



final class SearchService: ObservableObject {
  
  static let shared = SearchService()

  
  private let itunesUrl = "https://itunes.apple.com/search"
  
  func getSearchResults(forTerm: String, completion: @escaping ([Podcast]) -> Void) {
    
    var returnedPodcasts: [Podcast] = []
    
    if var urlComponents = URLComponents(string: itunesUrl) {
      
      var allowExplicitContent: String {
        get {
          if UserDefaults().bool(forKey: UserDefaultKeys.isExplicitContentBlocked.rawValue) {
            return "No"
          } else {
            return "Yes"
          }
        }
      }
      
      let podcastQueryItems = [
        URLQueryItem(name: "country", value: "US"),
        URLQueryItem(name: "media", value: "podcast"),
        URLQueryItem(name: "entity", value: "podcast"),
        URLQueryItem(name: "lang", value: "en_us"),
        URLQueryItem(name: "term", value: forTerm),
        URLQueryItem(name: "explicit", value: allowExplicitContent)
      ]
      
      urlComponents.queryItems = podcastQueryItems
      
      guard let url = urlComponents.url else { return }
      
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
          print("Error fetching image jsondata - Error: ", error)
        }
        if let data = data {
          do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as! [String : AnyObject]
            
            if let results = jsonData["results"] as? [[String : Any]] {
              for result in results {
                let podcastResult = Podcast(entity: Podcast.entity(), insertInto: PersistenceController.shared.container.viewContext)
                podcastResult.id = UUID()
                podcastResult.contentAdvisoryRating = result["contentAdvisoryRating"] as? String
                podcastResult.trackName = result["trackName"] as? String
                podcastResult.artworkUrl30 = result["artworkUrl130"] as? String
                podcastResult.collectionId = result["collectionId"] as? Int ?? 0
                podcastResult.collectionHdPrice = result["collectionHdPrice"] as? Double ?? 0
                podcastResult.releaseDate = result["releaseDate"] as? String
                podcastResult.artistName = result["artistName"] as? String
                podcastResult.collectionPrice = result["collectionPrice"] as? Double ?? 0
                podcastResult.trackPrice = result["trackPrice"] as? Double ?? 0
                podcastResult.trackId = result["trackId"] as? Int ?? 0
//                podcastResult.genreIds = result["genreIds"] as? NSSet
                podcastResult.trackRentalPrice = result["trackHdRentalPrice"] as? Double ?? 0
                podcastResult.collectionViewUrl = result["collectionViewUrl"] as? String
                podcastResult.currency = result["currency"] as? String
                podcastResult.trackViewUrl = result["trackViewUrl"] as? String
                podcastResult.artworkUrl60 = result["artworkUrl60"] as? String
                podcastResult.trackExplicitness = result["trackExplicitness"] as? String
                podcastResult.wrapperType = result["wrapperType"] as? String
                podcastResult.collectionCensoredName = result["collectionCensoredName"] as? String
                podcastResult.artworkUrl100 = result["artworkUrl100"] as? String
                podcastResult.trackHdPrice = result["trackHdPrice"] as? Double ?? 0
                podcastResult.artistId = result["artistId"] as? Int ?? 0
                podcastResult.primaryGenreName = result["primaryGenreName"] as? String
                podcastResult.artistViewUrl = result["artistViewUrl"] as? String
                podcastResult.trackCount = result["trackCount"] as? Int ?? 0
                podcastResult.artworkUrl600 = result["artworkUrl600"] as? String
                podcastResult.trackCensoredName = result["trackCensoredname"] as? String
                podcastResult.feedUrl = result["feedUrl"] as? String
                podcastResult.collectionExplicitness = result["collectionExplicitness"] as? String
                podcastResult.collectionName = result["collectionName"] as? String
                podcastResult.country = result["country"] as? String
//                podcastResult.genres = result["genres"] as? NSSet
                podcastResult.trackRentalPrice = result["trackRentalPrice"] as? Double ?? 0
                returnedPodcasts.append(podcastResult)
              }
            }
            DispatchQueue.main.async {
              completion(returnedPodcasts)
            }
          } catch {
            print("Error with JSONDecoder - Error: ", error)
          }
        }
      }.resume()
    }
  }

}
