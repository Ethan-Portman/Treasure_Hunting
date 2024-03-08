//
//  MainView.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import SwiftUI
import SwiftData

struct MainView: View {
    
    var body: some View {
        TabView {
            GameView()
                .tabItem {
                    Text("Game")
                }
            SettingsView()
                .tabItem {
                    Text("Settings")
                }
        }
    }
}

#Preview {
    MainView()
}
