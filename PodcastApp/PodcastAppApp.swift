//
//  PodcastAppApp.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import SwiftUI
import AVFAudio

enum UserDefaultKeys: String {
  case isExplicitContentBlocked
  case playbackRate
}

final class AudioSession: AVAudioSession, ObservableObject {
  static let shared = AudioSession()
  private override init() {}
}


@main
struct PodcastAppApp: App {
  
  @AppStorage("Appearance") var appearanceSetting: Appearance = .system
  private let persistenceController = PersistenceController.shared
  private let audioSession = AudioSession.shared
  private let audioPlayer = AudioPlayer.shared
  private let tabController = TabController()
//  private let backgroundTask = BackgroundUpdate()
  
  
  init() {
    do {
      try audioSession.setCategory(.playback, mode: .default, options: [])
    } catch {
      print("Error setting audioSession category - Error: ", error)
    }
//    backgroundTask.checkForNewEpisodes()
  }
  
  
  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(\.managedObjectContext, persistenceController.container.viewContext)
        .environmentObject(audioSession)
        .environmentObject(audioPlayer)
        .environmentObject(tabController)
        .preferredColorScheme((appearanceSetting == .system && UITraitCollection.current.userInterfaceStyle == .light) ||
                              appearanceSetting == .light ? .light : .dark)
      
      //Check if the user changed system appearance settings while the app was open in the background.
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
          if appearanceSetting == .system {
            appearanceSetting = UITraitCollection.current.userInterfaceStyle == .light ? .light : .dark
          }
        }
    }
  }
}
