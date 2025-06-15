
import RealmSwift

final class CategoryDatabaseFactory {
    
    static func getDatabase() -> CategoryDatabase {
        let realm = try! Realm()
        let database = RealmCategoryDatabase(realm: realm)
        return database
    }
    
    static func getTestDatabase() -> CategoryDatabase {
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        let database = RealmCategoryDatabase(realm: realm)
        return database
    }
    
}
