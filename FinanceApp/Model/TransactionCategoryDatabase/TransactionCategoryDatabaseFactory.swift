
import RealmSwift

//Инкапсуляция создания, чтобы в случае миграции не искать по всему коду места создания
final class TransactionCategoryDatabaseFactory {
    
    class func getDatabase() -> TransactionCategoryDatabase{
        let realm = try! Realm()
        let database = RealmTransactionCategoryDatabase(realm: realm)
        return database
    }
    
}
