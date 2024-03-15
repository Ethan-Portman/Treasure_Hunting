import Foundation

/// A class representing a tile on the game board in a Treasure Hunting Game.
/// Each tile can contain a treasure item, and this class provides a mechanism to manage the item on the tile.
/// This class is used by the 'Board' class.
@Observable class Tile {
    /// The name of the treasure item on the tile. An empty string indicates no treasure item.
    var item: String
    var revealed: Bool
    
    /// Initializes a new instance of the 'Tile' class.
    /// - Parameter item: The initial treasure item on the tile. Defaults to an empty string.
    init(item: String?) {
        self.item = item ?? ""
        self.revealed = false
    }
    
    public func setRevealed(revealed: Bool) {
        self.revealed = revealed;
    }
    
    public func isEmpty() -> Bool {
        return item == ""
    }
}
