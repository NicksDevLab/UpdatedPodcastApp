//
//  SearchCellViewModel.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/11/22.
//

import Foundation


final class SearchCellViewModel: ObservableObject {
  
  @Published var imageData: Data = Data()
  private let imageRetreiver = ImageRetrieverService.shared
  
  func getImageData(from urlString: String) {
    imageRetreiver.getImage(imageUrl: urlString) { [weak self] retrievedImageData in
      self?.imageData = retrievedImageData
    }
  }
}
