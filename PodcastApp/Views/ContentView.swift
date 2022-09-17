//
//  ContentView.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI
import CoreData


enum Appearance: String {
  case system, light, dark
}

enum Tab {
  case settings
  case home
  case search
}

final class TabController: ObservableObject {
  @Published var currentTab: Tab = .home
}

struct ContentView: View {
  
  @EnvironmentObject var tabController: TabController
  @EnvironmentObject var audioPlayer: AudioPlayer
  
  let tabIconSize: CGFloat = 30

  var body: some View {
    
    VStack(spacing: 0) {
      
      switch tabController.currentTab {
      case .settings:
        Text("Settings")
      case .home:
        Text("Home")
      case .search:
        SearchView()
      }
      if audioPlayer.state == .playing || audioPlayer.state == .paused {
        AudioPlayerView()
      }
      HStack {
        Spacer()
        TabBarIcon(width: tabIconSize, height: tabIconSize, systemIconName: "gear", tabName: "Settings", tab: .settings)
        Spacer()
        TabBarIcon(width: tabIconSize, height: tabIconSize, systemIconName: "house", tabName: "Home", tab: .home)
        Spacer()
        TabBarIcon(width: tabIconSize, height: tabIconSize, systemIconName: "magnifyingglass", tabName: "Search", tab: .search)
        Spacer()
      }
      .frame(minWidth: 0, maxWidth: .infinity, minHeight: 75, maxHeight: 75, alignment: .center)
    }
  }
}



struct TabBarIcon: View {
  
  @EnvironmentObject var tabController: TabController
  
  let width, height: CGFloat
  let systemIconName, tabName: String
  let tab: Tab
  
  
  var body: some View {
    VStack {
      Image(systemName: systemIconName)
        .resizable()
        .frame(width: width, height: height)
      Text(tabName)
        .font(.footnote)
    }
    .foregroundColor(tabController.currentTab == tab ? Color.green : Color.gray)
    .onTapGesture {
      tabController.currentTab = tab
    }
  }
}
