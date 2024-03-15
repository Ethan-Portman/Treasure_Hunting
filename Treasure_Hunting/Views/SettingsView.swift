import SwiftUI
import SwiftData
import os.log

/// A SwiftUI view for managing and editing treasure items.
/// Displays a list of treasure items with the ability to add, edit, and delete items.
struct SettingsView: View {
    /// Fetches an array of treasure items using SwiftData's Query.
    @Query private var treasureItems: [TreasureItem]
    
    /// The modelContext for interacting with the treasureItems
    @Environment(\.modelContext) private var modelContext
    
    /// The logger instance for logging messages.
    private let logger = Logger()
    
    /// The number of non-empty item groups.
    @State private var numItemGroups: Int = 0
    
    /// The total count of all treasure items.
    @State private var totalNumItems: Int = 0
    
    /// Defines the layout of the Settings View, presenting a list of the treasure items with options for editing, deleting and adding
    /// Counts are updated dynamically whenever treasureItems changes
    var body: some View {
        NavigationView {
            List {
                ForEach(treasureItems, id: \.id) { item in
                    SettingsRowView(treasureItem: item, totalNumItems: $totalNumItems)
                }
                .onDelete { indexSet in
                    handleDeletion(at: indexSet)
                }
            }
            .navigationTitle("Treasures")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    EditButton()
                    Button(
                        action: {
                            if numItemGroups < Board.maxTreasureItemGroups && totalNumItems < Board.maxTreasureItems {
                                let newTreasureItem = TreasureItem()
                                modelContext.insert(newTreasureItem)
                            }
                            else {
                                logger.log("Maximum number of item groups or items reached")
                            }
                        },
                        label: { Image(systemName: "plus")}
                    )
                }
            }
        }
        // Updates the counts of item groups and total items whenever treasureItems is modified
        .onChange(of: treasureItems, initial: true) { oldTreasureItems, newTreasureItems in
            totalNumItems = newTreasureItems.reduce(0) { $0 + $1.count }
            numItemGroups = newTreasureItems.reduce(0) { $0 + ($1.title.isEmpty ? 0 : 1) }
        }
    }
    
    /// Deletes treasure items at the specified indices.
    private func handleDeletion(at indices: IndexSet) {
        indices.forEach { index in
            let itemToDelete = treasureItems[index]
            modelContext.delete(itemToDelete)
            do {
                try modelContext.save()
            } catch {
                logger.log("Error deleting item: \(error)")
            }
        }
    }
}

#Preview {
    MainView()
}
