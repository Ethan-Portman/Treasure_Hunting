import SwiftUI
import SwiftData
import os.log

struct SettingsView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    private let logger = Logger()
    
    private var numItemGroups: Int {
        treasureItems.reduce(0) { $0 + ($1.title.isEmpty ? 0 : 1) }
    }
    
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
                                let newTreasureItem = TreasureItem(title: "TEST", count: 3)
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
        .onAppear {
            totalNumItems = treasureItems.reduce(0) { $0 + $1.count }
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
