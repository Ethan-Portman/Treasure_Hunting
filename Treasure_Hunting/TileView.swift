import SwiftUI

let circleImage: Image = Image(systemName: "circle")
let questionMarkImage: Image = Image(systemName: "questionmark")


/// A SwiftUI view representing a tile on a game board in a treasure hunting game.
struct TileView: View {
    /// The name of the treasure item on the tile.
    var treasureItemTitle: String
    
    var onTileRevealed: () -> Void
    
    /// The state that tracks whether the tile is revealed or not.
    @State private var showTreasureItem = false
    
    /// Displays the SF Image treasure item or a circle if showTreasureItem is true.
    /// Displays a questionmark if showTreasureItem is false
    var body: some View {
        Button(action: { 
            if !showTreasureItem {
                showTreasureItem = true
                onTileRevealed()
            }
        }) {
                if showTreasureItem {
                    if treasureItemTitle != "" {
                        Image(systemName: systemImageName(for: treasureItemTitle))
                    } else {
                        circleImage
                    }
                } else {
                    questionMarkImage
                }
        }
        .frame(width: 30, height: 30)
    }
}


/// Gets the SF image name from a string,. If no image name is found, uses the xmark symbol.
/// - Parameter itemName: The name of the SF Image symbol to find.
/// - Returns: The name of a valid SF image symbol.
func systemImageName(for itemName: String) -> String {
    let systemImageName = UIImage(systemName: itemName)?.isSymbolImage ?? false ? itemName : "xmark"
    return systemImageName
}

#Preview {
    TileView(treasureItemTitle: "hare") {
        // Closure to increment numAttempts when a tile is revealed
        var x = 10
    }
}
