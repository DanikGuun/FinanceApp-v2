
import Foundation

protocol Transaction{
    
    var categoryID: UUID { get set }
    var amount: Double { get set }
    var date: Date { get set }
    var information: String? { get set }
    
}

enum TransactionType: String, CustomStringConvertible {
    case income = "Income"
    case expense = "Expense"
    
    var description: String{
        return "Transaction type: \(rawValue)"
    }
}
