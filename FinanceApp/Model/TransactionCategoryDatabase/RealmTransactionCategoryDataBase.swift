import Foundation
import RealmSwift

final class RealmTransactionCategoryDataBase: TransactionCategoryDatabase {
    
    let realm: Realm
    
    init(realm: Realm){
        self.realm = realm
    }
    
    //Fetching
    func allCategories() -> [any IdentifiableTransactionCategory] {
        return Array(realm.objects(RealmTransactionCategory.self))
    }
    
    func categories(of type: TransactionType) -> [any IdentifiableTransactionCategory] {
        return Array(realm.objects(RealmTransactionCategory.self))
    }
    
    func category(id: UUID) -> (any IdentifiableTransactionCategory)? {
        return realm.objects(RealmTransactionCategory.self).first
    }
    
    //Handilng
    @discardableResult func add(_ category: any TransactionCategory) -> (any IdentifiableTransactionCategory)? {
        
        let realmCategory = RealmTransactionCategory()
        
        do {
            try realm.write {
                realmCategory.copyValues(from: category)
                realm.add(realmCategory)
            }
        }
        catch { print(error.localizedDescription); return nil }
        
        return realmCategory
    }
    
    func update(_ category: any IdentifiableTransactionCategory, with newCategory: any TransactionCategory) {
        guard let realmCategory = category as? RealmTransactionCategory else { return }
        
        do {
            try realm.write {
                realmCategory.copyValues(from: newCategory)
            }
        } catch  { print(error.localizedDescription) }
    }
    
    func remove(category: any IdentifiableTransactionCategory) {
        guard let realmCategory = category as? RealmTransactionCategory else { return }
        do {
            try realm.write {
                realm.delete(realmCategory)
            }
        } catch { print(error.localizedDescription) }
    }
    
    
}
