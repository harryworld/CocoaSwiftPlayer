//
//  StatusItemViewController.swift
//  CocoaSwiftPlayer
//
//  Created by Harry Ng on 17/2/2016.
//  Copyright © 2016 STAY REAL. All rights reserved.
//

import Cocoa

class StatusItemViewController: PlayerViewController {

    // ========================
    // MARK: - Static functions
    // ========================
    
    class func loadFromNib() -> StatusItemViewController {
        let vc = NSStoryboard(name: "Main", bundle: nil).instantiateControllerWithIdentifier("StatusItemViewController") as! StatusItemViewController
        return vc
    }

    // =========================
    // MARK: - Lifecycle methods
    // =========================

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
        
        let manager = PlayerManager.sharedManager
        volumeSlider.floatValue = manager.volume
    }
    
}
