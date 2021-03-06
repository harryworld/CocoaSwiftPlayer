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
        print("SongListViewController viewDidLoad")
        
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
        
        tableView.setDataSource(self)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Delete", action: "deleteSongs:", keyEquivalent: ""))
        tableView.menu = menu
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "changeSong:", name: Constants.Notifications.ChangeSong, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "switchPlaylist:", name: Constants.Notifications.SwitchPlaylist, object: nil)
    }
    
    func doubleClick(sender: NSTableView) {
        let manager = PlayerManager.sharedManager
        if tableView.selectedRow != -1 {
            manager.currentPlayList = songs
            manager.currentSong = songs[tableView.selectedRow]
        }
        manager.play()
    }
    
    func deleteSongs(sender: AnyObject) {
        let songsMutableArray = NSMutableArray(array: songs)
        let toBeDeletedSongs = songsMutableArray.objectsAtIndexes(tableView.selectedRowIndexes) as? [Song]
        songsMutableArray.removeObjectsAtIndexes(tableView.selectedRowIndexes)
        
        if let mutableArray = songsMutableArray as AnyObject as? [Song] {
            songs = mutableArray
            tableView.reloadData()
        }
        
        if let songs = toBeDeletedSongs {
            for song in songs {
                song.delete()
            }
        }
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
    
    func switchPlaylist(notification: NSNotification) {
        guard let playlist = notification.userInfo?[Constants.NotificationUserInfos.Playlist] as? Playlist else { return }
        
        songs = playlist.songs.map { song in return song }
        tableView.reloadData()
    }
    
}

extension SongListViewController: NSTableViewDataSource {
    
    func tableView(tableView: NSTableView, pasteboardWriterForRow row: Int) -> NSPasteboardWriting? {
        let song = songs[row]
        
        let pbItem = NSPasteboardItem()
        pbItem.setString(song.location, forType: NSPasteboardTypeString)
        return pbItem
    }
    
}
