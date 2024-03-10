import SwiftUI
import os.log

struct SettingsRowView: View {
    @Bindable var treasureItem: TreasureItem
    @Binding var totalNumItems: Int
    private let logger = Logger()

    var body: some View {
        HStack(spacing: 10) {
            TextField("", text:
                Binding(
                    get: { treasureItem.title },
                    set: { newValue in treasureItem.title = newValue }
                )
            )
            
            Spacer()
            
            Text("\(treasureItem.count)")

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
