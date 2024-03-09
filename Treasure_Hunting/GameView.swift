import SwiftUI
import SwiftData

struct GameView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    
    @State private var board = Board()
    @State private var numAttempts = 0
    
    private var totalTreasures: Int {
        treasureItems.reduce(0) { $0 + $1.count }
    }
    
    var body: some View {
        VStack {
            Grid {
                ForEach(0..<board.boardSize, id: \.self) { row in
                    GridRow {
                        ForEach(0..<board.boardSize, id: \.self) { col in
                            let itemName = board[row, col]?.lowercased() ?? ""
                            TileView(treasureItemTitle: itemName) {
                                numAttempts += 1
                                print(numAttempts)
                            }
                        }
                    }
                }
            }
            .padding()
            Text("Attempts: \(numAttempts)")
            Text("Total Remaining: \(totalTreasures)")
        }
        .onAppear {
            board.populateBoard(treasureItems: treasureItems)
        }
    }
}

#Preview {
    GameView()
}
