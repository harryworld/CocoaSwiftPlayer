//
//  Playlist.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 13/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa
import RealmSwift

class Playlist: Object {
    
    dynamic var name: String = "Playlist"
    let songs = List<Song>()
    
    func delete() {
        try! realm?.write {
            realm?.delete(self)
        }
    }

}
