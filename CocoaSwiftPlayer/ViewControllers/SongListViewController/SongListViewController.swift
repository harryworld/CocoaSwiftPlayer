//
//  SongListViewController.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 5/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa
import RealmSwift

class SongListViewController: NSViewController {
    
    dynamic var songs: [Song] = []

    @IBOutlet weak var tableView: NSTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        RealmMigrationManager.migrate()
        
        let defaults = NSUserDefaults.standardUserDefaults()
        if !defaults.boolForKey("APP_LAUNCHED") {
            let songManager = SongManager()
            try! songManager.importSongs()
            defaults.setBool(true, forKey: "APP_LAUNCHED")
        }
        
        let realm = try! Realm()
        let result = realm.objects(Song)
        songs = result.map { song in
            return song
        }
        
        tableView.doubleAction = "doubleClick:"
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeSong:", name: Constants.Notifications.ChangeSong, object: nil)
    }
    
    func doubleClick(sender: NSTableView) {
        let manager = PlayerManager.sharedManager
        if tableView.selectedRow != -1 {
            manager.currentPlayList = songs
            manager.currentSong = songs[tableView.selectedRow]
        }
        manager.play()
    }
    
    // MARK: - Notification
    
    func changeSong(notification: NSNotification) {
        guard let song = notification.userInfo?[Constants.NotificationUserInfos.Song] as? Song else { return }
        
        let index = songs.indexOf { s in
            return s.location == song.location
        }
        
        if let index = index {
            tableView.selectRowIndexes(NSIndexSet(index: index), byExtendingSelection: false)
            tableView.scrollRowToVisible(index)
        }
    }
    
}
