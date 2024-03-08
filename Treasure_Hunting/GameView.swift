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
    
    init() {
        tiles = [[Tile]]()
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
            tiles[row][column].item = newValue!
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
        print("Starting to populate board")

        for treasureItem in treasureItems {
            var firstEmptyCell: (row: Int, column: Int)? = nil

            if let cell = findEmptyCell(board: board) {
                firstEmptyCell = cell
                print(treasureItem.title)
                board[cell.row, cell.column] = treasureItem.title
            }

            for _ in 2...treasureItem.count { // Start from 2 since the first cell is already handled
                if let adjacentCell = findAdjacentEmptyCell(board: board, baseCell: firstEmptyCell!) {
                    board[adjacentCell.row, adjacentCell.column] = treasureItem.title
                }
            }
        }
    }
    
    private func findAdjacentEmptyCell(board: Board, baseCell: (row: Int, column: Int)) -> (row: Int, column: Int)? {
        // Define the possible adjacent positions (up, down, left, right)
        let directions: [(Int, Int)] = [(0, -1), (0, 1), (-1, 0), (1, 0)]

        for direction in directions {
            let newRow = baseCell.row + direction.0
            let newColumn = baseCell.column + direction.1

            if newRow >= 0 && newRow < board.boardSize && newColumn >= 0 && newColumn < board.boardSize {
                // Check if the adjacent cell is empty
                if board[newRow, newColumn] == "" {
                    return (row: newRow, column: newColumn)
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
}

#Preview {
    GameView()
}
