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
// MARK: - Definitions

let textScrubberItemIdentifier = "com.touchanoid.textScrubberItem"
let imageScrubberItemIdentifier = "com.touchanoid.imageScrubberItem"


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
        touchBar.defaultItemIdentifiers = [.levelSelectionItem]
        
        return touchBar
    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.commandPanelItem:
            return self.createCommandPanelItem()
        case NSTouchBarItemIdentifier.levelSelectionItem:
            return self.createLevelSelectionItem()
        default:
            return nil
        }
    }
    
    
    func createCommandPanelItem() -> NSTouchBarItem {
        
        let customViewItem = NSCustomTouchBarItem(identifier: NSTouchBarItemIdentifier.commandPanelItem)
        customViewItem.view = NSTextField(labelWithString: "My awesome game controls [WIP]")
        return customViewItem
    }
    
    
    func createLevelSelectionItem()  -> NSTouchBarItem {
        
        let customViewItem = NSCustomTouchBarItem(identifier: NSTouchBarItemIdentifier.levelSelectionItem)
        let scrubberFrame = NSRect(x: 0, y: 0, width: 300, height: 30)
        let scrubber = NSScrubber(frame: scrubberFrame)
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(NSScrubberImageItemView.self, forItemIdentifier: imageScrubberItemIdentifier)
        scrubber.delegate = self
        scrubber.dataSource = self
        scrubber.mode = .free
        scrubber.showsArrowButtons = false
        scrubber.selectionOverlayStyle = nil
        scrubber.selectionBackgroundStyle = NSScrubberSelectionStyle.roundedBackground
        scrubber.backgroundColor = NSColor.clear
        customViewItem.view = scrubber
        
        return customViewItem
    }
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - NSScrubberDelegate, DataSource, FlowLayoutDelegate

@available(OSX 10.12.2, *)
extension MainWC: NSScrubberDelegate {
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt selectedIndex: Int) {
        
        NSLog("selected")
        let level = GameManager.sharedInstance.level(index: selectedIndex)
        MenuManager.sharedInstance.levelChanged(level: level)
    }
    
    func scrubber(_ scrubber: NSScrubber, didHighlightItemAt highlightedIndex: Int) {
        
    }
    
    func scrubber(_ scrubber: NSScrubber, didChangeVisibleRange visibleRange: NSRange) {
        
    }
}


@available(OSX 10.12.2, *)
extension MainWC: NSScrubberDataSource {
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        
        return GameManager.sharedInstance.numberOfLevels()
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        
        let itemView: NSScrubberImageItemView = scrubber.makeItem(withIdentifier: imageScrubberItemIdentifier, owner: nil) as! NSScrubberImageItemView
        let level = GameManager.sharedInstance.level(index: index)
        itemView.imageView.image = level.thumbnail(constrainedToSize: NSSize(width: 50, height: 25))
        itemView.imageView.imageScaling = .scaleNone
        itemView.imageView.imageAlignment = .alignCenter

        return itemView;
    }
}


@available(OSX 10.12.2, *)
extension MainWC: NSScrubberFlowLayoutDelegate {
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        
        return NSSize(width: 60, height: 30)
    }
}
