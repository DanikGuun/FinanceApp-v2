
import Foundation

protocol TransactionDatabase{
    
    ///смещение счета, на случай, если надо изменить кол-во денег
    var offset: Double { get set }
    
    //Получение транзакций
    func getTransaction(id: UUID) -> (any IdentifiableTransaction)?
    func getAllTransactions(interval: DateInterval?) -> [any IdentifiableTransaction]
    func getTransactions(interval: DateInterval?, category: any IdentifiableCategory) -> [any IdentifiableTransaction]
    
    //действия с транзакциями
    @discardableResult func addTransaction(_ transaction: any Transaction) -> (any IdentifiableTransaction)?
    func updateTransaction(_ transaction: any IdentifiableTransaction, with newTransaction: any Transaction)
    func removeTransaction(_ transaction: any IdentifiableTransaction)
    
}
