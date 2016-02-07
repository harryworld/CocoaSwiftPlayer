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
            } else {
                stop()
                player = nil
            }
        }
    }
    var currentPlayList: [Song] = []
    
    var isRepeated = false
    var isShuffle = false
    var volume: Float = 0.5
    
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
    }
    
    func pause() {
        player?.pause()
    }
    
    func stop() {
        player?.stop()
    }
    
    func next() {
        guard let currentIndex = currentIndex else { return }
        
        if currentIndex == currentPlayList.count - 1 {
            currentSong = nil
        } else {
            currentSong = currentPlayList[currentIndex + 1]
            play()
        }
    }
    
    func rewind() {
        guard let currentIndex = currentIndex else { return }
        
        if currentIndex == 0 {
            currentSong = nil
        } else {
            currentSong = currentPlayList[currentIndex - 1]
            play()
        }
    }
    
    func shuffle() {
        
    }
    
    func repeatPlaylist() {
        
    }
    
    private func loadAllSongs() {
        let realm = try! Realm()
        currentPlayList = realm.objects(Song).map { song in return song}
    }

}
