//
//  AudioPlayer.swift
//  PodcastApp
//
//  Created by Nicholas Church on 9/5/22.
//

import AVKit
import MediaPlayer
import Network
import CoreData


enum SeekDirection: Double {
  case forwardBy30Seconds = 30
  case backwardBy15Seconds = 15
}

enum PlayerState {
  case playing
  case paused
  case notPlaying
}


final class AudioPlayer: ObservableObject {
  
  static var shared = AudioPlayer()
  
  @Published var currentProgress: Double = 0
  @Published var state: PlayerState = .notPlaying
  @Published var imageData = Data()
  @Published var currentUrlString = ""
  
  private var player = AVPlayer()
  private var playerObserver: Any?
  
  var episode = Episode(entity: Episode.entity(), insertInto: PersistenceController.shared.container.viewContext)
  
  var rate: Float {
    player.rate
  }
  
  private init() {
    setupLockScreenControls()
  }
  
  fileprivate func setupLockScreenControls() {
    UIApplication.shared.beginReceivingRemoteControlEvents()
    let commandCenter = MPRemoteCommandCenter.shared()
    
    commandCenter.pauseCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
      self?.pause()
      return .success
    }
    
    commandCenter.playCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
      self?.play()
      return .success
    }
    
    commandCenter.seekBackwardCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
      self?.seekByIncrement(direction: .backwardBy15Seconds)
      return .success
    }
    
    commandCenter.seekForwardCommand.addTarget { [weak self] (event) -> MPRemoteCommandHandlerStatus in
      self?.seekByIncrement(direction: .forwardBy30Seconds)
      return .success
    }
    
    commandCenter.playCommand.isEnabled = true
    commandCenter.pauseCommand.isEnabled = true
    commandCenter.seekForwardCommand.isEnabled = true
    commandCenter.seekBackwardCommand.isEnabled = true
  }
  
  func continuePreviouslyPlayedEpisode(episode: Episode) {
    updatePlayerState(episodeUrl: episode.enclosure ?? "")
    player.seek(to: CMTime(seconds: episode.lastPlayedLocation,
                           preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    if let data = episode.imageData {
      self.imageData = data
    }
  }
  
  
  func playPause(episode: Episode?, imageData: Data?, saveToPlayHistory: Bool) {
    
    if let episode = episode {
      self.episode = episode
    }
    
    updatePlayerState(episodeUrl: episode?.enclosure ?? "")
    
    if saveToPlayHistory {
      if let imageData = imageData {
        self.imageData = imageData
      }
      saveEpisodeToPlayHistory(episode: episode, imageData: imageData)
    }
  }
  
  
  private func updatePlayerState(episodeUrl: String) {
    if episodeUrl != currentUrlString && episodeUrl != "" {
      pause()
      state = .notPlaying
    }
    
    switch state {
    case .playing:
      pause()
    case .paused:
      play()
    case .notPlaying:
      setupPlayer(urlString: episodeUrl)
      setAudioSessionToActive()
      play()
    }
  }
  
  
  private func play() {
    let rate =  UserDefaults.standard.float(forKey: UserDefaultKeys.playbackRate.rawValue)
    player.rate = rate == 0 ? 1.0 : rate
    player.play()
    state = .playing
  }
  
  
  private func pause() {
    player.pause()
    do {
      let requestResults = try PersistenceController.shared.container.viewContext.fetch(Episode.fetchRequest())
      for each in requestResults {
        if each.enclosure == currentUrlString {
          each.lastPlayedLocation = currentProgress
          PersistenceController.shared.saveContext()
        }
      }
    } catch {
      print("Error fetching Episode in AudioPlayer - Error: ", error)
    }
    state = .paused
  }
  
  
  private func setupPlayer(urlString: String) {
    if let url = URL(string: urlString) {
      let item = AVPlayerItem(url: url)
      player.replaceCurrentItem(with: item)
      let time = CMTime(seconds: 1, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
      playerObserver = player.addPeriodicTimeObserver(forInterval: time, queue: .main) { [weak self] time in
        guard let self = self else { return }
        self.currentProgress = time.seconds
      }
      currentUrlString = urlString
    }
  }
  

  private func setAudioSessionToActive() {
    do {
      try AudioSession.shared.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("Error setting AudioSession to active - Error: ", error)
    }
  }
  
  
  private func saveEpisodeToPlayHistory(episode: Episode?, imageData: Data?) {
    let context = PersistenceController.shared.container.viewContext
    let item = NSEntityDescription.insertNewObject(forEntityName: "Episode", into: context) as! Episode
    
    if let episode = episode {
      item.imageData = imageData
      item.enclosure = episode.enclosure
      item.author = episode.author
      item.category = episode.category
      item.contentEncoded = episode.contentEncoded
      item.copyright = episode.copyright
      item.episodeDescription = episode.episodeDescription
      item.episodeLegnth = episode.episodeLegnth
      item.episodeType = episode.episodeType
      item.episodeUrl = episode.episodeUrl
      item.guid = episode.guid
      item.itunesImage = episode.itunesImage
      item.itunesTitle = episode.itunesTitle
      item.itunesAuthor = episode.itunesAuthor
      item.itunesSeason = episode.itunesSeason
      item.itunesEpisode = episode.itunesEpisode
      item.itunesSummary = episode.itunesSummary
      item.itunesDuration = episode.itunesDuration
      item.itunesExplicit = episode.itunesExplicit
      item.itunesKeywords = episode.itunesKeywords
      item.itunesSubtitle = episode.itunesSubtitle
      item.itunesEpisodeType = episode.itunesEpisodeType
      item.link = episode.link
      item.pubDate = episode.pubDate
      item.title = episode.title
      item.lastPlayedLocation = currentProgress
      item.dateTimePlayed = Date()
      
      PersistenceController.shared.saveContext()
    }
  }
  
  
  func setPlaybackSpeed(rate: Float) {
    player.rate = rate
    UserDefaults.standard.set(rate, forKey: UserDefaultKeys.playbackRate.rawValue)
  }
  
  
  private func formatTimeString(time: Double) -> String {
    
    let formatter = DateComponentsFormatter()
    formatter.unitsStyle = .positional
    formatter.zeroFormattingBehavior = .dropLeading
    formatter.allowedUnits = [.hour, .minute, .second]
    
    return formatter.string(from: Double(time)) ?? ""
  }
  
  
  func getElapsedTime() -> String {
    return formatTimeString(time: currentProgress)
  }
  
  
  func getTimeRemaining(duration: Double) -> String {
    return formatTimeString(time: duration - currentProgress)
  }
  
  
  func didSliderChange(_ didChange: Bool) {
    if didChange {
      player.pause()
    } else {
      player.seek(to: CMTime(seconds: currentProgress, preferredTimescale: 1))
      player.play()
    }
  }
  
  
  func seekByIncrement(direction: SeekDirection) {
    switch direction {
    case .forwardBy30Seconds:
      player.seek(to: CMTime(seconds: currentProgress + direction.rawValue,
                             preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    case .backwardBy15Seconds:
      player.seek(to: CMTime(seconds: currentProgress - direction.rawValue,
                             preferredTimescale: CMTimeScale(NSEC_PER_SEC)))
    }
  }

}
