//
//  GameView.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import SwiftUI
import SwiftData

@Observable class Tile {
    var item: String
    
    init(item: String?) {
        self.item = item ?? ""
    }
}

@Observable class Board {
    let boardSize = 6
    var tiles: [[Tile]]
    var itemGroups: [String: [(row: Int, column: Int)]]
    
    init() {
        tiles = [[Tile]]()
        itemGroups = [String: [(row: Int, column: Int)]]()
        
        for _ in 1...boardSize {
            var tileRow = [Tile]()
            for _ in 1...boardSize {
                tileRow.append(Tile(item: nil))
            }
            tiles.append(tileRow)
        }
    }
    
    subscript(row: Int, column: Int) -> String? {
        get {
            if (row < 0) || (boardSize <= row) || (column < 0) || (boardSize <= column) {
                return nil
            }
            return tiles[row][column].item
        }
        set {
            if (row < 0) || (boardSize <= row) || (column < 0) || (boardSize <= column) {
                return
            }
            tiles[row][column].item = newValue ?? ""
            
            // Add the cell to the item group
            if let newValue = newValue {
                if itemGroups[newValue] == nil {
                    itemGroups[newValue] = [(row, column)]
                } else {
                    itemGroups[newValue]?.append((row, column))
                }
            }
        }
    }
}

struct GameView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    
    @State var board = Board()
    
    var body: some View {
        populateBoard()
        
        return Grid {
            ForEach(0..<board.boardSize, id: \.self) { row in
                GridRow {
                    ForEach(0..<board.boardSize, id: \.self) { col in
                        Text(board[row, col] ?? "")
                            .frame(width: 30, height: 30)
                            .border(Color.black)
                    }
                }
            }
        }
        .padding()
    }
    
    private func populateBoard() {
        clearBoard()
        print("Starting to populate board")

        for treasureItem in treasureItems {
            var firstEmptyCell: (row: Int, column: Int)? = nil

            if let cell = findEmptyCell(board: board) {
                firstEmptyCell = cell
                print(treasureItem.title)
                board[cell.row, cell.column] = treasureItem.title
                
                // Add the first cell to the item group
                if board.itemGroups[treasureItem.title] == nil {
                    board.itemGroups[treasureItem.title] = [cell]
                } else {
                    board.itemGroups[treasureItem.title]?.append(cell)
                }
            }

            for _ in 2...treasureItem.count {
                if let adjacentCell = findAdjacentEmptyCell(board: board, itemGroup: board.itemGroups[treasureItem.title] ?? []) {
                    board[adjacentCell.row, adjacentCell.column] = treasureItem.title

                    // Add the adjacent cell to the item group
                    if board.itemGroups[treasureItem.title] == nil {
                        board.itemGroups[treasureItem.title] = [adjacentCell]
                    } else {
                        board.itemGroups[treasureItem.title]?.append(adjacentCell)
                    }

                    firstEmptyCell = adjacentCell
                }
            }
        }
    }
    
    private func findAdjacentEmptyCell(board: Board, itemGroup: [(row: Int, column: Int)]) -> (row: Int, column: Int)? {
        // Define the possible directions (up, down, left, right)
        let directions: [(Int, Int)] = [(-1, 0), (1, 0), (0, -1), (0, 1)]

        // Shuffle the directions to start the search from a random direction
        let shuffledDirections = directions.shuffled()

        for direction in shuffledDirections {
            for cell in itemGroup {
                let newRow = cell.row + direction.0
                let newColumn = cell.column + direction.1

                // Check if the new position is within the board boundaries
                if newRow >= 0 && newRow < board.boardSize && newColumn >= 0 && newColumn < board.boardSize {
                    // Check if the adjacent cell is empty
                    if board[newRow, newColumn] == "" {
                        return (row: newRow, column: newColumn)
                    }
                }
            }
        }

        // No empty adjacent cells found
        return nil
    }
    
    private func findEmptyCell(board: Board) -> (row: Int, column: Int)? {
        while true {
            let randomRow = Int.random(in: 0..<board.boardSize)
            let randomColumn = Int.random(in: 0..<board.boardSize)
            let randTile = board.tiles[randomRow][randomColumn]

            if randTile.item == "" {
                return (row: randomRow, column: randomColumn)
            }
        }
    }
    
    private func clearBoard() {
        for row in 0..<board.boardSize {
            for col in 0..<board.boardSize {
                board[row, col] = nil
            }
        }
    }
}

#Preview {
    GameView()
}
