
import Foundation

protocol Transaction {
    
    var categoryID: UUID { get set }
    var amount: Double { get set }
    var date: Date { get set }
    var information: String? { get set }
    
}

protocol IdentifiableTransaction: Transaction, Identifiable {
    
    var id: UUID { get }
    
}
