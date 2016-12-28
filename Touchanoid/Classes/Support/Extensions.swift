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


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Extension - Touch Bar

extension NSTouchBarItemIdentifier {
    static let commandPanelItem = NSTouchBarItemIdentifier("com.touchanoid.commandPanel")
    static let levelSelectionItem = NSTouchBarItemIdentifier("com.touchanoid.levelSelection")
    
    static let menuItem = NSTouchBarItemIdentifier("com.touchanoid.menuItem")
    static let levelsItem = NSTouchBarItemIdentifier("com.touchanoid.levelsItem")
    static let ballsItem = NSTouchBarItemIdentifier("com.touchanoid.ballsItem")
    static let paddlesItem = NSTouchBarItemIdentifier("com.touchanoid.paddlesItem")
}
