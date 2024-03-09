import Foundation
import SwiftData
import UIKit

/// A model representing a treasure item in a treasure hunting game.
/// Conforms to the Identifiable protocol for unique identification.
@Model class TreasureItem: Identifiable {
    /// The unique identifier for the treasure item.
    let id = UUID()
    
    /// The title or name of the treasure item.
    var title = ""
    
    /// The count or quantity of the treasure item.
    var count = 0
    
    ///  Initializes a new instance of the `TreasureItem` class with the specified title and count.
    /// - Parameter title: The title or name of the treasure item.
    /// - Parameter count:  The count or quantity of the treasure item.
    init(title: String, count: Int) {
        self.title = title
        self.count = count
    }
}
