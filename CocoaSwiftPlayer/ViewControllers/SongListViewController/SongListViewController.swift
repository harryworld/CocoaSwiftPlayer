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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let realm = try! Realm()
        let result = realm.objects(Song)
        songs = result.map { song in
            return song
        }
    }
    
}
