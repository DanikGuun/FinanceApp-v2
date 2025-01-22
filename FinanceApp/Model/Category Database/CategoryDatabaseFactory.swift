
import RealmSwift

//Инкапсуляция создания, чтобы в случае миграции не искать по всему коду места создания
final class CategoryDatabaseFactory {
    
    class func getDatabase() -> CategoryDatabase {
        
        let realm = try! Realm()
        let database = RealmCategoryDatabase(realm: realm)
        return database
        
    }
    
    class func getTestDatabase() -> CategoryDatabase {
        
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        let database = RealmCategoryDatabase(realm: realm)
        return database
        
    }
    
}
