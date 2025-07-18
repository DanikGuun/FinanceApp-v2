
import Foundation
import RealmSwift

final class RealmTransactionDatabase: TransactionDatabase {
    
    let realm: Realm
    var moneyOffset: Double = 0 { didSet { UserDefaults.standard.set(moneyOffset, forKey: "TransactionsOffset") } }
    
    init(realm: Realm){
        self.realm = realm
        moneyOffset = UserDefaults.standard.double(forKey: "TransactionsOffset")
    }
    
    //MARK: - Fetching
    func getTransaction(id: UUID) -> (any IdentifiableTransaction)? {
        let transaction = realm.objects(RealmTransaction.self).first(where: { $0.id == id } )
        return transaction
    }
    
    func getAllTransactions(interval: DateInterval? = nil) -> [any IdentifiableTransaction] {
        
        let transactions = realm.objects(RealmTransaction.self).filter {
            interval != nil ? interval!.contains($0.date) : true
        }
        
        return Array(transactions)
    }

    func getTransactions(interval: DateInterval?, categoryId: UUID) -> [any IdentifiableTransaction] {
        let transactions = self.getAllTransactions(interval: interval).filter { $0.categoryID == categoryId }
        return Array(transactions)
    }
    
    //MARK: - Handling
    @discardableResult func addTransaction(_ transaction: any Transaction) -> (any IdentifiableTransaction)? {
        
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
    
    func updateTransaction(id: UUID, with newTransaction: any Transaction) {
        
        guard let realmTransaction = realm.objects(RealmTransaction.self).first(where: { $0.id == id }) else { return }

        do {
            try realm.write {
                realmTransaction.copyValues(from: newTransaction)
            }
        }
        catch { print(error.localizedDescription) }
        
    }
    
    func removeTransaction(id: UUID) {
        
        guard let realmTransaction = realm.objects(RealmTransaction.self).first(where: { $0.id == id }) else { return }
        
        do {
            try realm.write {
                realm.delete(realmTransaction)
            }
        }
        catch { print(error.localizedDescription) }
        
    }
    
}
