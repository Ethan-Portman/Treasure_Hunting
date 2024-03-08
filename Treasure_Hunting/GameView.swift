//
//  GameView.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import SwiftUI
import SwiftData

func systemImageName(for itemName: String) -> String {
    // Map your item names to system image names dynamically
    let systemImageName = UIImage(systemName: itemName)?.isSymbolImage ?? false ? itemName : "questionmark"
    return systemImageName
}

struct TileView: View {
    var title: String
    @State private var revealed = false
    
    var body: some View {
        Button(action: { revealed = true }) {
            if revealed {
                Image(systemName: systemImageName(for: title))
            } else {
                Image(systemName: "circle")
            }
        }
        .frame(width: 30, height: 30)
        .border(Color.black)
    }
}

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
                            TileView(title: itemName)
                        }
                    }
                }
            }
            .padding()
        }
        .onAppear {
            populateBoard()
        }
    }
    
    private func systemImageName(for itemName: String) -> String {
        // Map your item names to system image names dynamically
        let systemImageName = UIImage(systemName: itemName)?.isSymbolImage ?? false ? itemName : "questionmark"
        return systemImageName
    }
    
    private func populateBoard() {
        let totalItems = treasureItems.reduce(0) { $0 + $1.count }
        var successfullyPlacedItems = 0

        while (successfullyPlacedItems != totalItems) {
            clearBoard()
            successfullyPlacedItems = placeItemsOnBoard()
        }
    }
    
    private func placeItemsOnBoard() -> Int {
        var successfullyPlacedItems = 0
        for treasureItem in treasureItems {
            if let cell = findEmptyCell(board: board) {
                board[cell.row, cell.column] = treasureItem.title
                successfullyPlacedItems += 1
                
                if board.itemGroups[treasureItem.title] == nil {
                    board.itemGroups[treasureItem.title] = [cell]
                } else {
                    board.itemGroups[treasureItem.title]?.append(cell)
                }
            }
            
            for _ in 2...treasureItem.count {
                if let adjacentCell = findAdjacentEmptyCell(board: board, itemGroup: board.itemGroups[treasureItem.title] ?? []) {
                    board[adjacentCell.row, adjacentCell.column] = treasureItem.title
                    successfullyPlacedItems += 1
                    
                    // Add the adjacent cell to the item group
                    if board.itemGroups[treasureItem.title] == nil {
                        board.itemGroups[treasureItem.title] = [adjacentCell]
                    } else {
                        board.itemGroups[treasureItem.title]?.append(adjacentCell)
                    }
                }
            }
        }
        return successfullyPlacedItems
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
