//
//  PlayerViewController.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 3/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class PlayerViewController: NSViewController {

    @IBOutlet weak var playButton: NSButton!
    
    @IBOutlet weak var rewindButton: NSButton!
    
    @IBOutlet weak var nextButton: NSButton!
    
    @IBOutlet weak var volumeSlider: NSSlider!
    
    @IBOutlet weak var timeLabel: NSTextField!
    
    @IBOutlet weak var shuffleButton: NSButton!
    
    @IBOutlet weak var repeatButton: NSButton!
    
    @IBOutlet weak var songTitleLabel: NSTextField!
    
    let manager = PlayerManager.sharedManager
    
    var songTimer: NSTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeSong:", name: Constants.Notifications.ChangeSong, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "volumeChanged:", name: Constants.Notifications.VolumeChanged, object: nil)
        
        songTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
    }
    
    // MARK: - IBAction
    
    @IBAction func play(sender: NSButton) {
        manager.play()
    }
    
    @IBAction func rewind(sender: NSButton) {
        manager.rewind()
    }
    
    @IBAction func slideVolume(sender: NSSlider) {
        manager.volume = sender.floatValue
    }
    
    @IBAction func next(sender: NSButton) {
        manager.next()
    }
    
    @IBAction func shuffle(sender: NSButton) {
        manager.isShuffle = !manager.isShuffle
    }
    
    @IBAction func repeatPlaylist(sender: NSButton) {
        manager.isRepeated = !manager.isRepeated
        
    }
    
    // MARK: - Helpers
    
    func changeSong(notification: NSNotification) {
        guard let song = notification.userInfo?[Constants.NotificationUserInfos.Song] as? Song else { return }
        
        timeLabel.stringValue = "0:00"
        
        songTitleLabel.stringValue = song.title
    }
    
    func volumeChanged(notification: NSNotification) {
        volumeSlider.floatValue = manager.volume
    }

    func updateProgress() {
        timeLabel.stringValue = manager.songProgressText
    }
    
}
