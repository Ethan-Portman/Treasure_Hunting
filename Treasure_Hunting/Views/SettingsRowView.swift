import SwiftUI
import os.log

/// A SwiftUI view representing a row for a treasure item in the SettingsView.
/// Users can modify the treasure item title and count in this view.
struct SettingsRowView: View {
    /// The treasure item associated with this row.
    @Bindable var treasureItem: TreasureItem
    /// The binding for the total number of items.
    @Binding var totalNumItems: Int
    /// The logger instance for logging messages.
    private let logger = Logger()
    
    var body: some View {
        HStack(spacing: 10) {
            // TextField for editing the title of the treasure item.
            TextField("Enter Title", text: $treasureItem.title)
            Spacer()
            
            // Display the count of the treasure item.
            Text("\(treasureItem.count)")
            
            // Stepper for adjusting the count of the treasure item.
            Stepper(
                "",
                onIncrement: incrementItemCount,
                onDecrement: decrementItemCount
            )
        }
        .padding()
    }
    
    /// Increment the count of the treasure item and update the total count.
    private func incrementItemCount() {
        if totalNumItems < Board.maxTreasureItems {
            treasureItem.count += 1
            totalNumItems += 1
        } else {
            logger.log("Cannot increment further. Maximum items reached.")
        }
    }
    
    /// Decrement the count of the treasure item and update the total count.
    private func decrementItemCount() {
        if treasureItem.count > 1 {
            treasureItem.count -= 1
            totalNumItems -= 1
        } else {
            logger.log("Cannot decrement further. Minimum items reached.")
        }
    }
}

#Preview {
    MainView()
}
