//
//  Song.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 31/1/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa
import iTunesLibrary
import RealmSwift

class Song: Object {

    dynamic var title: String = ""
    dynamic var location: String = ""
    dynamic var length: Double = 0.0
    
    convenience init(item: ITLibMediaItem) {
        self.init()
        self.title = item.title
        self.location = item.location.path ?? ""
        self.length = NSTimeInterval(item.totalTime) / 1000.0
    }
    
}
