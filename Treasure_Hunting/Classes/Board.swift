import Foundation

/// A class representing a game board for a Treasure Hunting Game.
/// The Board is a 2D Array of type Tile and is responsible for managing the placement of treasure items.
/// Treasure Items with the same name are placed adjacent to eachother.
@Observable class Board {
    /// The size of the game board.
    public let boardSize = 6
    
    /// A 2D array representing the tiles on the game board.
    private var tiles: [[Tile]]
    
    /// A dictionary storing the groups of treasure items on the board.
    private var treasureItemGroups: [String: [(row: Int, column: Int)]]
    
    /// Initializes a new instance of the 'Board' Class
    /// The board starts out empty with no treasure items.
    init() {
        tiles = [[Tile]]()
        treasureItemGroups = [String: [(row: Int, column: Int)]]()

        for _ in 1...boardSize {
            var tileRow = [Tile]()
            for _ in 1...boardSize {
                tileRow.append(Tile(item: nil))
            }
            tiles.append(tileRow)
        }
    }
    
    /// Gets or sets the treasure item at the specified row and column on the board.
    /// - Parameter row: The row of the board.
    /// - Parameter col: The column of the board
    /// - Returns: The name of the treasure item at the specified location, or nil if out of bounds
    subscript(row: Int, col: Int) -> String? {
        get {
            guard (0..<boardSize).contains(row), (0..<boardSize).contains(col) else {
                return nil
            }
            return tiles[row][col].item
        }
        set {
            guard (0..<boardSize).contains(row), (0..<boardSize).contains(col) else {
                return
            }
            tiles[row][col].item = newValue ?? ""
            
            if let newValue = newValue {
                treasureItemGroups[newValue, default: []].append((row, col))
            }
        }
    }
    
    /// Populates the board with treasure items.
    /// - Parameter treasureItems: An array of treasure items to be placed onto the board.
    public func populateBoard(treasureItems: [TreasureItem]) {
        let totalItems = treasureItems.reduce(0) { $0 + $1.count }
        var successfullyPlacedItems = 0

        while (successfullyPlacedItems != totalItems) {
            resetBoard()
            successfullyPlacedItems = placeItemsOnBoard(treasureItems: treasureItems)
        }
    }
    
    /// Resets the board by clearing all tiles and item groups
    private func resetBoard() {
        for row in 0..<boardSize {
            for column in 0..<boardSize {
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
            if let cell = findEmptyCell() {
                self[cell.row, cell.column] = treasureItem.title
                successfullyPlacedItems += 1
                treasureItemGroups[treasureItem.title, default: []].append(cell)
            }
            
            for _ in 2...treasureItem.count {
                if let adjacentCell = findAdjacentEmptyCell(itemGroup: treasureItemGroups[treasureItem.title] ?? []) {
                    self[adjacentCell.row, adjacentCell.column] = treasureItem.title
                    successfullyPlacedItems += 1
                    treasureItemGroups[treasureItem.title, default: []].append(adjacentCell)
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
            let randomRow = Int.random(in: 0..<boardSize)
            let randomColumn = Int.random(in: 0..<boardSize)
            let randTile = tiles[randomRow][randomColumn]

            if randTile.item == "" {
                return (row: randomRow, column: randomColumn)
            }
        }
    }
    
    
    /// Finds the coordinates of an adjacent empty cell based on a given item group.
    /// Searches for free spaces adjacent to the cells in the item group.
    /// - Parameter itemGroup: The item group for which an adjacent empty cell is sought.
    /// - Returns: A tuple containing the row and column indices of an adjacent empty cell, or nil if no adjacent cells found
    private func findAdjacentEmptyCell(itemGroup: [(row: Int, column: Int)]) -> (row: Int, column: Int)? {
        let directions: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]
        let shuffledDirections = directions.shuffled()

        for direction in shuffledDirections {
            for cell in itemGroup {
                let newRow = cell.row + direction.0
                let newColumn = cell.column + direction.1

                if (0..<boardSize).contains(newRow) && (0..<boardSize).contains(newColumn) && self[newRow, newColumn] == "" {
                    return (row: newRow, column: newColumn)
                }
            }
        }
        return nil
    }
}
