import SwiftUI
import SwiftData
import os.log

struct SettingsView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    private let logger = Logger()
    
    @State private var numItemGroups: Int = 0
    @State private var totalNumItems: Int = 0
    
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
        .onChange(of: treasureItems, initial: true) { oldTreasureItems, newTreasureItems in
            totalNumItems = newTreasureItems.reduce(0) { $0 + $1.count }
            numItemGroups = newTreasureItems.reduce(0) { $0 + ($1.title.isEmpty ? 0 : 1) }
        }
    }
    
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
