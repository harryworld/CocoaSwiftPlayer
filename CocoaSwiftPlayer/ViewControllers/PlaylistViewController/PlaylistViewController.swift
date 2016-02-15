//
//  PlaylistViewController.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 12/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa
import RealmSwift

class PlaylistViewController: NSViewController {
    
    var playlists = [Playlist]() {
        didSet {
            outlineView.reloadData()
            outlineView.expandItem(nil, expandChildren: true)
        }
    }

    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        outlineView.setDataSource(self)
        outlineView.setDelegate(self)
        
        RealmMigrationManager.migrate()
        
        let realm = try! Realm()
        playlists = realm.objects(Playlist).map { playlist in return playlist }
        
        outlineView.registerForDraggedTypes([NSPasteboardTypeString])
    }
    
    @IBAction func addPlaylist(sender: AnyObject) {
        let playlist = Playlist()
        let realm = try! Realm()
        try! realm.write {
            realm.add(playlist)
        }
        
        playlists.append(playlist)
    }
    
    // MARK: - Helper
    
    func isHeader(item: AnyObject) -> Bool {
        return item is String
    }
    
}

extension PlaylistViewController: NSOutlineViewDataSource {
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return 1
        } else {
            return playlists.count
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return isHeader(item)
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return "Library"
        } else {
            return playlists[index]
        }
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return item
    }
    
    func outlineView(outlineView: NSOutlineView, validateDrop info: NSDraggingInfo, proposedItem item: AnyObject?, proposedChildIndex index: Int) -> NSDragOperation {
        
        let canDrag = item is Playlist && index < 0
        
        if canDrag {
            return .Move
        } else {
            return .None
        }
    }
    
    func outlineView(outlineView: NSOutlineView, acceptDrop info: NSDraggingInfo, item: AnyObject?, childIndex index: Int) -> Bool {
        guard let playlist = item as? Playlist else { return false }
        
        let pb = info.draggingPasteboard()
        let location = pb.stringForType(NSPasteboardTypeString)
        
        let realm = try! Realm()
        if let location = location {
            if let song = realm.objects(Song).filter("location = '\(location)'").first {
                let index = playlist.songs.indexOf { s in
                    return s.location == song.location
                }
                if index == nil {
                    try! realm.write {
                        playlist.songs.append(song)
                    }
                    outlineView.reloadData()
                }
            }
            return true
        }
        
        return false
    }
    
}

extension PlaylistViewController: NSOutlineViewDelegate {
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        if isHeader(item) {
            return outlineView.makeViewWithIdentifier("HeaderCell", owner: self)
        } else {
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as? NSTableCellView
            if let playlist = item as? Playlist {
                view?.textField?.stringValue = "\(playlist.name) (\(playlist.songs.count))"
            }
            return view
        }
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        return !isHeader(item)
    }
    
    func outlineView(outlineView: NSOutlineView, shouldShowOutlineCellForItem item: AnyObject) -> Bool {
        return false
    }
    
    func outlineViewSelectionDidChange(notification: NSNotification) {
        let playlist = playlists[outlineView.selectedRow - 1]
        
        NSNotificationCenter.defaultCenter().postNotificationName(Constants.Notifications.SwitchPlaylist, object: self, userInfo: [Constants.NotificationUserInfos.Playlist: playlist])
    }
    
}
