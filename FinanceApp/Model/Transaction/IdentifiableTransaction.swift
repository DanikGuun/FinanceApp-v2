
import Foundation

@MainActor
protocol IdentifiableTransaction: Transaction, Identifiable {
    
    var id: UUID { get }
    
}
