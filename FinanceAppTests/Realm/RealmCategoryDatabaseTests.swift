
import XCTest
import RealmSwift
@testable import FinanceApp

final class RealmCategoryDatabaseTests: XCTestCase{
    
    var database: RealmCategoryDatabase!
    
    override func setUpWithError() throws {
        let conf = Realm.Configuration(inMemoryIdentifier: "testRealm")
        let realm = try! Realm(configuration: conf)
        self.database = RealmCategoryDatabase(realm: realm)
        try super.setUpWithError()
    }
    
    override func tearDown() {
        self.database = nil
        super.tearDown()
    }
    
    func testDatabaseSaveFetchDelete(){
        
        let database = self.database!
        
        //Save
        let transaction = DefaultCategory(name: "test1", type: .expense, iconId: "id", color: .cyan)
        
        database.addCategory(transaction)
        
        var countObjcects = database.getAllCategories().count
        XCTAssertEqual(countObjcects, 1)
        
        //Retrive
        let fetched = database.getAllCategories()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first!.name, "test1")
        XCTAssertEqual(fetched.first!.type, .expense)
        XCTAssertEqual(fetched.first!.iconId, "id")
        XCTAssertEqual(fetched.first!.color, .cyan)
        
        //Delete
        database.removeCategory(id: fetched.first!.id)
        
        countObjcects = database.getAllCategories().count
        XCTAssertEqual(countObjcects, 0)
        
    }
    
    func testDatabaseFetchWithInvalidID(){
        
        let database = self.database!
        let category = database.getCategory(id: UUID())
        XCTAssertNil(category)
        
    }
    
    func testDatabaseUpdate(){
        
        let database = self.database!
        
        let category = DefaultCategory(name: "Name", type: .expense, iconId: "id", color: .blue)
        let realmCategory = database.addCategory(category)
        XCTAssertNotNil(realmCategory)
        
        let newCategoryConf = DefaultCategory(name: "NewName", type: .income, iconId: "newId", color: .red)
        database.updateCategory(id: realmCategory!.id, with: newCategoryConf)
        
        let newRealmCategory = database.getCategory(id: realmCategory!.id)
        XCTAssertNotNil(newRealmCategory)
        XCTAssertEqual(newRealmCategory!.name, "NewName")
        XCTAssertEqual(newRealmCategory!.type, .income)
        XCTAssertEqual(newRealmCategory!.iconId, "newId")
        XCTAssertEqual(newRealmCategory!.color, .red)
        
    }
    
    func testDatebaseCategoryFetchingByID(){
        
        let database = self.database!
        
        let expenseCategory = RealmCategory()
        expenseCategory.copyValues(from: DefaultCategory(name: "Expense", type: .expense, iconId: "", color: .black))
        
        let incomeCategory = RealmCategory()
        incomeCategory.copyValues(from: DefaultCategory(name: "Income", type: .income, iconId: "", color: .black))
        
        let expenseCategoryID = database.addCategory(expenseCategory)?.id
        XCTAssertNotNil(expenseCategoryID)
        XCTAssertNotNil(database.getCategory(id: expenseCategoryID!))
        
        let incomeCategoryID = database.addCategory(incomeCategory)?.id
        XCTAssertNotNil(incomeCategoryID)
        XCTAssertNotNil(database.getCategory(id: incomeCategoryID!))
        
        XCTAssertEqual(database.getCategory(id: expenseCategoryID!)!.type, .expense)
        XCTAssertEqual(database.getCategory(id: incomeCategoryID!)!.type, .income)
        
        XCTAssertEqual(database.getCategories(of: .expense).count, 1)
        XCTAssertEqual(database.getCategories(of: .income).count, 1)
    }
    
    func testDatabaseCategoryFetchByType(){
        
        let database = self.database!
        
        let expenseCategory = RealmCategory()
        expenseCategory.copyValues(from: DefaultCategory(name: "Expence", type: .expense, iconId: "", color: .red))
        database.addCategory(expenseCategory)
        
        let incomeCategory = RealmCategory()
        incomeCategory.copyValues(from: DefaultCategory(name: "Income", type: .income, iconId: "", color: .red))
        database.addCategory(incomeCategory)
        
        let fetchedExpenseCategory = database.getCategories(of: .expense).first
        XCTAssertNotNil(fetchedExpenseCategory)
        XCTAssertEqual(fetchedExpenseCategory!.name, "Expence")
        XCTAssertEqual(fetchedExpenseCategory!.type, .expense)
        XCTAssertEqual(fetchedExpenseCategory!.iconId, "")
        XCTAssertEqual(fetchedExpenseCategory!.color, .red)
        
        let fetchedIncomeCategory = database.getCategories(of: .income).first
        XCTAssertNotNil(fetchedIncomeCategory)
        XCTAssertEqual(fetchedIncomeCategory!.name, "Income")
        XCTAssertEqual(fetchedIncomeCategory!.type, .income)
        XCTAssertEqual(fetchedIncomeCategory!.iconId, "")
        XCTAssertEqual(fetchedIncomeCategory!.color, .red)
        
    }
    
}

