
import Foundation

protocol IdentifiableTransactionCategory: TransactionCategory, Identifiable{
    
    var id: UUID { get }
    
}
