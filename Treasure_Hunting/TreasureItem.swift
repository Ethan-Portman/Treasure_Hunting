//
//  TreasureItem.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import Foundation
import SwiftData
import UIKit

@Model class TreasureItem: Identifiable {
    let id = UUID()
    var title = ""
    var count = 0
    
    init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
}
