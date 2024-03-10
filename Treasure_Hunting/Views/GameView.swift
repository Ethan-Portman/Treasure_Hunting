import SwiftUI
import SwiftData

/// A SwiftUI view representing the main game screen for a Treasure Hunting Game.
/// Displays a grid of clickable tiles, where each tile may contain a hidden treasure item.
/// Tracks the player's attempts to reveal treasures and the remaining treasures on the board.
struct GameView: View {
    /// Query for retrieving a list of treasure items from the data store.
    @Query private var treasureItems: [TreasureItem]
    
    /// The managed object context for interacting with the TreasureItems data store
    @Environment(\.modelContext) private var modelContext
    
    /// The game board, managing the arrangement of treasure items.
    @State private var board = Board()
    
    /// The number of attempts to find treasure made by the player.
    @State private var numAttempts = 0
    
    /// The count of treasures yet to be discovered on the board.
    @State private var treasuresRemaining = 0
    
    var body: some View {
        VStack {
            // Display the game board as a grid of clickable tiles.
            Grid {
                ForEach(0..<Board.boardSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<Board.boardSize, id: \.self) { col in
                            let itemName = board[row, col]?.lowercased() ?? ""
                            TileView(treasureItemTitle: itemName) {
                                numAttempts += 1
                                if itemName != "" {
                                    treasuresRemaining -= 1
                                }
                            }
                        }
                    }
                }
            }
            .padding()
            
            // Display the number of attempts made by the player.
            Text("Attempts: \(numAttempts)")
            
            // Display the number of treasures remaining or indicate game over.
            Text(treasuresRemaining > 0 ? "Total Remaining: \(treasuresRemaining)" : "Game Over!")
        }
        .onAppear {
            // Populate the game board with treasure items.
            board.populateBoard(treasureItems: treasureItems)
            
            // Initialize the count of remaining treasures.
            treasuresRemaining = treasureItems.reduce(0) { $0 + $1.count }
        }
    }
}

#Preview {
    GameView()
}
