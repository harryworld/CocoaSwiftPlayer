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
    
    let manager = PlayerManager.sharedManager
    
    var songTimer: NSTimer?
    var songProgress: Double = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeSong:", name: Constants.Notifications.ChangeSong, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "startPlaying:", name: Constants.Notifications.StartPlaying, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "pausePlaying:", name: Constants.Notifications.PausePlaying, object: nil)
    }
    
    // MARK: - IBAction
    
    @IBAction func play(sender: NSButton) {
        manager.play()
    }
    
    @IBAction func rewind(sender: NSButton) {
        manager.rewind()
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
        timeLabel.stringValue = "0:00"
        songProgress = 0
        songTimer?.invalidate()
        songTimer = nil
    }
    
    func startPlaying(notification: NSNotification) {
        songTimer = NSTimer.scheduledTimerWithTimeInterval(1.0, target: self, selector: "updateProgress", userInfo: nil, repeats: true)
    }
    
    func pausePlaying(notification: NSNotification) {
        songTimer?.invalidate()
        songTimer = nil
    }
    
    // MARK: - Timer
    
    func updateProgress() {
        songProgress++
        let formatter = NSDateComponentsFormatter()
        formatter.allowedUnits = [.Minute, .Second]
        formatter.zeroFormattingBehavior = .Pad
        timeLabel.stringValue = "\(formatter.stringFromTimeInterval(songProgress)!)"
    }
    
}
