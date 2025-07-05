

import XCTest
@testable import FinanceApp

final class AddTransactionModelTests: XCTestCase {
    
    fileprivate var transactions: MockTransactionDatabase!
    fileprivate var categories: MockCategoryDatabase!
    fileprivate var iconProvider: MockIconProvider!
    var model: AddTransactionModel!
    
    
    override func setUp() {
        transactions = MockTransactionDatabase()
        categories = MockCategoryDatabase()
        iconProvider = MockIconProvider()
        model = AddTransactionModel(transactionDatabase: transactions, categoryDatabase: categories, iconProvider: iconProvider)
        super.setUp()
    }
    
    override func tearDown() {
        transactions = nil
        categories = nil
        iconProvider = nil
        model = nil
        super.tearDown()
    }
    
    func testAddPerform() {
        let transaction = DefaultTransaction(amount: 1000)
        
        model.perform(transaction: transaction)
        
        let addedTransaction = transactions.transactions.first! as? DefaultTransaction
        XCTAssertEqual(addedTransaction, transaction)
    }
    
    func testFetchCategories() {
        let categoryList: [DefaultCategory] = [DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID(), type: .income), DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID()), DefaultCategory(id: UUID())]
        categories.categories = categoryList
        
        let fetched = model.getCategories(of: .expense).map { $0 as! DefaultCategory }
        let expected = Array(categoryList.filter({ $0.type == .expense })[0..<5])
        
        XCTAssertEqual(fetched, expected)
    }
    
    func testGetCategory() {
        let category = DefaultCategory()
        categories.categories = [category]
        
        let fetchedCategory = model.getCategory(id: category.id) as? DefaultCategory
        
        XCTAssertEqual(fetchedCategory, category)
    }
    
    func testGetIcon() {
        iconProvider.icons = [DefaultIcon(id: "icon")]
        
        let icon = model.getIcon(iconId: "icon")
        
        XCTAssertNotNil(icon)
    }
    
    func testGetCategoryType() {
        let category = DefaultCategory(type: .income)
        categories.categories = [category]
        let transaction = DefaultTransaction(categoryID: category.id)
        transactions.transactions = [transaction]
        
        let type = model.categoryType(forTransaction: transaction.id)
        
        XCTAssertEqual(type, .income)
    }
    
}

fileprivate class MockTransactionDatabase: TransactionDatabase {
    
    var transactions: [(any FinanceApp.IdentifiableTransaction)] = []
    
    var moneyOffset: Double = 0
    
    func getTransaction(id: UUID) -> (any FinanceApp.IdentifiableTransaction)? {
        return transactions.first { $0.id == id }
    }
    
    func getAllTransactions(interval: DateInterval?) -> [any FinanceApp.IdentifiableTransaction] { [] }
    
    func getTransactions(interval: DateInterval?, category: any FinanceApp.IdentifiableCategory) -> [any FinanceApp.IdentifiableTransaction] { [] }
    
    func addTransaction(_ transaction: any FinanceApp.Transaction) -> (any FinanceApp.IdentifiableTransaction)? {
        transactions.append(transaction as! any IdentifiableTransaction)
        return nil
    }
    
    func updateTransaction(id: UUID, with newTransaction: any FinanceApp.Transaction) {}
    
    func removeTransaction(id: UUID) {}
    
}

fileprivate class MockCategoryDatabase: CategoryDatabase {
    
    var categories: [(any FinanceApp.IdentifiableCategory)] = []
    
    func getCategory(id: UUID) -> (any FinanceApp.IdentifiableCategory)? {
        return categories.first { $0.id == id }
    }
    
    func getAllCategories() -> [any FinanceApp.IdentifiableCategory] {
        return categories
    }
    
    func getCategories(of type: FinanceApp.CategoryType) -> [any FinanceApp.IdentifiableCategory] {
        return categories.filter { $0.type == type }
    }
    
    func addCategory(_ category: any FinanceApp.Category) -> (any FinanceApp.IdentifiableCategory)? {
        categories.append(category as! any IdentifiableCategory)
        return nil
    }
    
    func updateCategory(id: UUID, with newCategory: any FinanceApp.Category) {}
    
    func removeCategory(id: UUID) {}
    
    
}

fileprivate class MockIconProvider: IconProvider {
    
    var icons: [any FinanceApp.Icon] = []
    
    func getIcons() -> [any FinanceApp.Icon] {
        return []
    }
    
    func getIcon(id: String) -> (any FinanceApp.Icon)? {
        return icons.first { $0.id == id }
    }
    
    func getIconsWithKind() -> [FinanceApp.IconKind : [any FinanceApp.Icon]] {
        return [:]
    }

}
