
import Foundation

@MainActor
protocol Transaction{
    
    var categoryID: UUID { get set }
    var type: TransactionType { get set }
    var amount: Double { get set }
    var date: Date { get set }
    var information: String? { get set }
    
}

enum TransactionType: CustomStringConvertible {
    case income
    case expense
    
    var description: String{
        switch self {
        case .expense: return "Transaction type: Expense"
        case .income: return "Transaction type: Income"
        }
    }
}
