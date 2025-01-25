
import Foundation
import RealmSwift

final class RealmCategoryDatabase: CategoryDatabase {
    
    let realm: Realm
    
    init(realm: Realm){
        self.realm = realm
    }
    
    //MARK: - Fetching
    func getCategory(id: UUID) -> (any IdentifiableCategory)? {
        return realm.objects(RealmCategory.self).first(where: { $0.id == id } )
    }
    
    func getAllCategories() -> [any IdentifiableCategory] {
        return Array(realm.objects(RealmCategory.self))
    }
    
    func getCategories(of type: CategoryType) -> [any IdentifiableCategory] {
        return Array(realm.objects(RealmCategory.self).filter { $0.type == type } )
    }
    
    //MARK: - Handilng
    @discardableResult func addCategory(_ category: any Category) -> (any IdentifiableCategory)? {
        
        let realmCategory = RealmCategory()
        
        do {
            try realm.write {
                realmCategory.copyValues(from: category)
                realm.add(realmCategory)
            }
        }
        catch { print(error.localizedDescription); return nil }
        
        return realmCategory
    }
    
    func updateCategory(_ category: any IdentifiableCategory, with newCategory: any Category) {
        guard let realmCategory = category as? RealmCategory else { return }
        
        do {
            try realm.write {
                realmCategory.copyValues(from: newCategory)
            }
        } catch  { print(error.localizedDescription) }
    }
    
    func removeCategory(_ category: any IdentifiableCategory) {
        guard let realmCategory = category as? RealmCategory else { return }
        do {
            try realm.write {
                realm.delete(realmCategory)
            }
        } catch { print(error.localizedDescription) }
    }
    
    
}
