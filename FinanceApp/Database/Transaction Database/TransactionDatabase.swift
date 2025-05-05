
import Foundation

protocol TransactionDatabase{
    
    var moneyOffset: Double { get set }
    
    func getTransaction(id: UUID) -> (any IdentifiableTransaction)?
    func getAllTransactions(interval: DateInterval?) -> [any IdentifiableTransaction]
    func getTransactions(interval: DateInterval?, category: any IdentifiableCategory) -> [any IdentifiableTransaction]
    
    @discardableResult func addTransaction(_ transaction: any Transaction) -> (any IdentifiableTransaction)?
    func updateTransaction(_ transaction: any IdentifiableTransaction, with newTransaction: any Transaction)
    func removeTransaction(_ transaction: any IdentifiableTransaction)
    
}
