//
//  SongManager.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 4/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Foundation
import iTunesLibrary
import RealmSwift

final class SongManager {
    
    func importSongs() throws -> [Song]? {
        
        do {
            let realm = try Realm()
            
            let library = try ITLibrary(APIVersion: "1.0")
            let allItems = library.allMediaItems as! [ITLibMediaItem]
            let songs = allItems.filter({ item -> Bool in
                return item.mediaKind == UInt(ITLibMediaItemMediaKindSong)
                    && item.location != nil
                    && item.locationType == UInt(ITLibMediaItemLocationTypeFile)
            }).map { item -> Song in
                return Song(item: item)
            }
            
            try realm.write {
                realm.add(songs)
            }
            
            return songs
        } catch let error as NSError {
            print("error loading iTunesLibrary")
            throw error
        }
    }
    
}