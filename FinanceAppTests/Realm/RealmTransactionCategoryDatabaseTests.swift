
import XCTest
import RealmSwift
@testable import FinanceApp

final class RealmTransactionCategoryDatabaseTests: XCTestCase{
    
    var database: RealmTransactionCategoryDatabase!
    
    override func setUpWithError() throws {
        
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        self.database = RealmTransactionCategoryDatabase(realm: realm)
        
        try super.setUpWithError()
    }
    
    override func tearDown() {
        
        self.database = nil
        
        super.tearDown()
    }
    
    func testDatabaseSaveRetriveDelete(){
        
        let database = self.database!
        
        //Save
        let transaction = TransactionCategoryInfo(name: "test1", type: .expense, iconID: "id", color: .cyan)
        
        database.add(transaction)
        
        var countObjcects = database.allCategories().count
        XCTAssertEqual(countObjcects, 1)
        
        //Retrive
        let retrived = database.allCategories()
        XCTAssertEqual(retrived.count, 1)
        XCTAssertEqual(retrived.first!.name, "test1")
        XCTAssertEqual(retrived.first!.type, .expense)
        XCTAssertEqual(retrived.first!.iconID, "id")
        XCTAssertEqual(retrived.first!.color, .cyan)
        
        //Delete
        database.remove(retrived.first!)
        
        countObjcects = database.allCategories().count
        XCTAssertEqual(countObjcects, 0)
        
    }
    
    func testDatabaseFetchWithInvalidID(){
        
        let database = self.database!
        let category = database.category(id: UUID())
        XCTAssertNil(category)
        
    }
    
    func testDatabaseUpdate(){
        
        let database = self.database!
        
        let category = TransactionCategoryInfo(name: "Name", type: .expense, iconID: "id", color: .blue)
        let realmCategory = database.add(category)
        XCTAssertNotNil(realmCategory)
        
        let newCategoryInfo = TransactionCategoryInfo(name: "NewName", type: .income, iconID: "newId", color: .red)
        database.update(realmCategory!, with: newCategoryInfo)
        
        let newRealmCategory = database.category(id: realmCategory!.id)
        XCTAssertNotNil(newRealmCategory)
        XCTAssertEqual(newRealmCategory!.name, "NewName")
        XCTAssertEqual(newRealmCategory!.type, .income)
        XCTAssertEqual(newRealmCategory!.iconID, "newId")
        XCTAssertEqual(newRealmCategory!.color, .red)
        
    }
    
    func testDatebaseCategoryFetchingByID(){
        
        let database = self.database!
        
        let expenseCategory = RealmTransactionCategory()
        expenseCategory.copyValues(from: TransactionCategoryInfo(name: "Expense", type: .expense, iconID: "", color: .black))
        
        let incomeCategory = RealmTransactionCategory()
        incomeCategory.copyValues(from: TransactionCategoryInfo(name: "Income", type: .income, iconID: "", color: .black))
        
        let expenseID = database.add(expenseCategory)?.id
        XCTAssertNotNil(expenseID)
        XCTAssertNotNil(database.category(id: expenseID!))
        
        let incomeID = database.add(incomeCategory)?.id
        XCTAssertNotNil(incomeID)
        XCTAssertNotNil(database.category(id: incomeID!))
        
        XCTAssertEqual(database.category(id: expenseID!)!.type, .expense)
        XCTAssertEqual(database.category(id: incomeID!)!.type, .income)
        
        XCTAssertEqual(database.categories(of: .expense).count, 1)
        XCTAssertEqual(database.categories(of: .income).count, 1)
    }
    
    func testDatabaseCategoryFetchingByType(){
        
        let database = self.database!
        
        let expenseCategory = RealmTransactionCategory()
        expenseCategory.copyValues(from: TransactionCategoryInfo(name: "Expence", type: .expense, iconID: "", color: .red))
        database.add(expenseCategory)
        
        let incomeCategory = RealmTransactionCategory()
        incomeCategory.copyValues(from: TransactionCategoryInfo(name: "Income", type: .income, iconID: "", color: .red))
        database.add(incomeCategory)
        
        let fetchedExpenseCategory = database.categories(of: .expense).first
        XCTAssertNotNil(fetchedExpenseCategory)
        XCTAssertEqual(fetchedExpenseCategory!.name, "Expence")
        XCTAssertEqual(fetchedExpenseCategory!.type, .expense)
        XCTAssertEqual(fetchedExpenseCategory!.iconID, "")
        XCTAssertEqual(fetchedExpenseCategory!.color, .red)
        
        let fetchedIncomeCategory = database.categories(of: .income).first
        XCTAssertNotNil(fetchedIncomeCategory)
        XCTAssertEqual(fetchedIncomeCategory!.name, "Income")
        XCTAssertEqual(fetchedIncomeCategory!.type, .income)
        XCTAssertEqual(fetchedIncomeCategory!.iconID, "")
        XCTAssertEqual(fetchedIncomeCategory!.color, .red)
        
    }
    
}

