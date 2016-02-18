//
//  CustomTableHeaderView.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 18/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class CustomTableHeaderView: NSTableHeaderView {
    
    override var allowsVibrancy: Bool {
        return false
    }

    override func awakeFromNib() {
        wantsLayer = true
        layer?.backgroundColor = NSColor.blackColor().CGColor
    }
    
}
