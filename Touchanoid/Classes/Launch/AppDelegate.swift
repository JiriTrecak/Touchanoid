//
//  AppDelegate.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import Cocoa
import AppKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - App core delegate
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        // Insert code here to initialize your application
        self.setupApplication()
    }
    
    func applicationWillTerminate(_ aNotification: Notification) {
        
        // Insert code here to tear down your application
    }
    
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    func setupApplication() {
        
        // Enable Touch Bar
        if #available(OSX 10.12.2, *) {
            NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
        } else {
            assertionFailure("Touchbar API unavailable")
        }
    }
}
