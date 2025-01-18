
import Foundation

struct TransactionInfo: Transaction{
    var categoryID: UUID
    
    var type: TransactionType
    
    var amount: Double
    
    var date: Date
    
    var information: String?
    
    
}
