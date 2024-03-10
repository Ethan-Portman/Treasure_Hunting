import SwiftUI
import os.log

/// A SwiftUI view representing a row for a treasure item in the settings.
/// In this view the treasure item title and count can be modified
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
            TextField("", text: $treasureItem.title)
            Spacer()
            
            // Display the count of the treasure item.
            Text("\(treasureItem.count)")
            
            // Stepper for adjusting the count of the treasure item.
            Stepper(
                "",
                onIncrement: {
                    if totalNumItems < Board.maxTreasureItems  {
                        treasureItem.count += 1
                        totalNumItems += 1
                    } else {
                        logger.log("Cannot increment further. Maximum items reached.")
                    }
                },
                onDecrement: {
                    if treasureItem.count > 1 {
                        treasureItem.count -= 1
                        totalNumItems -= 1
                    } else {
                        logger.log("Cannot decrement further. Minimum items reached.")
                    }
                }
            )
        }
        .padding()
    }
}

#Preview {
    MainView()
}
