import SwiftUI

struct SettingsRowView: View {
    @Bindable var treasureItem: TreasureItem
    
    var numItems = 5
    var maxItems = 20


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
                    if numItems < maxItems {
                        treasureItem.count += 1
                        //numItems += 1
                    } else {
                        // Optionally handle reaching maxItems, e.g., show an alert
                        print("Cannot increment further. Maximum items reached.")
                    }
                },
                onDecrement: {
                    if treasureItem.count > 1 && numItems > 0 {
                        treasureItem.count -= 1
                        //numItems -= 1
                    } else {
                        // Optionally handle reaching minimum count or numItems, e.g., show an alert
                        print("Cannot decrement further. Minimum count or numItems reached.")
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
