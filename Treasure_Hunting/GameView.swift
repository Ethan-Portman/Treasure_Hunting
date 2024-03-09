import SwiftUI
import SwiftData

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
                            TileView(treasureItemTitle: itemName)
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
}

#Preview {
    GameView()
}
