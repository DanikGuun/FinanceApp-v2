

import XCTest
import RealmSwift
@testable import FinanceApp

final class RealmTransactionAndCategoryTests: XCTestCase {
    
    var transactionsDatabase: RealmTransactionDatabase!
    
    var categoryDatabase: RealmCategoryDatabase!
    
    override func setUpWithError() throws {
        
        let conf = Realm.Configuration(inMemoryIdentifier: "test")
        let realm = try! Realm(configuration: conf)
        
        self.transactionsDatabase = RealmTransactionDatabase(realm: realm)
        self.categoryDatabase = RealmCategoryDatabase(realm: realm)
        
        try super.setUpWithError()
    }
    
    override func tearDown() {
        
        self.categoryDatabase = nil
        self.transactionsDatabase = nil
        
        super.tearDown()
    }
    
    func testTransactionAndCategoryInteraction(){
        
        let category = categoryDatabase.addCategory(DefaultCategory(name: "Expense", type: .expense, iconId: "", color: .red))
        XCTAssertNotNil(category)
        
        let transaction = transactionsDatabase.addTransaction(DefaultTransaction(categoryID: category!.id, amount: 100, date: Date(timeIntervalSince1970: 0)))
        XCTAssertNotNil(transaction)
        
        let fetchedCategory = categoryDatabase.getCategory(id: transaction!.categoryID)
        XCTAssertNotNil(fetchedCategory)
        XCTAssertEqual(category!.id, fetchedCategory!.id)
        XCTAssertEqual(category!.name, fetchedCategory!.name)
        XCTAssertEqual(category!.type, fetchedCategory!.type)
        XCTAssertEqual(category!.color, fetchedCategory!.color)
        XCTAssertEqual(category!.iconId, fetchedCategory!.iconId)
        
    }
    
}
