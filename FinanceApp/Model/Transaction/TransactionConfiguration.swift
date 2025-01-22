
import Foundation

struct TransactionConfiguration: Transaction{
    
    var categoryID: UUID
    var amount: Double
    var date: Date
    var information: String?
    
}
