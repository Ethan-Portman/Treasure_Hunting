//
//  SettingsView.swift
//  Treasure_Hunting
//
//  Created by ICS 224 on 2024-03-01.
//

import SwiftUI
import SwiftData


struct RowView: View {
    @Bindable var treasureItem: TreasureItem
    @State private var title: String

    init(treasureItem: TreasureItem) {
        _treasureItem = Bindable(treasureItem)
        _title = State(initialValue: treasureItem.title)
    }

    var body: some View {
        HStack(spacing: 10) {
            TextField("Test", text:
                Binding(
                    get: { title },
                    set: { newValue in
                        title = newValue
                        treasureItem.title = newValue
                    }
                )
            )
            
            Spacer()
            
            Text("\(treasureItem.count)")
                .font(.body)
                .foregroundColor(.primary)
            
            Stepper(
                "",
                onIncrement: { treasureItem.count += 1 },
                onDecrement: { treasureItem.count -= 1 }
            )
        }
        .padding()
    }
}

struct SettingsView: View {
    @Query private var treasureItems: [TreasureItem]
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        NavigationView {
            List {
                ForEach(treasureItems, id: \.id) { item in
                    RowView(treasureItem: item)
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
    SettingsView()
}