//
//  Treasure_HuntingApp.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import SwiftUI
import SwiftData

@main
struct Treasure_HuntingApp: App {

    var body: some Scene {
        WindowGroup {
            // Pass modelContext to MainView
            MainView()
        }
        // Register the model container for TreasureItem
        .modelContainer(for: TreasureItem.self)
    }
}
