//
//  Board.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-08.
//

import Foundation

@Observable class Board {
    let boardSize = 6
    var tiles: [[Tile]]
    var itemGroups: [String: [(row: Int, column: Int)]]
    
    init() {
        tiles = [[Tile]]()
        itemGroups = [String: [(row: Int, column: Int)]]()
        
        for _ in 1...boardSize {
            var tileRow = [Tile]()
            for _ in 1...boardSize {
                tileRow.append(Tile(item: nil))
            }
            tiles.append(tileRow)
        }
    }
    
    subscript(row: Int, column: Int) -> String? {
        get {
            if (row < 0) || (boardSize <= row) || (column < 0) || (boardSize <= column) {
                return nil
            }
            return tiles[row][column].item
        }
        set {
            if (row < 0) || (boardSize <= row) || (column < 0) || (boardSize <= column) {
                return
            }
            tiles[row][column].item = newValue ?? ""
            
            // Add the cell to the item group
            if let newValue = newValue {
                if itemGroups[newValue] == nil {
                    itemGroups[newValue] = [(row, column)]
                } else {
                    itemGroups[newValue]?.append((row, column))
                }
            }
        }
    }
}
