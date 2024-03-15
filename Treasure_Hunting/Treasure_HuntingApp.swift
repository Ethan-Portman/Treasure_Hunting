import SwiftUI
import SwiftData
import os.log

/// The logger instance for logging messages within the App.
public let logger = Logger()

/// The main entry point for the Treasure Hunting app.
@main
struct Treasure_HuntingApp: App {
    /// The body of the app, defining the main scene.
    var body: some Scene {
        WindowGroup {
            MainView()
        }
        // Register the model container for TreasureItem to be used in the App to keep track of treasures
        .modelContainer(for: TreasureItem.self)
    }
}
