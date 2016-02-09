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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    // MARK: - IBAction
    
    @IBAction func play(sender: NSButton) {
        timeLabel.stringValue = "1:00"
        
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
    
}
