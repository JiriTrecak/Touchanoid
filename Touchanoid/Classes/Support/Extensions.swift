//
//  Extensions.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Import

import AppKit
import Cocoa


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - Touch Bar

extension NSTouchBarItem.Identifier {
    static let commandPanelItem = NSTouchBarItem.Identifier("com.touchanoid.commandPanel")
    static let levelSelectionItem = NSTouchBarItem.Identifier("com.touchanoid.levelSelection")
    static let ballSelectionItem = NSTouchBarItem.Identifier("com.touchanoid.ballSelection")
    
    static let menuItem = NSTouchBarItem.Identifier("com.touchanoid.menuItem")
    static let levelsItem = NSTouchBarItem.Identifier("com.touchanoid.levelsItem")
    static let ballsItem = NSTouchBarItem.Identifier("com.touchanoid.ballsItem")
    static let paddlesItem = NSTouchBarItem.Identifier("com.touchanoid.paddlesItem")
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - NSImage

extension NSImage {
    
    func drawRectangle(atPosition position: CGPoint, size: CGSize, color: NSColor) {
        
        self.lockFocus()
        color.setFill()
        
        let imageRect = NSRect(origin: position, size: size)
        imageRect.fill(using: .destinationAtop)
        
        self.unlockFocus()
    }
}
