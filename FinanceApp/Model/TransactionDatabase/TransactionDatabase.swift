
import Foundation

protocol TransactionDatabase{
    
    ///смещение счета, на случай, если надо изменить кол-во денег
    var offset: Double { get set }
    
    //Получение транзакций
    func transaction(id: UUID) -> (any IdentifiableTransaction)?
    func allTransactions(period: DateInterval?) -> [any IdentifiableTransaction]
    func transactions(period: DateInterval?, category: any IdentifiableTransactionCategory) -> [any IdentifiableTransaction]
    
    //действия с транзакциями
    @discardableResult func add(transaction: any Transaction) -> (any IdentifiableTransaction)?
    func update(_ transaction: any IdentifiableTransaction, with newTransaction: any Transaction)
    func remove(transaction: any IdentifiableTransaction)
    
}
