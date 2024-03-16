import SwiftUI
import SwiftData

/// A SwiftUI view representing the main game screen for a Treasure Hunting Game.
/// Displays a grid of clickable tiles, where each tile may contain a hidden treasure item.
/// Tracks the player's attempts to reveal treasures and the remaining treasures on the board.
struct GameView: View {
    /// Query for retrieving a list of treasure items from the data store.
    @Query private var treasureItems: [TreasureItem]
    
    /// The game board, managing the arrangement of treasure items.
    @State private var board = Board()
    
    /// The number of attempts to find treasure made by the player.
    @State private var numAttempts = 0
    
    /// The count of treasures yet to be discovered on the board.
    @State private var treasuresRemaining = 0
    
    /// The body of the GameView, containing the game logic and UI elements fo a GameBoard
    var body: some View {
        VStack {
            // Display the game board as a grid of clickable tiles.
            Grid {
                ForEach(0..<Board.boardSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<Board.boardSize, id: \.self) { col in
                            if let tile = board[row, col] {
                                TileView(tile: tile) {
                                    numAttempts += 1
                                    if !tile.isEmpty() {
                                        treasuresRemaining -= 1
                                    }
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
         // Fires anytime the GameView is viewed
        .onAppear {
            // Populate the game board with treasure items.
            board.populateBoard(treasureItems: treasureItems)
            
            // Initialize the count of remaining treasures.
            treasuresRemaining = treasureItems.reduce(0) { $0 + $1.count }
            
            // Reset the number of counts
            numAttempts = 0
        }
    }
}

#Preview {
    GameView()
}
