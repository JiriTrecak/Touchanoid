//
//  Level.swift
//  Touchanoid
//
//  Created by Jiří Třečák on 18.12.16.
//  Copyright © 2016 Jiri Trecak. All rights reserved.
//

// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Imports

import Foundation
import Warp


// --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
// MARK: - Object definition

class Level : WRPObject {
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object properties
    
    @objc dynamic var name : String!
    @objc dynamic var structure : String!
    var levelDefinition: [[Int]] = []
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Data object mapping
    
    override func propertyMap() -> [WRPProperty] {
        
        return [
            WRPProperty(remote: "name", bindTo: "name", type: .string),
            WRPProperty(remote: "structure", bindTo: "structure", type: .string)
        ]
    }
    
    
    override func postInit() {
        
        self.buildLevelDefinition()
    }
    
    
    func buildLevelDefinition() {
        
        // Split the string by | to create rows
        let rows = self.structure.components(separatedBy: "|")
        self.levelDefinition = rows.map { (row) -> [Int] in
            row.components(separatedBy: ",").map({ (cell) -> Int in
                Int(cell.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines))!
            })
        }
    }
    
    
    // --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
    // MARK: - Convenience
    
    func thumbnail(constrainedToSize size: NSSize) -> NSImage {
        
        let image = NSImage(size: size)
        let gridSpacing: CGFloat = 1.0
        
        // Go through level definition and draw a grid into image
        for (row, columnStorage) in self.levelDefinition.enumerated() {
            for (column, rawWallType) in columnStorage.enumerated() {
                
                // Each grid item is few pixel of solid color separated by 1 px empty space
                let blockSize = CGSize(width: (size.width - CGFloat(columnStorage.count)) / CGFloat(columnStorage.count),
                                       height: (size.height - CGFloat(self.levelDefinition.count)) / CGFloat(self.levelDefinition.count))
                if let wallType = WallType(rawValue: rawWallType) {
                    let position = CGPoint(x: CGFloat(column) * gridSpacing + CGFloat(column) * blockSize.width,
                                           y: -CGFloat(row + 1) * gridSpacing + size.height - CGFloat(row) * blockSize.height - blockSize.height / 2)
                    let color = GOWall.thumbnailFillColor(ofType: wallType)
                    image.drawRectangle(atPosition: position, size: blockSize, color: color)
                } else {
                    assertionFailure("Definition of the level contains wrong wall type \(rawWallType). See Wall.swift for allowed types.")
                }
            }
        }
        
        return image
    }
}




