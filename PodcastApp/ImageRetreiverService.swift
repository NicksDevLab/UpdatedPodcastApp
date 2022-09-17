//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import Foundation


final class ImageRetrieverService: ObservableObject {
  
  static let shared = ImageRetrieverService()
  
  private init() {}
  
  func getImage(imageUrl: String, completion: @escaping (Data) -> ()) {
    
    guard let url = URL(string: imageUrl) else { return }
    
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Error fetching image data - Error: ", error)
      }
      DispatchQueue.main.async {
        completion(data ?? Data())
      }
    }.resume()
  }
  
}



