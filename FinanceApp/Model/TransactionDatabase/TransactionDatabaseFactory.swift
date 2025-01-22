
import RealmSwift

//Инкапсуляция создания, чтобы в случае миграции не искать по всему коду места создания
final class TransactionDatabaseFactory {
    
    class func getDatabase() -> TransactionDatabase {
        let realm = try! Realm()
        let database = RealmTransactionDatabase(realm: realm)
        return database
    }
    
    class func getTestDatabase() -> TransactionDatabase {
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        let database = RealmTransactionDatabase(realm: realm)
        return database
    }
    
}
