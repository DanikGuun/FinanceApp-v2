
import Foundation

protocol IdentifiableTransaction: Transaction, Identifiable {
    
    var id: UUID { get }
    
}
