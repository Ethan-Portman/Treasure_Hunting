import SwiftUI

/// Predefined Image symbol for an empty circle.
let circleImage: Image = Image(systemName: "circle")
/// Predefined Image symbol for a question mark.
let questionMarkImage: Image = Image(systemName: "questionmark")


/// A SwiftUI view representing a tile on a game board in a treasure hunting game.
/// Tiles are used to hold treasure, clicking on a tile reveals the treasure.
struct TileView: View {
    /// The name of the treasure item on the tile.
    var treasureItemTitle: String
    
    /// A closure called when the tile is revealed
    var onTileRevealed: () -> Void
    
    /// The state that tracks whether the tile is revealed or not.
    @State private var showTreasureItem = false
    
    /// Displays the SF Image treasure item or a circle if showTreasureItem is true.
    /// Displays a question mark if showTreasureItem is false.
    /// Calls the closure `onTileRevealed` once and only once when the tile is clicked/revealed.
    var body: some View {
        Button(action: { 
            if !showTreasureItem {
                showTreasureItem = true
                onTileRevealed()
            }
        }) {
            showTreasureItem 
                ? (treasureItemTitle.isEmpty ? circleImage : Image(systemName: systemImageName(for: treasureItemTitle)))
                : questionMarkImage
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
    MainView()
}
