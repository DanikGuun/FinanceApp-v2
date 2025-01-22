
import RealmSwift

//Инкапсуляция создания, чтобы в случае миграции не искать по всему коду места создания
final class TransactionCategoryDatabaseFactory {
    
    class func getDatabase() -> TransactionCategoryDatabase{
        let realm = try! Realm()
        let database = RealmTransactionCategoryDatabase(realm: realm)
        return database
    }
    
    class func getTestDatabase() -> TransactionCategoryDatabase{
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        let database = RealmTransactionCategoryDatabase(realm: realm)
        return database
    }
    
}
