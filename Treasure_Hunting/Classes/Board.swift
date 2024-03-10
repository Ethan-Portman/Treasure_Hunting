import Foundation
import os.log

/// A class representing a game board for a Treasure Hunting Game.
/// The Board is a 2D Array of type Tile and is responsible for managing the placement of treasure items.
/// Treasure Items with the same name are placed adjacent to eachother.
@Observable class Board {
    /// The size of the game board. Game board is a square with this length.
    static let boardSize = 6
    
    /// The maximum number of treassure item groups the board can hold.
    static let maxTreasureItemGroups = 5
    
    /// The maximum number of treasure items the board can hold.
    static let maxTreasureItems = Board.boardSize * Board.boardSize - 1
    
    /// A 2D array representing the tiles on the game board. Tiles are used to hold treasures.
    private var tiles: [[Tile]]
    
    /// The logger instance for logging messages.
    private let logger = Logger()
    
    /// A dictionary storing the groups of treasure items on the board.
    /// Key is the name of the treasure, value is an array of tile coordinates with that treasure name.
    private var treasureItemGroups: [String: [(row: Int, column: Int)]]
    
    /// Initializes a new instance of the 'Board' Class
    /// The board starts out as an empty grid of tiles with no treasure items.
    init() {
        tiles = [[Tile]]()
        treasureItemGroups = [String: [(row: Int, column: Int)]]()

        for _ in 1...Board.boardSize {
            var tileRow = [Tile]()
            for _ in 1...Board.boardSize {
                tileRow.append(Tile(item: nil))
            }
            tiles.append(tileRow)
        }
    }
    
    /// Gets or sets the treasure item at the specified row and column on the board.
    /// - Parameter row: The row index of the board.
    /// - Parameter col: The column index of the board
    /// - Returns: The name of the treasure item at the specified location, or nil if out of bounds
    subscript(row: Int, col: Int) -> String? {
        // Get the treasure item at a specific coordinate on the board.
        get {
            guard (0..<Board.boardSize).contains(row), (0..<Board.boardSize).contains(col) else {
                return nil
            }
            return tiles[row][col].item
        }
        // Set the treasure item at a specific coordinate on the board.
        set {
            guard (0..<Board.boardSize).contains(row), (0..<Board.boardSize).contains(col), let newValue = newValue else {
                return
            }
            // Set the treasure item at the specified coordinate.
            tiles[row][col].item = newValue
            // Update the treasure item groups dictionary with the new coordinate.
            treasureItemGroups[newValue, default: []].append((row, col))
        }
    }
    
    /// Populates the board with treasure items.
    /// Treasure items are placed randomly on the board. Treasure items with the same name are placed adjacent to eachother.
    /// - Parameter treasureItems: An array of treasure items to be placed onto the board.
    public func populateBoard(treasureItems: [TreasureItem]) {
        let maxAttempts = 20
        let totalItems = treasureItems.reduce(0) { $0 + $1.count }
        var successfullyPlacedItems = 0
        var attempts = 0

        while (successfullyPlacedItems != totalItems && attempts < maxAttempts) {
            logger.log("Attempting to Build Board")
            resetBoard()
            successfullyPlacedItems = placeItemsOnBoard(treasureItems: treasureItems)
            attempts += 1
        }
        logger.log("Board Successfully Built")
    }
    
    /// Resets the board by clearing all tiles and item groups
    private func resetBoard() {
        for row in 0..<Board.boardSize {
            for column in 0..<Board.boardSize {
                self[row, column] = ""
            }
        }
        treasureItemGroups = [String: [(row: Int, column: Int)]]()
    }

    /// Places treasure items on the board.
    /// Treasure items with the same name are grouped together so they can be placed adjacently on the board.
    /// - Parameter treasureItems: An array of treasure items to be placed on the board.
    /// - Returns: The total number of successfully placed items.
    private func placeItemsOnBoard(treasureItems: [TreasureItem]) -> Int {
        var successfullyPlacedItems = 0
        
        for treasureItem in treasureItems {
            // Place the first treasure item of a group randomly on the board.
            if let cell = findEmptyCell() {
                self[cell.row, cell.column] = treasureItem.title
                successfullyPlacedItems += 1
                treasureItemGroups[treasureItem.title, default: []].append(cell)
            }
            // Place the rest of the items within the treasure group on the board.
            // Items are placed so that they are adjacent to an item in the same group.
            if treasureItem.count > 1 {
                for _ in 2...treasureItem.count {
                    if let adjacentCell = findAdjacentEmptyCell(itemGroup: treasureItemGroups[treasureItem.title] ?? []) {
                        self[adjacentCell.row, adjacentCell.column] = treasureItem.title
                        successfullyPlacedItems += 1
                        treasureItemGroups[treasureItem.title, default: []].append(adjacentCell)
                    }
                }
            }
        }
        return successfullyPlacedItems
    }
    
    /// Finds the coordinates of an empty cell on the board.
    /// A cell is considered empty if it does not contain any treasure.
    /// - Returns: A tuple containing the row and column indices of an ampty cell.
    private func findEmptyCell() -> (row: Int, column: Int)? {
        while true {
            let randomRow = Int.random(in: 0..<Board.boardSize)
            let randomColumn = Int.random(in: 0..<Board.boardSize)
            let randTile = tiles[randomRow][randomColumn]

            if randTile.item == "" {
                return (row: randomRow, column: randomColumn)
            }
        }
    }
    
    /// Finds the coordinates of an adjacent empty cell based on a given item group.
    /// Searches for available spaces adjacent to the cells in the item group.
    /// - Parameter itemGroup: The item group for which an adjacent empty cell is sought.
    /// - Returns: A tuple containing the row and column indices of an adjacent empty cell, or nil if no adjacent cells found
    private func findAdjacentEmptyCell(itemGroup: [(row: Int, column: Int)]) -> (row: Int, column: Int)? {
        // Define possible directions to explore for adjacent empty cells.
        let directions: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        
        // Randomize the order of directions to add unpredictability to the search.
        let shuffledDirections = directions.shuffled()

        // Iterate through shuffled directions and then through item group coordinates to find an adjacent empty cell.
        for direction in shuffledDirections {
            for cell in itemGroup {
                let newRow = cell.row + direction.0
                let newColumn = cell.column + direction.1

                if (0..<Board.boardSize).contains(newRow) && (0..<Board.boardSize).contains(newColumn) && self[newRow, newColumn] == "" {
                    return (row: newRow, column: newColumn)
                }
            }
        }
        return nil
    }
}
