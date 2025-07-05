
import Foundation

protocol Transaction: Equatable {
    var categoryID: UUID { get set }
    var amount: Double { get set }
    var date: Date { get set }
    var information: String? { get set }
}

protocol IdentifiableTransaction: Transaction, Identifiable, Equatable {
    var id: UUID { get }
}
