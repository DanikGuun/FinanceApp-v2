
import Foundation

struct DefaultTransaction: IdentifiableTransaction {
    var id = UUID()
    var categoryID: UUID = UUID()
    var amount: Double = 0
    var date: Date = Date()
    var information: String? = ""
}
