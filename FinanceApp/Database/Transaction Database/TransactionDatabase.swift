
import Foundation

protocol TransactionDatabase{
    
    var moneyOffset: Double { get set }
    
    func getTransaction(id: UUID) -> (any IdentifiableTransaction)?
    func getAllTransactions(interval: DateInterval?) -> [any IdentifiableTransaction]
    func getTransactions(interval: DateInterval?, categoryId: UUID) -> [any IdentifiableTransaction]
    
    @discardableResult func addTransaction(_ transaction: any Transaction) -> (any IdentifiableTransaction)?
    func updateTransaction(id: UUID, with newTransaction: any Transaction)
    func removeTransaction(id: UUID)
    
}
