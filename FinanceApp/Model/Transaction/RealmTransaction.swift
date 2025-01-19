
import Foundation
import RealmSwift

final class RealmTransaction: Object, IdentifiableTransaction {
    
    @Persisted var id: UUID = UUID()
    @Persisted var categoryID: UUID = UUID()
    @Persisted var amount: Double = 0
    @Persisted var date: Date = Date()
    @Persisted var information: String?
    
    func copyValues(from transaction: Transaction){
        self.categoryID = transaction.categoryID
        self.amount = transaction.amount
        self.date = transaction.date
        self.information = transaction.information
    }
    
}
