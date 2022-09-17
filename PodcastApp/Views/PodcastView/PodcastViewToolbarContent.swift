//
//  File.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI

struct PodcastViewToolbarContent: ToolbarContent {
  
  @Binding var mode: PresentationMode
  
  var body: some ToolbarContent {
    ToolbarItemGroup(placement: .navigationBarLeading) {
      Button(action: {
        $mode.wrappedValue.dismiss()
      }) {
        Image(systemName: "chevron.backward.circle.fill")
      }
    }
    ToolbarItemGroup(placement: .navigationBarTrailing) {
      Menu(content: {
        Text("Item 1")
        Text("Item 2")
      }) {
        Label(LocalizedStringKey("Menu"), systemImage: "ellipsis.circle.fill")
      }
    }
  }
}
