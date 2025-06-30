
import RealmSwift


final class TransactionDatabaseFactory {
    
    class func getInstance() -> TransactionDatabase {
        let realm = try! Realm()
        print(realm.configuration.fileURL?.path())
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
