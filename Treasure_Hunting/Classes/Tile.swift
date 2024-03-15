import Foundation

/// A class representing a tile on the game board in a Treasure Hunting Game.
/// Each tile can contain a treasure item, and this class provides a mechanism to manage the item on the tile.
/// This class is used by the 'Board' class and is displayed with the TileView class.
@Observable class Tile {
    /// The name of the treasure item on the tile. An empty string indicates no treasure item.
    private var item: String
    /// The revealed state of the item. If revealed the underlying item displays on the board
    private var revealed: Bool
    
    /// Initializes a new instance of the 'Tile' class.
    /// - Parameter item: The initial treasure item on the tile. Defaults to an empty string.
    init(item: String?) {
        self.item = item ?? ""
        self.revealed = false
    }
    
    /// Sets whether the tile is revealed or not.
    /// - Parameter revealed: A boolean value indicating whether the tile is revealed.
    public func setRevealed(revealed: Bool) {
        self.revealed = revealed;
    }
    
    /// Checks if the tile is revealed.
    /// - Returns: A boolean value indicating whether the tile is revealed.
    public func isRevealed() -> Bool {
        return self.revealed
    }
    
    /// Checks if the tile is empty (no treasure item).
    /// - Returns: A boolean value indicating whether the tile is empty.
    public func isEmpty() -> Bool {
        return item == ""
    }
    
    /// Gets the treasure item name on the tile.
    /// - Returns: The name of the treasure item on the tile.
    public func getItem() -> String {
        return item
    }
    
    /// Sets the treasure item on the tile.
    /// - Parameter item: The name of the treasure item to set on the tile.
    public func setItem(item: String) {
        self.item = item
    }
}
