//
//  PlaylistViewController.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 12/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class PlaylistViewController: NSViewController {
    
    var strings = ["P1", "P2", "P3"]

    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        outlineView.setDataSource(self)
        outlineView.setDelegate(self)
    }
    
    // MARK: - Helper
    
    func isHeader(item: AnyObject) -> Bool {
        return (item as? String) == "Library"
    }
    
}

extension PlaylistViewController: NSOutlineViewDataSource {
    
    func outlineView(outlineView: NSOutlineView, numberOfChildrenOfItem item: AnyObject?) -> Int {
        if item == nil {
            return 1
        } else {
            return strings.count
        }
    }
    
    func outlineView(outlineView: NSOutlineView, isItemExpandable item: AnyObject) -> Bool {
        return true
    }
    
    func outlineView(outlineView: NSOutlineView, child index: Int, ofItem item: AnyObject?) -> AnyObject {
        if item == nil {
            return "Library"
        } else {
            return strings[index]
        }
    }
    
    func outlineView(outlineView: NSOutlineView, objectValueForTableColumn tableColumn: NSTableColumn?, byItem item: AnyObject?) -> AnyObject? {
        return item
    }
    
}

extension PlaylistViewController: NSOutlineViewDelegate {
    
    func outlineView(outlineView: NSOutlineView, viewForTableColumn tableColumn: NSTableColumn?, item: AnyObject) -> NSView? {
        if isHeader(item) {
            return outlineView.makeViewWithIdentifier("HeaderCell", owner: self)
        } else {
            let view = outlineView.makeViewWithIdentifier("DataCell", owner: self) as? NSTableCellView
            view?.textField?.stringValue = (item as? String)!
            return view
        }
    }
    
    func outlineView(outlineView: NSOutlineView, shouldSelectItem item: AnyObject) -> Bool {
        return !isHeader(item)
    }
    
    func outlineView(outlineView: NSOutlineView, shouldShowOutlineCellForItem item: AnyObject) -> Bool {
        return isHeader(item)
    }
    
}
