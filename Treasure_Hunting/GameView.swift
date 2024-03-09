import SwiftUI
import SwiftData

struct GameView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    
    @State private var board = Board()
    @State private var numAttempts = 0
    @State private var treasuresRemaining = 0
    
    var body: some View {
        VStack {
            Grid {
                ForEach(0..<board.boardSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<board.boardSize, id: \.self) { col in
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
            Text("Attempts: \(numAttempts)")
            if treasuresRemaining > 0 {
                Text("Total Remaining: \(treasuresRemaining)")
            } else {
                Text("Game Over!")
            }
        }
        .onAppear {
            board.populateBoard(treasureItems: treasureItems)
            treasuresRemaining = treasureItems.reduce(0) { $0 + $1.count }
        }
    }
}

#Preview {
    GameView()
}
