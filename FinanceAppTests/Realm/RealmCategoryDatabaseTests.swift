
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
        let transaction = CategoryConfiguration(name: "test1", type: .expense, iconID: "id", color: .cyan)
        
        database.add(transaction)
        
        var countObjcects = database.allCategories().count
        XCTAssertEqual(countObjcects, 1)
        
        //Retrive
        let fetched = database.allCategories()
        XCTAssertEqual(fetched.count, 1)
        XCTAssertEqual(fetched.first!.name, "test1")
        XCTAssertEqual(fetched.first!.type, .expense)
        XCTAssertEqual(fetched.first!.iconID, "id")
        XCTAssertEqual(fetched.first!.color, .cyan)
        
        //Delete
        database.remove(fetched.first!)
        
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
        
        let category = CategoryConfiguration(name: "Name", type: .expense, iconID: "id", color: .blue)
        let realmCategory = database.add(category)
        XCTAssertNotNil(realmCategory)
        
        let newCategoryConf = CategoryConfiguration(name: "NewName", type: .income, iconID: "newId", color: .red)
        database.update(realmCategory!, with: newCategoryConf)
        
        let newRealmCategory = database.category(id: realmCategory!.id)
        XCTAssertNotNil(newRealmCategory)
        XCTAssertEqual(newRealmCategory!.name, "NewName")
        XCTAssertEqual(newRealmCategory!.type, .income)
        XCTAssertEqual(newRealmCategory!.iconID, "newId")
        XCTAssertEqual(newRealmCategory!.color, .red)
        
    }
    
    func testDatebaseCategoryFetchingByID(){
        
        let database = self.database!
        
        let expenseCategory = RealmCategory()
        expenseCategory.copyValues(from: CategoryConfiguration(name: "Expense", type: .expense, iconID: "", color: .black))
        
        let incomeCategory = RealmCategory()
        incomeCategory.copyValues(from: CategoryConfiguration(name: "Income", type: .income, iconID: "", color: .black))
        
        let expenseCategoryID = database.add(expenseCategory)?.id
        XCTAssertNotNil(expenseCategoryID)
        XCTAssertNotNil(database.category(id: expenseCategoryID!))
        
        let incomeCategoryID = database.add(incomeCategory)?.id
        XCTAssertNotNil(incomeCategoryID)
        XCTAssertNotNil(database.category(id: incomeCategoryID!))
        
        XCTAssertEqual(database.category(id: expenseCategoryID!)!.type, .expense)
        XCTAssertEqual(database.category(id: incomeCategoryID!)!.type, .income)
        
        XCTAssertEqual(database.categories(of: .expense).count, 1)
        XCTAssertEqual(database.categories(of: .income).count, 1)
    }
    
    func testDatabaseCategoryFetchByType(){
        
        let database = self.database!
        
        let expenseCategory = RealmCategory()
        expenseCategory.copyValues(from: CategoryConfiguration(name: "Expence", type: .expense, iconID: "", color: .red))
        database.add(expenseCategory)
        
        let incomeCategory = RealmCategory()
        incomeCategory.copyValues(from: CategoryConfiguration(name: "Income", type: .income, iconID: "", color: .red))
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

