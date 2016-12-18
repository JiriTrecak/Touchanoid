//
//  MainWC.swift
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

class MainWC: NSWindowController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    override func windowDidLoad() {
        
        super.windowDidLoad()
        self.setupMainWindow()
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    func setupMainWindow() {
        
        
    }
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Touch Bar Support

@available(OSX 10.12.2, *)
extension MainWC: NSTouchBarDelegate {
    
    override func makeTouchBar() -> NSTouchBar? {
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        touchBar.defaultItemIdentifiers = [.commandPanelItem]
        
        return touchBar
    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.commandPanelItem:
            return self.createCommandPanelItem()
        default:
            return nil
        }
    }
    
    
    func createCommandPanelItem() -> NSTouchBarItem {
        
        let customViewItem = NSCustomTouchBarItem(identifier: NSTouchBarItemIdentifier.commandPanelItem)
        customViewItem.view = NSTextField(labelWithString: "My awesome game controls [WIP]")
        return customViewItem
    }
}
