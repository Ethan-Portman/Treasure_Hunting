//
//  Tile.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-08.
//

import Foundation

@Observable class Tile {
    var item: String
    
    init(item: String?) {
        self.item = item ?? ""
    }
}
