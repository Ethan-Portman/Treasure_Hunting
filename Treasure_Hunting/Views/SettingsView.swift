import SwiftUI
import SwiftData

struct SettingsView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(treasureItems, id: \.id) { item in
                    SettingsRowView(treasureItem: item)
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
                            let newTreasureItem = TreasureItem(title: "TEST", count: 3)
                            modelContext.insert(newTreasureItem)
                        },
                        label: { Image(systemName: "plus")}
                    )
                }
            }
        }
    }
    
    private func handleDeletion(at indices: IndexSet) {
        indices.forEach { index in
            let itemToDelete = treasureItems[index]
            modelContext.delete(itemToDelete)
            do {
                try modelContext.save()
            } catch {
                print("Error deleting item: \(error)")
            }
        }
    }
}

#Preview {
    MainView()
}
