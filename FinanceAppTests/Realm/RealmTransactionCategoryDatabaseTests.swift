
import XCTest
import RealmSwift
@testable import FinanceApp

class RealmTransactionCategoryDatabaseTests: XCTestCase{
    
    var dataBase: RealmTransactionCategoryDataBase {
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        return RealmTransactionCategoryDataBase(realm: realm)
    }
    
    override func setUpWithError() throws {
        try super.setUpWithError()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testDatabaseSaveRetriveDelete(){
        let database = self.dataBase
        
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
        database.remove(category: retrived.first!)
        
        countObjcects = database.allCategories().count
        XCTAssertEqual(countObjcects, 0)
    }
    
    func testDatabaseUpdate(){
        let database = self.dataBase
        
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
    
    func testDatebaseCategoryFetching(){
        
        let database = self.dataBase
        
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
    
}

