import SwiftUI
import SwiftData

/// The main view of the Treasure Hunting app
/// Displays tabs to switch betweent the Game View and the Settings View.
/// GameView is where the game is played, SettingsView is where treasures are configured.
struct MainView: View {
    var body: some View {
        TabView {
            GameView()
                .tabItem { Text("Game") }
            SettingsView()
                .tabItem { Text("Settings") }
        }
    }
}

#Preview {
    MainView()
}
