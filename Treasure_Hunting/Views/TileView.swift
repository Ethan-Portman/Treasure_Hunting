import SwiftUI

/// Predefined Image symbol for an empty circle.
private let circleImage: Image = Image(systemName: "circle")
/// Predefined Image symbol for a question mark.
private let questionMarkImage: Image = Image(systemName: "questionmark")

/// A SwiftUI view representing a tile on a game board in a treasure hunting game.
/// Tiles are used to hold treasure, clicking on a tile reveals the treasure.
struct TileView: View {
    /// The state of the tile, including its treasure item and reveal status.
    @State public var tile: Tile
    
    /// A closure called when the tile is revealed
    public var onTileRevealed: () -> Void
    
    /// Displays the SF Image treasure item or a circle if showTreasureItem is true.
    /// Displays a question mark if showTreasureItem is false.
    /// Calls the closure `onTileRevealed` once and only once when the tile is clicked/revealed.
    var body: some View {
        Button(action: { 
            if !tile.isRevealed() {
                tile.setRevealed(revealed: true)
                onTileRevealed()
            }
        }) {
            tile.isRevealed()
                ? (tile.isEmpty() ? circleImage : Image(systemName: systemImageName(for: tile.getItem().lowercased())))
                : questionMarkImage
        }
        .frame(width: 30, height: 30)
    }
}

/// Gets the SF image name from a string,. If no image name is found, uses the xmark symbol.
/// - Parameter itemName: The name of the SF Image symbol to find.
/// - Returns: The name of a valid SF image symbol.
private func systemImageName(for itemName: String) -> String {
    let systemImageName = UIImage(systemName: itemName)?.isSymbolImage ?? false ? itemName : "xmark"
    return systemImageName
}

#Preview {
    MainView()
}
