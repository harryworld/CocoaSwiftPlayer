//
//  PlaylistViewController.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 12/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class PlaylistViewController: NSViewController {

    @IBOutlet weak var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        outlineView.setDataSource(self)
        outlineView.setDelegate(self)
    }
    
}

extension PlaylistViewController: NSOutlineViewDataSource {
    
}

extension PlaylistViewController: NSOutlineViewDelegate {
    
}
