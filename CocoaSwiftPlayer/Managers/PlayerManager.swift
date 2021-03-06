//
//  PlayerManager.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 3/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa
import AVFoundation
import RealmSwift

class PlayerManager: NSObject, AVAudioPlayerDelegate {
    
    static var sharedManager = PlayerManager()
    
    var statusItem: NSStatusItem?
    
    var isPlaying: Bool {
        if let player = player {
            return player.playing
        } else {
            return false
        }
    }
    
    var player: AVAudioPlayer?
    
    var currentIndex: Int?
    var currentSong: Song? = nil {
        didSet {
            if let currentSong = currentSong {
                currentIndex = currentPlayList.indexOf({ song -> Bool in
                    return song.location == currentSong.location
                })
                
                if currentSong.location != player?.url?.path {
                    player = try? AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: currentSong.location))
                    player?.volume = volume
                }
                
                songTimer = nil
                songProgress = 0
                
                NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.ChangeSong, object: self, userInfo: [Constants.NotificationUserInfos.Song: currentSong])
            } else {
                stop()
                player = nil
            }
        }
    }
    // The currently using list
    var currentPlayList: [Song] = []
    // Made of default playlist
    var shufflePlayList: [Song] = []
    // Default Playlist
    var playList: [Song] = [] {
        didSet {
            if !isShuffle {
                currentPlayList = playList
            }
        }
    }
    
    var isRepeated = false {
        didSet {
            print("isRepeat: \(isRepeated)")
        }
    }
    var isShuffle = false {
        didSet {
            print("isShuffle: \(isShuffle)")
            if isShuffle {
                if let currentSong = currentSong {
                    let list = playList.filter { song -> Bool in
                        return song.location != currentSong.location
                    }
                    shufflePlayList = [currentSong] + list.shuffle()
                } else {
                    shufflePlayList = playList.shuffle()
                }
                currentPlayList = shufflePlayList
            } else {
                currentPlayList = playList
            }
        }
    }
    var volume: Float = 0.5 {
        didSet {
            player?.volume = volume
            
            NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.VolumeChanged, object: self)
        }
    }
    
    var songTimer: NSTimer? {
        didSet {
            oldValue?.invalidate()
        }
    }
    var songProgress: Double = 0
    var songProgressText: String {
        get {
            return "\(timeFormatter.stringFromTimeInterval(songProgress)!)"
        }
    }
    lazy var timeFormatter: NSDateComponentsFormatter = {
        let formatter = NSDateComponentsFormatter()
        formatter.allowedUnits = [.Minute, .Second]
        formatter.zeroFormattingBehavior = .Pad
        return formatter
    }()
    
    // MARK: - Lifecycle Methods
    
    override init() {
        super.init()
    }
    
    deinit {
        
    }
    
    // MARK: - Player Control
    
    func play() {
        if isPlaying {
            pause()
            return
        }
        
        if currentPlayList.isEmpty {
            loadAllSongs()
        }
        
        if currentSong == nil {
            currentSong = currentPlayList[0]
        }
        
        player?.play()
        
        songTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.StartPlaying, object: self, userInfo: [Constants.NotificationUserInfos.Song: currentSong!])
    }
    
    func pause() {
        player?.pause()
        
        songTimer = nil
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.PausePlaying, object: self, userInfo: [Constants.NotificationUserInfos.Song: currentSong!])
    }
    
    func stop() {
        player?.stop()
    }
    
    func next() {
        guard let currentIndex = currentIndex else { return }
        
        if !isRepeated && currentIndex == currentPlayList.count - 1 {
            currentSong = nil
        } else if isRepeated && currentIndex == currentPlayList.count - 1 {
            currentSong = currentPlayList.first
            play()
        } else {
            currentSong = currentPlayList[currentIndex + 1]
            play()
        }
    }
    
    func rewind() {
        guard let currentIndex = currentIndex else { return }
        
        if !isRepeated && currentIndex == 0 {
            currentSong = nil
        } else if isRepeated && currentIndex == 0 {
            currentSong = currentPlayList.last
            play()
        } else {
            currentSong = currentPlayList[currentIndex - 1]
            play()
        }
    }
    
    private func loadAllSongs() {
        let realm = try! Realm()
        playList = realm.objects(Song).map { song in return song}
    }
    
    // MARK: - NSTimer
    
    func updateProgress() {
        songProgress++
        statusItem?.button?.title = songProgressText
    }

}
