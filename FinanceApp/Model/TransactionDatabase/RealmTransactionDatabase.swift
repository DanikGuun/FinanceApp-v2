
import Foundation
import RealmSwift

final class RealmTransactionDatabase: TransactionDatabase {
    
    let realm: Realm
    var offset: Double = 0
    
    init(realm: Realm){
        self.realm = realm
    }
    
    //MARK: - Fetching
    func transaction(id: UUID) -> (any IdentifiableTransaction)? {
        let transaction = realm.objects(RealmTransaction.self).first(where: { $0.id == id } )
        return transaction
    }
    
    func allTransactions(period: DateInterval? = nil) -> [any IdentifiableTransaction] {
        let transactions = realm.objects(RealmTransaction.self).filter {
            period != nil ? period!.contains($0.date) : true
        }
        return Array(transactions)
    }

    func transactions(period: DateInterval?, category: any IdentifiableTransactionCategory) -> [any IdentifiableTransaction] {
        let transactions = self.allTransactions(period: period).filter { $0.categoryID == category.id }
        return Array(transactions)
    }
    
    //MARK: - Handling
    @discardableResult func add(transaction: any Transaction) -> (any IdentifiableTransaction)? {
        let realmTransaction = RealmTransaction()
        realmTransaction.copyValues(from: transaction)
        do {
            try realm.write {
                realm.add(realmTransaction)
            }
            return realmTransaction
        }
        catch { print(error.localizedDescription) }
        
        return nil
    }
    
    func update(_ transaction: any IdentifiableTransaction, with newTransaction: any Transaction) {
        guard let realmTransaction = transaction as? RealmTransaction else { return }
        
        do {
            try realm.write {
                realmTransaction.copyValues(from: newTransaction)
            }
        }
        catch { print(error.localizedDescription) }
    }
    
    func remove(transaction: any IdentifiableTransaction) {
        guard let realmTransaction = transaction as? RealmTransaction else { return }
        
        do {
            try realm.write {
                realm.delete(realmTransaction)
            }
        }
        catch { print(error.localizedDescription) }
    }
    
}
