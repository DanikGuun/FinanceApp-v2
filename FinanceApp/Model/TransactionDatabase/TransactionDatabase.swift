
import Foundation

protocol TransactionDatabase{
    
    ///смещение счета, на случай, если надо изменить кол-во денег
    var offset: Double { get set }
    
    //Получение транзакций
    func transaction(id: UUID) -> [any IdentifiableTransaction]
    func transactions(period: DateInterval, type: TransactionType) -> [any IdentifiableTransaction]
    func transactions(period: DateInterval, category: TransactionCategory) -> [any IdentifiableTransaction]
    
    //действия с транзакциями
    func add(transaction: Transaction) -> any IdentifiableTransaction
    func update(_ transaction: any IdentifiableTransaction, with newTransaction: Transaction)
    func remove(id: UUID)
    
}
