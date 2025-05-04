
import XCTest
import RealmSwift
@testable import FinanceApp

final class RealmTransactionsDatabaseTests: XCTestCase {
    
    var database: RealmTransactionDatabase!
    
    override func setUpWithError() throws {
        
        let conf = Realm.Configuration(inMemoryIdentifier: "test")
        let realm = try! Realm(configuration: conf)
        self.database =  RealmTransactionDatabase(realm: realm)
        
        try super.setUpWithError()
    }
    
    override func tearDown() {
        
        self.database = nil
        
        super.tearDown()
    }
    
    //MARK: - Fetching
    func testDatabaseSaveRetriveDelete() {
        
        let database = self.database!
        
        let transactionConf = DefaultTransaction(categoryID: UUID(), amount: 100, date: Date(timeIntervalSince1970: 10))
        let realmTransaction = database.addTransaction(transactionConf)
        XCTAssertNotNil(realmTransaction)
        
        var transactions = database.getAllTransactions()
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first!.id, realmTransaction!.id)
        
        database.removeTransaction(realmTransaction!)
        transactions = database.getAllTransactions()
        XCTAssertEqual(transactions.count, 0)
        
    }
    
    func testDatabaseRetriveWithInvalidID() {
        
        let database = self.database!
        let transaction = database.getTransaction(id: UUID())
        XCTAssertNil(transaction)
        
    }
    
    func testDatabaseUpdate() {
        
        let dataBase = self.database!
        
        let transactionConf = DefaultTransaction(categoryID: UUID(), amount: 0, date: Date(timeIntervalSince1970: 10))
        var realmTransaction = dataBase.addTransaction(transactionConf)
        
        XCTAssertNotNil(realmTransaction)
        
        let newTransactionConf = DefaultTransaction(categoryID: UUID(), amount: 10, date: Date(timeIntervalSince1970: 1000))
        dataBase.updateTransaction(realmTransaction!, with: newTransactionConf)
        
        realmTransaction = dataBase.getTransaction(id: realmTransaction!.id)
        
        XCTAssertEqual(realmTransaction!.categoryID, newTransactionConf.categoryID)
        XCTAssertEqual(realmTransaction!.amount, newTransactionConf.amount)
        XCTAssertEqual(realmTransaction!.date, newTransactionConf.date)
        
    }
    
    //MARK: - DateInterval
    func dateIntervalTest(taskDate: Double, start: Double, end: Double, result: Bool){
        
        let database = self.database!
        
        let transactionConf = DefaultTransaction(categoryID: UUID(), amount: 10, date: Date(timeIntervalSince1970: taskDate))
        database.addTransaction(transactionConf)
        
        let startDate = Date(timeIntervalSince1970: start)
        let endDate = Date(timeIntervalSince1970: end)
        let dateInterval = DateInterval(start: startDate, end: endDate)
        
        let count = database.getAllTransactions(interval: dateInterval).count
        
        XCTAssertEqual(count, result ? 1 : 0)
        
    }
    
    func testDatabaseDateIntervalInBoundsSelection(){
        dateIntervalTest(taskDate: 50, start: 0, end: 100, result: true)
    }
    
    func testDatabaseDateIntervalOutOfBoundsSelection(){
        dateIntervalTest(taskDate: 50, start: 100, end: 200, result: false)
    }
    
    func testDatabaseDateIntervalLeftBoundSelection(){
        dateIntervalTest(taskDate: 10, start: 10, end: 50, result: true)
    }
    
    func testDatabaseDateIntervalRightBoundSelection(){
        dateIntervalTest(taskDate: 90, start: 0, end: 90, result: true)
    }
    
    //MARK: Category selection
    func testCategorySelection(){
        
        let category = MockTransactionCategory(id: UUID(), name: "name", type: .expense, iconID: "id", color: .black)
        
        let transactionWithCorrectID = DefaultTransaction(categoryID: category.id, amount: 10, date: Date(timeIntervalSince1970: 10))
        let transactionWithIncorrectID = DefaultTransaction(categoryID: UUID(), amount: 20, date: Date(timeIntervalSince1970: 20))
        database.addTransaction(transactionWithCorrectID)
        database.addTransaction(transactionWithIncorrectID)
        
        let transactions = database.getTransactions(interval: nil, category: category)
        XCTAssertEqual(transactions.count, 1)
        XCTAssertEqual(transactions.first!.amount, 10)
        
    }
    
}

private struct MockTransactionCategory: IdentifiableCategory{
    
    var id: UUID
    var name: String
    var type: FinanceApp.CategoryType
    var iconID: String
    var color: UIColor
    
}
