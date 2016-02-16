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
    
    static let formatter = NSDateComponentsFormatter()

    dynamic var title: String = ""
    dynamic var location: String = ""
    dynamic var length: Double = 0.0
    dynamic var artist: String = ""
    dynamic var playCount: Int = 0
    
    dynamic var lengthText: String {
        get {
            return Song.formatter.stringFromTimeInterval(length)!
        }
    }
    
    convenience init(item: ITLibMediaItem) {
        self.init()
        self.title = item.title
        if item.artist.name != nil {
            self.artist = item.artist.name
        }
        self.location = item.location.path ?? ""
        self.length = NSTimeInterval(item.totalTime) / 1000.0
    }
    
    override static func ignoredProperties() -> [String] {
        return ["lengthText"]
    }
    
    func delete() {
        try! realm?.write {
            realm?.delete(self)
        }
    }
    
}
