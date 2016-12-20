//
//  Configuration.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Import

import AppKit


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Game configuration

struct GridConfiguration {
    static let blockSpacing: CGFloat = 10
    static let rowHeight: CGFloat = 50
    static let spacingTop: CGFloat = 50
    static let spacingSide: CGFloat = 50
}


struct GameConfiguration {
    static let initialBallSpeed: CGVector = CGVector(dx: 5, dy: 5)
    static let paddleAcceleration: CGFloat = 5
    static let paddleStartingPosition: CGPoint = CGPoint(x: 0, y: -315)
}
