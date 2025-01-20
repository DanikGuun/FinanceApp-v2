

import XCTest
import RealmSwift
@testable import FinanceApp

final class RealmTransactionAndCategoryTests: XCTestCase {
    
    var transactionsDatabase: RealmTransactionDatabase {
        let conf = Realm.Configuration(inMemoryIdentifier: "test")
        let realm = try! Realm(configuration: conf)
        return RealmTransactionDatabase(realm: realm)
    }
    
    var categoryDatabase: RealmTransactionCategoryDatabase {
        let conf = Realm.Configuration(inMemoryIdentifier: "test")
        let realm = try! Realm(configuration: conf)
        return RealmTransactionCategoryDatabase(realm: realm)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override class func tearDown() {
        super.tearDown()
    }
    
    func testTransactionAndCategoryInteraction(){
        
        let category = categoryDatabase.add(TransactionCategoryInfo(name: "Expense", type: .expense, iconID: "", color: .red))
        XCTAssertNotNil(category)
        
        let transaction = transactionsDatabase.add(transaction: TransactionInfo(categoryID: category!.id, amount: 100, date: Date(timeIntervalSince1970: 0)))
        XCTAssertNotNil(transaction)
        
        let fetchedCategory = categoryDatabase.category(id: transaction!.categoryID)
        XCTAssertEqual(category!.id, fetchedCategory!.id)
        XCTAssertEqual(category!.name, fetchedCategory!.name)
        XCTAssertEqual(category!.type, fetchedCategory!.type)
        XCTAssertEqual(category!.color, fetchedCategory!.color)
        XCTAssertEqual(category!.iconID, fetchedCategory!.iconID)
        
    }
}
