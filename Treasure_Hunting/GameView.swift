//
//  GameView.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import SwiftUI
import SwiftData

func systemImageName(for itemName: String) -> String {
    // Map your item names to system image names dynamically
    let systemImageName = UIImage(systemName: itemName)?.isSymbolImage ?? false ? itemName : "questionmark"
    return systemImageName
}

struct TileView: View {
    var title: String
    @State private var revealed = false
    
    var body: some View {
        Button(action: { revealed = true }) {
            if revealed {
                Image(systemName: systemImageName(for: title))
            } else {
                Image(systemName: "circle")
            }
        }
        .frame(width: 30, height: 30)
        .border(Color.black)
    }
}

struct GameView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    
    @State var board = Board()
    @State var someBinding = "title"
    
    var body: some View {
        VStack {
            TextField("Enter text", text: $someBinding)
                .padding()
            
            Grid {
                ForEach(0..<board.boardSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<board.boardSize, id: \.self) { col in
                            let itemName = board[row, col]?.lowercased() ?? ""
                            TileView(title: itemName)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            board.populateBoard(treasureItems: treasureItems)
        }
    }
    
    private func systemImageName(for itemName: String) -> String {
        // Map your item names to system image names dynamically
        let systemImageName = UIImage(systemName: itemName)?.isSymbolImage ?? false ? itemName : "questionmark"
        return systemImageName
    }
}

#Preview {
    GameView()
}
