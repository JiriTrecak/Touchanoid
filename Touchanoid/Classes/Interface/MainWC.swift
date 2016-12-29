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
let ballScrubberItemIdentifier = "com.touchanoid.ballScrubberItem"
let levelScrubberItemIdentifier = "com.touchanoid.levelScrubberItem"


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Class

class MainWC: NSWindowController {
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Properties
    
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Lifecycle
    
    override func windowDidLoad() {
        
        super.windowDidLoad()
        self.setupObservers()
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Setup
    
    func setupObservers() {
        
        // When menu state changes, invalidate current touchbar, effectively forcing system to re-render it with new configuration
        if #available(OSX 10.12.2, *) {
            MenuManager.sharedInstance.onMenuStateChangedClosure.addHandler { state in
                self.touchBar = nil
            }
        }
    }
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Touch Bar Support

@available(OSX 10.12.2, *)
extension MainWC: NSTouchBarDelegate {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Item creation
    
    override func makeTouchBar() -> NSTouchBar? {
        
        let touchBar = NSTouchBar()
        touchBar.delegate = self
        
        // Configure touch bar items based on the current menu state
        switch MenuManager.sharedInstance.menuState {
        case .ballSelection:
            touchBar.defaultItemIdentifiers = [.menuItem, .ballSelectionItem]
        case .paddleSelection:
            touchBar.defaultItemIdentifiers = [.menuItem]
        case .levelSelection:
            touchBar.defaultItemIdentifiers = [.menuItem, .levelSelectionItem]
        case .main:
            touchBar.defaultItemIdentifiers = [.ballsItem, .levelsItem, .paddlesItem, .commandPanelItem]
        }
        
        return touchBar
    }
    
    
    func touchBar(_ touchBar: NSTouchBar, makeItemForIdentifier identifier: NSTouchBarItemIdentifier) -> NSTouchBarItem? {
        
        switch identifier {
        case NSTouchBarItemIdentifier.commandPanelItem:
            return self.createCommandPanelItem()
        case NSTouchBarItemIdentifier.levelSelectionItem:
            return self.createLevelSelectionItem()
        case NSTouchBarItemIdentifier.ballSelectionItem:
            return self.createBallSelectionItem()
        case NSTouchBarItemIdentifier.menuItem:
            return self.createDefaultItemWithIdentifier(identifier: identifier, text: "Menu", selector: #selector(MainWC.menuItemSelected))
        case NSTouchBarItemIdentifier.levelsItem:
            return self.createDefaultItemWithIdentifier(identifier: identifier, text: "Levels", selector: #selector(MainWC.levelsItemSelected))
        case NSTouchBarItemIdentifier.ballsItem:
            return self.createDefaultItemWithIdentifier(identifier: identifier, text: "Balls", selector: #selector(MainWC.ballsItemSelected))
        case NSTouchBarItemIdentifier.paddlesItem:
            return self.createDefaultItemWithIdentifier(identifier: identifier, text: "Paddles", selector: #selector(MainWC.paddlesItemSelected))
        default:
            return nil
        }
    }
    
    
    func createCommandPanelItem() -> NSTouchBarItem {
        
        let customViewItem = NSCustomTouchBarItem(identifier: NSTouchBarItemIdentifier.commandPanelItem)
        customViewItem.view = NSTextField(labelWithString: "----- game controls go here -----")
        return customViewItem
    }
    
    
    func createLevelSelectionItem()  -> NSTouchBarItem {
        
        let customViewItem = NSCustomTouchBarItem(identifier: NSTouchBarItemIdentifier.levelSelectionItem)
        let scrubberFrame = NSRect(x: 0, y: 0, width: 300, height: 30)
        let scrubber = NSScrubber(frame: scrubberFrame)
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(LevelScrubberItem.self, forItemIdentifier: levelScrubberItemIdentifier)
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
    
    
    func createBallSelectionItem()  -> NSTouchBarItem {
        
        let customViewItem = NSCustomTouchBarItem(identifier: NSTouchBarItemIdentifier.ballSelectionItem)
        let scrubberFrame = NSRect(x: 0, y: 0, width: 300, height: 30)
        let scrubber = NSScrubber(frame: scrubberFrame)
        scrubber.scrubberLayout = NSScrubberFlowLayout()
        scrubber.register(BallScrubberItem.self, forItemIdentifier: ballScrubberItemIdentifier)
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
    
    
    func createDefaultItemWithIdentifier(identifier: NSTouchBarItemIdentifier, text: String, selector: Selector) -> NSTouchBarItem {
        
        let item = NSCustomTouchBarItem(identifier: identifier)
        item.view = NSButton(title: text, target: self, action: selector)
        return item
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Actions
    
    func menuItemSelected() {
        
        MenuManager.sharedInstance.menuState = .main
    }
    
    
    func ballsItemSelected() {
        
        MenuManager.sharedInstance.menuState = .ballSelection
    }
    
    
    func levelsItemSelected() {
        
        MenuManager.sharedInstance.menuState = .levelSelection
    }
    
    
    func paddlesItemSelected() {
        
        MenuManager.sharedInstance.menuState = .paddleSelection
    }
}


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - NSScrubberDelegate, DataSource, FlowLayoutDelegate

@available(OSX 10.12.2, *)
extension MainWC: NSScrubberDelegate {
    
    func scrubber(_ scrubber: NSScrubber, didSelectItemAt selectedIndex: Int) {
        
        switch MenuManager.sharedInstance.menuState {
            // Changes current level
            case .levelSelection:
                let level = GameManager.sharedInstance.level(index: selectedIndex)
                MenuManager.sharedInstance.levelChanged(level: level)
            // Changes current ball
            case .ballSelection:
                let ball = GameManager.sharedInstance.ball(index: selectedIndex)
                MenuManager.sharedInstance.ballChanged(ball: ball)
            default:
                break
        }
    }
    
    
    func scrubber(_ scrubber: NSScrubber, didHighlightItemAt highlightedIndex: Int) {
        
    }
    
    
    func scrubber(_ scrubber: NSScrubber, didChangeVisibleRange visibleRange: NSRange) {
        
    }
}


@available(OSX 10.12.2, *)
extension MainWC: NSScrubberDataSource {
    
    func numberOfItems(for scrubber: NSScrubber) -> Int {
        
        switch MenuManager.sharedInstance.menuState {
            case .ballSelection:
                return GameManager.sharedInstance.numberOfBalls()
            case .paddleSelection:
                return 0
            case .levelSelection:
                return GameManager.sharedInstance.numberOfLevels()
            default:
                return 0
        }
    }
    
    func scrubber(_ scrubber: NSScrubber, viewForItemAt index: Int) -> NSScrubberItemView {
        
        switch MenuManager.sharedInstance.menuState {
            // Creates dynamic ball preview - SK Scene view with configured ball
            case .ballSelection:
                let ball = GameManager.sharedInstance.ball(index: index)
                return scrubberItemViewFor(ball: ball, scrubber: scrubber)
            // Creates static paddle preview - thumbnail image
            case .paddleSelection:
                return NSScrubberItemView()
            // Creates static level preview - thumbnail image
            case .levelSelection:
                let level = GameManager.sharedInstance.level(index: index)
                return scrubberItemViewFor(level: level, scrubber: scrubber)
            default:
                return NSScrubberItemView()
        }
    }
    
    
    func scrubberItemViewFor(ball: Ball, scrubber: NSScrubber) -> NSScrubberItemView {
        
        let itemView: BallScrubberItem = scrubber.makeItem(withIdentifier: ballScrubberItemIdentifier, owner: nil) as! BallScrubberItem
        itemView.configureWith(ball: ball)
        
        return itemView
    }
    
    
    func scrubberItemViewFor(level: Level, scrubber: NSScrubber) -> NSScrubberItemView {
        
        let itemView: LevelScrubberItem = scrubber.makeItem(withIdentifier: levelScrubberItemIdentifier, owner: nil) as! LevelScrubberItem
        itemView.configureWith(level: level)
        
        return itemView
    }
}


@available(OSX 10.12.2, *)
extension MainWC: NSScrubberFlowLayoutDelegate {
    
    func scrubber(_ scrubber: NSScrubber, layout: NSScrubberFlowLayout, sizeForItemAt itemIndex: Int) -> NSSize {
        
        switch MenuManager.sharedInstance.menuState {
        case .ballSelection:
            let ball = GameManager.sharedInstance.ball(index: itemIndex)
            return NSSize(width: ball.emitterName != nil ? 120 : 60, height: 30)
        case .paddleSelection:
            return NSSize(width: 120, height: 30)
        case .levelSelection:
            return NSSize(width: 60, height: 30)
        default:
            return .zero
        }
    }
}
