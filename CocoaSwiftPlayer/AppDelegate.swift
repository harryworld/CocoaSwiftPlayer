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
    
    var windowController: MainWindowController?

    let popover = NSPopover()
    let statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    var eventMonitor: EventMonitor?

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        // Insert code here to initialize your application
        
        print("AppDelegate")
        
        RealmMigrationManager.migrate()
        
        PlayerManager.sharedManager.statusItem = statusItem
        
        if let button = statusItem.button {
            button.imagePosition = .ImageLeft
            button.image = NSImage(named: "Star")
            button.action = Selector("togglePopover:")
        }
        
        popover.contentViewController = StatusItemViewController.loadFromNib()
        
        eventMonitor = EventMonitor(mask: [.LeftMouseDownMask, .RightMouseDownMask], handler: { (event) -> () in
            if self.popover.shown {
                self.closePopover(event)
            }
        })
        
        // Load Window Controller
        let storyboard = NSStoryboard(name: "Main", bundle: nil)
        windowController = storyboard.instantiateControllerWithIdentifier("MainWindowController") as? MainWindowController
        windowController?.showWindow(self)
    }

    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

    // ===============
    // MARK: - Helpers
    // ===============
    
    func showPopover(sender: AnyObject?) {
        if let button = statusItem.button {
            popover.showRelativeToRect(button.bounds, ofView: button, preferredEdge: .MinY)
        }
        eventMonitor?.start()
    }
    
    func closePopover(sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
    
    func togglePopover(sender: AnyObject?) {
        if popover.shown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }

}

