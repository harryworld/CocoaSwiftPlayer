//
//  AppDelegate.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 30/1/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {



    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        let songManager = SongManager()
        try! songManager.importSongs()
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }


}

